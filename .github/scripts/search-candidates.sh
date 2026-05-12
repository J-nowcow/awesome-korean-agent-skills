#!/usr/bin/env bash
# search-candidates.sh
# GitHub Search API로 스킬 후보 레포를 수집해 /tmp/candidates.json에 저장
#
# Requirements:
#   - gh CLI (GitHub CLI) with GH_TOKEN
#   - jq

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
KNOWN_REPOS_FILE="${ROOT}/data/known-repos.json"
OUTPUT_FILE="/tmp/candidates.json"
COUNT_FILE="/tmp/candidate-count"
TMP_MERGED="/tmp/candidates-merged.json"

# 1회 실행 시 분류할 최대 후보 수 (Gemini API rate limit + 시간 예측 가능성)
PER_QUERY_LIMIT="${PER_QUERY_LIMIT:-30}"
MAX_CANDIDATES="${MAX_CANDIDATES:-40}"
# 한 번에 실행할 쿼리 수 (전체 쿼리 풀 중 시간 기반으로 선택)
QUERY_BATCH_SIZE="${QUERY_BATCH_SIZE:-8}"

echo "▶ search-candidates.sh 시작"

# known-repos.json에서 이미 처리된 URL 목록 추출
KNOWN_URLS="$(jq -r '.repos[].url' "${KNOWN_REPOS_FILE}" 2>/dev/null || echo "")"

# 6개월 전 날짜 계산 (Linux/macOS 양쪽 지원)
SIX_MONTHS_AGO="$(date -d '6 months ago' '+%Y-%m-%d' 2>/dev/null || date -v-6m '+%Y-%m-%d')"
echo "  6개월 기준일: ${SIX_MONTHS_AGO}"

# 검색 쿼리 풀 (30개)
# 매 실행마다 시간(UTC hour) 기반 라운드로빈으로 QUERY_BATCH_SIZE만큼 선택해
# 같은 시간대 cron이 매번 동일 쿼리를 반복하지 않고 다양한 검색 영역 탐색.
QUERY_POOL=(
  # 그룹 0 (UTC hour % 4 == 0): topic 기반
  "topic:claude-skills"
  "topic:agent-skills"
  "topic:claude-code"
  "topic:gemini-cli"
  "topic:cursor-rules"
  "topic:windsurf"
  "topic:claude-code-skills"
  "topic:mcp-server"
  # 그룹 1 (UTC hour % 4 == 1): filename / 영문 readme
  "filename:SKILL.md"
  "\"claude code skill\" in:readme"
  "\"subagent\" in:readme"
  "\".claude/skills\" in:readme"
  "\"MCP server\" in:readme language:korean"
  "\"CLAUDE.md\" in:readme language:korean"
  "\"agent skill\" in:readme language:korean"
  "\"claude-code-skills\" in:readme"
  # 그룹 2 (UTC hour % 4 == 2): 한국어 readme 키워드
  "\"에이전트 스킬\" in:readme"
  "\"claude-code 한국어\" in:readme"
  "\"클로드 코드\" in:readme"
  "\"바이브 코딩\" in:readme"
  "\"프롬프트 엔지니어링\" in:readme"
  "\"AI 자동화\" in:readme language:korean"
  "\"커서 룰\" in:readme"
  "\"한국어 LLM\" in:readme"
  # 그룹 3 (UTC hour % 4 == 3): 도구·확장 키워드
  "topic:ai-coding"
  "topic:llm-agent"
  "topic:vibe-coding"
  "topic:anthropic-skills"
  "\"Claude Code 가이드\" in:readme"
  "\"Gemini CLI 한국어\" in:readme"
)

# 시간 기반 그룹 선택: UTC hour를 4로 나눈 나머지로 그룹 결정.
# UTC 15시(KST 자정) = 그룹3, 16시 = 그룹0, 17시 = 그룹1, 18시 = 그룹2, 19시 = 그룹3
# 5회 cron 동안 모든 그룹 covered + 1회 중복.
UTC_HOUR="$(date -u +%H | sed 's/^0//')"
[ -z "${UTC_HOUR}" ] && UTC_HOUR=0
GROUP=$((UTC_HOUR % 4))
START=$((GROUP * QUERY_BATCH_SIZE))
QUERIES=("${QUERY_POOL[@]:${START}:${QUERY_BATCH_SIZE}}")

echo "  쿼리 그룹: ${GROUP} (UTC hour ${UTC_HOUR}, ${QUERY_BATCH_SIZE}개 쿼리 선택)"

# 결과를 누적할 임시 파일 초기화
echo "[]" > "${TMP_MERGED}"

for QUERY in "${QUERIES[@]}"; do
  echo "  검색: ${QUERY}"

  # gh search repos 실행
  RESULTS="$(gh search repos \
    --limit "${PER_QUERY_LIMIT}" \
    --json url,name,description,stargazersCount,updatedAt,isArchived \
    -- "${QUERY}" 2>/dev/null || echo "[]")"

  if [ -z "${RESULTS}" ] || [ "${RESULTS}" = "null" ]; then
    RESULTS="[]"
  fi

  # 필터링:
  #   1. isArchived == false
  #   2. stargazersCount >= 2  (1은 본인 self-star만 있는 경우가 많아 의미 없음)
  #   3. updatedAt >= 6개월 전
  FILTERED="$(echo "${RESULTS}" | jq --arg since "${SIX_MONTHS_AGO}" '
    [.[] |
      select(.isArchived == false) |
      select(.stargazersCount >= 2) |
      select(.updatedAt >= $since)
    ] |
    map({url, name, description, stargazersCount, updatedAt})
  ')"

  # 기존 결과와 병합
  MERGED="$(jq -s '.[0] + .[1]' "${TMP_MERGED}" <(echo "${FILTERED}"))"
  echo "${MERGED}" > "${TMP_MERGED}"

  echo "    → 필터 후 후보: $(echo "${FILTERED}" | jq 'length')개"

  # Rate limiting
  sleep 2
done

echo "▶ 중복 제거 및 known-repos 필터링"

# known-repos URL 목록을 JSON 배열로 만들어 필터링
KNOWN_JSON="$(jq -r '.repos[].url' "${KNOWN_REPOS_FILE}" | jq -R '[.,inputs]' | jq -s '.[0]')"

FINAL="$(jq --argjson known "${KNOWN_JSON}" '
  unique_by(.url) |
  map(select(.url as $u | ($known | index($u)) == null))
' "${TMP_MERGED}")"

DEDUPED_COUNT="$(echo "${FINAL}" | jq 'length')"

# 후보 수 cap 적용 (stars 내림차순으로 우선 선별 → 1회 실행 시간 예측 가능)
if [ "${DEDUPED_COUNT}" -gt "${MAX_CANDIDATES}" ]; then
  echo "  후보 ${DEDUPED_COUNT}개 → ${MAX_CANDIDATES}개로 cap (stars 내림차순)"
  FINAL="$(echo "${FINAL}" | jq --argjson cap "${MAX_CANDIDATES}" '
    sort_by(-.stargazersCount) | .[0:$cap]
  ')"
fi

echo "${FINAL}" > "${OUTPUT_FILE}"

CANDIDATE_COUNT="$(echo "${FINAL}" | jq 'length')"
echo "${CANDIDATE_COUNT}" > "${COUNT_FILE}"

echo "▶ 완료: 신규 후보 ${CANDIDATE_COUNT}개 (dedup 후 ${DEDUPED_COUNT}개) → ${OUTPUT_FILE}"
