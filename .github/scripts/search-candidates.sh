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

echo "▶ search-candidates.sh 시작"

# known-repos.json에서 이미 처리된 URL 목록 추출
KNOWN_URLS="$(jq -r '.repos[].url' "${KNOWN_REPOS_FILE}" 2>/dev/null || echo "")"

# 6개월 전 날짜 계산 (Linux/macOS 양쪽 지원)
SIX_MONTHS_AGO="$(date -d '6 months ago' '+%Y-%m-%d' 2>/dev/null || date -v-6m '+%Y-%m-%d')"
echo "  6개월 기준일: ${SIX_MONTHS_AGO}"

# 검색 쿼리 목록
QUERIES=(
  "topic:claude-skills"
  "topic:agent-skills"
  "topic:claude-code"
  "topic:gemini-cli"
  "filename:SKILL.md"
  "\"claude code skill\" in:readme"
  "\"에이전트 스킬\" in:readme"
  "\"claude-code 한국어\" in:readme"
)

# 결과를 누적할 임시 파일 초기화
echo "[]" > "${TMP_MERGED}"

for QUERY in "${QUERIES[@]}"; do
  echo "  검색: ${QUERY}"

  # gh search repos 실행
  RESULTS="$(gh search repos \
    --limit 50 \
    --json url,name,description,stargazersCount,updatedAt,isArchived \
    -- "${QUERY}" 2>/dev/null || echo "[]")"

  if [ -z "${RESULTS}" ] || [ "${RESULTS}" = "null" ]; then
    RESULTS="[]"
  fi

  # 필터링:
  #   1. isArchived == false
  #   2. stargazersCount >= 1
  #   3. updatedAt >= 6개월 전
  FILTERED="$(echo "${RESULTS}" | jq --arg since "${SIX_MONTHS_AGO}" '
    [.[] |
      select(.isArchived == false) |
      select(.stargazersCount >= 1) |
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

# URL 기준 중복 제거 + known-repos 제외
FINAL="$(jq --argjson known "$(echo "${KNOWN_URLS}" | jq -R '[.,inputs]' | jq -s '.[0]')" '
  unique_by(.url) |
  map(select(.url as $u | ($known | index($u)) == null))
' "${TMP_MERGED}")"

# known-repos URL 목록을 JSON 배열로 만들어 필터링
KNOWN_JSON="$(jq -r '.repos[].url' "${KNOWN_REPOS_FILE}" | jq -R '[.,inputs]' | jq -s '.[0]')"

FINAL="$(jq --argjson known "${KNOWN_JSON}" '
  unique_by(.url) |
  map(select(.url as $u | ($known | index($u)) == null))
' "${TMP_MERGED}")"

echo "${FINAL}" > "${OUTPUT_FILE}"

CANDIDATE_COUNT="$(echo "${FINAL}" | jq 'length')"
echo "${CANDIDATE_COUNT}" > "${COUNT_FILE}"

echo "▶ 완료: 신규 후보 ${CANDIDATE_COUNT}개 → ${OUTPUT_FILE}"
