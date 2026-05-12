#!/usr/bin/env bash
# generate-trends.sh — known-repos.json의 last_scanned 기반 일자별 누적 추이를
# docs/trends.md에 갱신
#
# 출력:
#   - 일자별 신규 등록 레포 수 (markdown 표)
#   - 일자별 카테고리 추가 수 (skills 배열 비어있지 않은 행)
#   - 누적 라인 mermaid xychart-beta (GitHub 지원)
#   - 최근 7일 + 누적 합산 요약
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
KNOWN="$ROOT/data/known-repos.json"
TRENDS="$ROOT/docs/trends.md"

if [[ ! -f "$KNOWN" ]]; then
  echo "[generate-trends] known-repos.json 없음 — skip"
  exit 0
fi

if ! command -v jq &>/dev/null; then
  echo "[generate-trends] jq 미설치 — skip"
  exit 0
fi

mkdir -p "$ROOT/docs"

# ── 1. 일자별 데이터 추출 ─────────────────────────────────────────────────
# 각 repo의 last_scanned 날짜만 잘라서 그룹화
DAILY_TMP="$(mktemp)"
jq -r '.repos[] | "\(.last_scanned[0:10])\t\(.skills | length)"' "$KNOWN" \
  | sort > "$DAILY_TMP"

# 일자별 카운트 (총 처리, 카테고리 추가)
DAILY_STATS="$(mktemp)"
awk -F'\t' '
{
  total[$1]++
  if ($2 > 0) added[$1]++
}
END {
  for (d in total) {
    printf "%s\t%d\t%d\n", d, total[d], (d in added ? added[d] : 0)
  }
}' "$DAILY_TMP" | sort > "$DAILY_STATS"

# ── 2. 통계 계산 ──────────────────────────────────────────────────────────
TOTAL_REPOS="$(jq '.repos | length' "$KNOWN")"
TOTAL_ADDED="$(jq '[.repos[] | select(.skills | length > 0)] | length' "$KNOWN")"
FIRST_DAY="$(head -1 "$DAILY_STATS" | cut -f1)"
LAST_DAY="$(tail -1 "$DAILY_STATS" | cut -f1)"
ACTIVE_DAYS="$(wc -l < "$DAILY_STATS" | tr -d ' ')"

# ── 3. trends.md 작성 ─────────────────────────────────────────────────────
TODAY="$(date -u +%Y-%m-%d)"
{
  echo "# 📈 Trends"
  echo ""
  echo "> known-repos.json의 \`last_scanned\` 기준 일자별 처리 추이. **자동 생성** — 직접 수정 금지."
  echo ">"
  echo "> [← 메인으로](../README.md) · [Architecture →](architecture.md)"
  echo ""
  echo "---"
  echo ""
  echo "## 한눈에"
  echo ""
  echo '<table>'
  echo '<tr align="center">'
  echo "<td>📅 <b>운영 기간</b></td>"
  echo "<td>📦 <b>총 처리 레포</b></td>"
  echo "<td>✅ <b>카테고리 추가</b></td>"
  echo "<td>📊 <b>활성 일수</b></td>"
  echo '</tr>'
  echo '<tr align="center">'
  echo "<td><sub>${FIRST_DAY} →<br/>${LAST_DAY}</sub></td>"
  echo "<td><h2>${TOTAL_REPOS}</h2></td>"
  echo "<td><h2>${TOTAL_ADDED}</h2></td>"
  echo "<td><h2>${ACTIVE_DAYS}</h2></td>"
  echo '</tr>'
  echo '</table>'
  echo ""
  echo "<sub>마지막 갱신: ${TODAY}</sub>"
  echo ""
  echo "---"
  echo ""
  echo "## 일자별 처리 추이"
  echo ""
  echo '```mermaid'
  echo 'xychart-beta'
  echo "    title \"일자별 신규 처리 vs 카테고리 추가\""

  # x-axis 라벨 (최대 14일치만, 너무 많으면 가독성 ↓)
  XAXIS="$(tail -14 "$DAILY_STATS" | cut -f1 | awk '{printf "\"%s\",", substr($0, 6)}' | sed 's/,$//')"
  TOTAL_LINE="$(tail -14 "$DAILY_STATS" | cut -f2 | tr '\n' ',' | sed 's/,$//')"
  ADDED_LINE="$(tail -14 "$DAILY_STATS" | cut -f3 | tr '\n' ',' | sed 's/,$//')"

  echo "    x-axis [${XAXIS}]"
  echo "    y-axis \"건수\""
  echo "    bar [${TOTAL_LINE}]"
  echo "    line [${ADDED_LINE}]"
  echo '```'
  echo ""
  echo "> bar: 일일 신규 처리(검색·분류 시도), line: 카테고리에 실제 추가된 건수"
  echo ""
  echo "---"
  echo ""
  echo "## 최근 14일 상세"
  echo ""
  echo "| 날짜 | 처리(시도) | 카테고리 추가 | 채택률 |"
  echo "|------|---:|---:|---:|"

  tail -14 "$DAILY_STATS" | while IFS=$'\t' read -r day total added; do
    if [[ "$total" -gt 0 ]]; then
      rate="$(awk -v a="$added" -v t="$total" 'BEGIN { printf "%.0f%%", (a/t)*100 }')"
    else
      rate="—"
    fi
    echo "| ${day} | ${total} | ${added} | ${rate} |"
  done

  echo ""
  echo "---"
  echo ""
  echo "## 누적 라인업"
  echo ""
  echo '```mermaid'
  echo 'xychart-beta'
  echo "    title \"누적 처리 레포 vs 누적 카테고리 추가\""

  # cumulative 계산
  CUM_TOTAL=0
  CUM_ADDED=0
  CUM_X=""
  CUM_T=""
  CUM_A=""
  while IFS=$'\t' read -r day total added; do
    CUM_TOTAL=$((CUM_TOTAL + total))
    CUM_ADDED=$((CUM_ADDED + added))
    CUM_X="${CUM_X}\"${day:5}\","
    CUM_T="${CUM_T}${CUM_TOTAL},"
    CUM_A="${CUM_A}${CUM_ADDED},"
  done < <(tail -14 "$DAILY_STATS")
  # trailing comma 제거
  CUM_X="${CUM_X%,}"
  CUM_T="${CUM_T%,}"
  CUM_A="${CUM_A%,}"

  echo "    x-axis [${CUM_X}]"
  echo "    y-axis \"누적\""
  echo "    line [${CUM_T}]"
  echo "    line [${CUM_A}]"
  echo '```'
  echo ""
  echo "---"
  echo ""
  echo "## 채택률 (운영 전체)"
  echo ""
  RATE="$(awk -v a="$TOTAL_ADDED" -v t="$TOTAL_REPOS" 'BEGIN { if (t>0) printf "%.1f%%", (a/t)*100; else print "—" }')"
  echo "검색·분류 시도한 ${TOTAL_REPOS}개 중 **${TOTAL_ADDED}개**가 한국어 호환 + 카테고리 매칭으로 채택됐다. **채택률: ${RATE}**"
  echo ""
  echo "<sub>나머지는 비한국어 / 카테고리 불일치 / 분류 실패 등으로 known-repos에 skip 기록만 남는다.</sub>"
} > "$TRENDS"

rm -f "$DAILY_TMP" "$DAILY_STATS"
echo "[generate-trends] 완료. total=${TOTAL_REPOS}, added=${TOTAL_ADDED}, days=${ACTIVE_DAYS}"
