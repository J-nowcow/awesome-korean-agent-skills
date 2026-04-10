# Auto-Maintenance System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** awesome-korean-agent-skills 레포를 AI 에이전트가 자동으로 유지보수하는 GitHub Actions 기반 시스템 구축

**Architecture:** 4개의 독립 cron 워크플로우(skill-scout, link-checker, weekly-picks, sync-counts)가 각각 PR을 생성하고 조건부 자동 머지. LLM이 필요한 작업(스킬 분류, 주간 추천)은 Node.js 스크립트에서 Anthropic Messages API를 native fetch로 호출. 데이터 파일(known-repos.json, weekly-picks-history.json)로 상태 관리.

**Tech Stack:** GitHub Actions, Bash, Node.js 20 (native fetch), Anthropic Messages API, gh CLI

**Spec:** `docs/specs/2026-04-10-auto-maintenance-design.md`

---

## File Structure

```
.github/
├── workflows/
│   ├── ci.yml                    # PR 검증 (markdown lint, 테이블 포맷, 중복 체크)
│   ├── sync-counts.yml           # 매일: README 카운트 동기화 + CHANGELOG
│   ├── link-checker.yml          # 매일: 죽은 링크 제거
│   ├── weekly-picks.yml          # 주 1회: 이 주의 스킬 로테이션
│   └── skill-scout.yml           # 주 1회: 신규 스킬 발견
├── scripts/
│   ├── sync-counts.sh            # 카테고리별 항목 수 집계 + README 갱신
│   ├── check-links.sh            # URL 유효성 검사 + 죽은 항목 제거
│   ├── search-candidates.sh      # GitHub Search API로 후보 수집
│   ├── classify-skill.mjs        # Anthropic API로 한국어 판별 + 카테고리 분류
│   ├── pick-weekly.mjs           # Anthropic API로 주간 추천 선정
│   └── init-known-repos.sh       # 기존 카테고리에서 known-repos.json 초기 생성 (1회성)
├── CODEOWNERS                    # (선택) 자동 PR 리뷰어 지정
└── pull_request_template.md      # 기존 (변경 없음)

data/
├── known-repos.json              # 처리된 레포 인덱스
└── weekly-picks-history.json     # 과거 추천 이력

docs/
├── how-it-works.md               # 자동화 구조 설명 (한국어)
└── how-it-works.en.md            # 자동화 구조 설명 (영어)

README.md                         # 브랜딩 추가
README.en.md                      # 브랜딩 추가 (영어)
CHANGELOG.md                      # 포맷 갱신
```

---

### Task 1: 데이터 파일 초기화

**Files:**
- Create: `.github/scripts/init-known-repos.sh`
- Create: `data/known-repos.json`
- Create: `data/weekly-picks-history.json`

- [ ] **Step 1: init-known-repos.sh 스크립트 작성**

기존 26개 카테고리 파일에서 모든 GitHub URL을 추출하여 known-repos.json을 생성하는 스크립트.

```bash
#!/usr/bin/env bash
# .github/scripts/init-known-repos.sh
# 기존 카테고리 파일에서 GitHub 레포 URL을 추출하여 data/known-repos.json 생성

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
CATEGORIES_DIR="$REPO_ROOT/categories"
OUTPUT="$REPO_ROOT/data/known-repos.json"

mkdir -p "$REPO_ROOT/data"

# 모든 카테고리 파일에서 GitHub URL 추출 (중복 제거)
urls=$(grep -hoE 'https://github\.com/[^/]+/[^/)]+' "$CATEGORIES_DIR"/*.md \
  | sed 's|/blob/.*||; s|/tree/.*||' \
  | sort -u)

# JSON 생성
echo '{"repos": [' > "$OUTPUT"

first=true
while IFS= read -r url; do
  [ -z "$url" ] && continue
  if [ "$first" = true ]; then
    first=false
  else
    echo ',' >> "$OUTPUT"
  fi
  cat >> "$OUTPUT" <<ENTRY
  {
    "url": "$url",
    "last_scanned": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "skills": []
  }
ENTRY
done <<< "$urls"

echo '], "last_updated": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}' >> "$OUTPUT"

# JSON 정렬 (jq 있으면 사용)
if command -v jq &> /dev/null; then
  jq '.' "$OUTPUT" > "$OUTPUT.tmp" && mv "$OUTPUT.tmp" "$OUTPUT"
fi

echo "Generated $OUTPUT with $(echo "$urls" | wc -l | tr -d ' ') repos"
```

- [ ] **Step 2: 스크립트 실행하여 known-repos.json 생성**

```bash
cd /path/to/awesome-korean-agent-skills
chmod +x .github/scripts/init-known-repos.sh
bash .github/scripts/init-known-repos.sh
```

Expected: `data/known-repos.json` 생성됨, 레포 40~60개 정도 포함

- [ ] **Step 3: 생성된 JSON 검증**

```bash
cat data/known-repos.json | python3 -m json.tool > /dev/null && echo "Valid JSON"
jq '.repos | length' data/known-repos.json
```

Expected: "Valid JSON", 레포 수 출력

- [ ] **Step 4: weekly-picks-history.json 생성**

현재 README에 있는 초기 picks를 기록.

```json
{
  "picks": [
    {
      "date": "2026-04-01",
      "items": [
        {
          "name": "humanizer",
          "repo": "daleseo/korean-skills",
          "category": "korean-writing",
          "type": "🔧",
          "tools": "CC/CR/WS"
        },
        {
          "name": "SRT/KTX 예매",
          "repo": "NomaDamas/k-skill",
          "category": "korean-services",
          "type": "🔧",
          "tools": "CC/CX/OC"
        },
        {
          "name": "code-reviewer",
          "repo": "Yeachan-Heo/oh-my-claudecode",
          "category": "code-review",
          "type": "🤖",
          "tools": "CC"
        }
      ]
    }
  ]
}
```

파일 경로: `data/weekly-picks-history.json`

- [ ] **Step 5: 커밋**

```bash
git add data/known-repos.json data/weekly-picks-history.json .github/scripts/init-known-repos.sh
git commit -m "feat: initialize data files for auto-maintenance system"
```

---

### Task 2: CI 워크플로우

**Files:**
- Create: `.github/workflows/ci.yml`

- [ ] **Step 1: ci.yml 작성**

PR에 대해 마크다운 린트, 테이블 포맷 검증, URL 중복 검사를 수행.

```yaml
# .github/workflows/ci.yml
name: CI

on:
  pull_request:
    paths:
      - 'categories/**'
      - 'README.md'
      - 'README.en.md'
      - 'data/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check table format in category files
        run: |
          errors=0
          for f in categories/*.md; do
            # 각 테이블 행이 5개 컬럼(|로 구분)인지 확인
            # 헤더/구분선 제외하고 데이터 행만 검사
            while IFS= read -r line; do
              # 테이블 행인지 확인 (|로 시작)
              if [[ "$line" =~ ^\| ]] && [[ ! "$line" =~ ^\|[-:\ |]+\|$ ]] && [[ ! "$line" =~ ^\|.*이름.*\| ]]; then
                col_count=$(echo "$line" | awk -F'|' '{print NF-1}')
                if [ "$col_count" -lt 5 ]; then
                  echo "❌ $f: 컬럼 부족 ($col_count < 5): $line"
                  errors=$((errors + 1))
                fi
              fi
            done < "$f"
          done
          if [ "$errors" -gt 0 ]; then
            echo "총 $errors 건의 테이블 포맷 오류"
            exit 1
          fi
          echo "✅ 모든 테이블 포맷 정상"

      - name: Check for duplicate URLs within same category
        run: |
          errors=0
          for f in categories/*.md; do
            dupes=$(grep -oE 'https://github\.com/[^)]+' "$f" | sort | uniq -d)
            if [ -n "$dupes" ]; then
              echo "❌ $f: 중복 URL 발견:"
              echo "$dupes"
              errors=$((errors + 1))
            fi
          done
          if [ "$errors" -gt 0 ]; then
            exit 1
          fi
          echo "✅ 중복 URL 없음"

      - name: Validate new URLs (changed files only)
        run: |
          # PR에서 변경된 카테고리 파일의 새로 추가된 URL만 검사
          changed_files=$(git diff --name-only ${{ github.event.pull_request.base.sha }} HEAD -- 'categories/*.md' || true)
          if [ -z "$changed_files" ]; then
            echo "카테고리 파일 변경 없음, 스킵"
            exit 0
          fi

          errors=0
          for f in $changed_files; do
            [ -f "$f" ] || continue
            new_urls=$(git diff ${{ github.event.pull_request.base.sha }} HEAD -- "$f" \
              | grep '^+' | grep -oE 'https://github\.com/[^)]+' || true)
            for url in $new_urls; do
              status=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 "$url" || echo "000")
              if [ "$status" -ge 400 ] || [ "$status" = "000" ]; then
                echo "❌ $f: 접근 불가 ($status): $url"
                errors=$((errors + 1))
              fi
            done
          done
          if [ "$errors" -gt 0 ]; then
            exit 1
          fi
          echo "✅ 모든 신규 URL 접근 가능"

      - name: Validate JSON data files
        run: |
          for f in data/*.json; do
            python3 -m json.tool "$f" > /dev/null || { echo "❌ Invalid JSON: $f"; exit 1; }
          done
          echo "✅ 모든 JSON 파일 유효"
```

- [ ] **Step 2: YAML 문법 확인**

```bash
# actionlint 설치되어 있다면
actionlint .github/workflows/ci.yml
# 없으면 yamllint으로 대체
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))" && echo "Valid YAML"
```

Expected: 오류 없음

- [ ] **Step 3: 커밋**

```bash
git add .github/workflows/ci.yml
git commit -m "feat: add CI workflow for PR validation"
```

---

### Task 3: sync-counts 워크플로우

**Files:**
- Create: `.github/scripts/sync-counts.sh`
- Create: `.github/workflows/sync-counts.yml`

- [ ] **Step 1: sync-counts.sh 스크립트 작성**

```bash
#!/usr/bin/env bash
# .github/scripts/sync-counts.sh
# 카테고리별 실제 항목 수를 세어 README 테이블 갱신

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
CATEGORIES_DIR="$REPO_ROOT/categories"
TODAY=$(date +%Y-%m-%d)

# 카테고리 파일명 → README에서 쓰는 항목 수 매핑
# 각 카테고리 md에서 테이블 데이터 행 수를 센다
count_entries() {
  local file="$1"
  # 테이블 행: |로 시작하되 헤더(이름/레포/Stars 등)와 구분선(---)은 제외
  grep -cE '^\|[^-]' "$file" | head -1
  # 헤더 행 수를 빼야 함 (섹션당 1개 헤더)
  local total_rows=$(grep -cE '^\|[^-]' "$file" || echo 0)
  local header_rows=$(grep -cE '^\| (이름|레포) ' "$file" || echo 0)
  echo $(( total_rows - header_rows ))
}

update_readme() {
  local readme="$1"
  [ -f "$readme" ] || return

  # 각 카테고리 파일별로 항목 수 계산 후 README 갱신
  for cat_file in "$CATEGORIES_DIR"/*.md; do
    local basename=$(basename "$cat_file" .md)
    local count=$(count_entries "$cat_file")

    # README에서 해당 카테고리 행의 항목 수를 갱신
    # 패턴: | [카테고리명](categories/xxx.md) | 설명 | N+ |
    # 또는: | [Category](categories/xxx.md) | desc | N+ |
    sed -i.bak -E "s|(\(categories/${basename}\.md\)[^|]*\|[^|]*\| )[0-9]+\+?( \|)|\1${count}+\2|" "$readme"
  done

  # "최근 업데이트" 날짜 갱신 (한국어 README)
  sed -i.bak -E "s|최근 업데이트: [0-9]{4}-[0-9]{2}-[0-9]{2}|최근 업데이트: ${TODAY}|" "$readme"
  # "Last updated" 날짜 갱신 (영어 README)
  sed -i.bak -E "s|Last updated: [0-9]{4}-[0-9]{2}-[0-9]{2}|Last updated: ${TODAY}|" "$readme"

  rm -f "${readme}.bak"
}

update_readme "$REPO_ROOT/README.md"
update_readme "$REPO_ROOT/README.en.md"

echo "✅ README 카운트 동기화 완료 ($TODAY)"
```

- [ ] **Step 2: 스크립트 로컬 테스트**

```bash
chmod +x .github/scripts/sync-counts.sh
bash .github/scripts/sync-counts.sh
git diff README.md  # 카운트 변경 확인
```

Expected: 항목 수가 실제 카테고리 파일의 row 수와 일치하도록 갱신됨

- [ ] **Step 3: sync-counts.yml 워크플로우 작성**

```yaml
# .github/workflows/sync-counts.yml
name: Sync Counts

on:
  schedule:
    - cron: '0 6 * * *'  # 매일 06:00 UTC (한국 15:00)
  workflow_dispatch:       # 수동 실행 가능

permissions:
  contents: write
  pull-requests: write

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run sync-counts
        run: bash .github/scripts/sync-counts.sh

      - name: Append to CHANGELOG if changes exist
        run: |
          if git diff --quiet; then
            echo "변경 없음, 스킵"
            exit 0
          fi

          TODAY=$(date +%Y-%m-%d)
          # CHANGELOG 상단에 오늘 날짜 섹션이 없으면 추가
          if ! grep -q "## $TODAY" CHANGELOG.md; then
            sed -i "1a\\
          \\
          ## $TODAY\\
          \\
          ### 🤖 자동 업데이트\\
          - 카테고리 항목 수 동기화 (sync-counts)" CHANGELOG.md
          else
            # 이미 오늘 섹션이 있으면 항목 추가
            sed -i "/## $TODAY/,/^## [0-9]/{/^## [0-9]/!{/자동 업데이트/a\\
          - 카테고리 항목 수 동기화 (sync-counts)
          }}" CHANGELOG.md
          fi

      - name: Create PR
        if: ${{ !cancelled() }}
        run: |
          if git diff --quiet; then
            echo "변경 없음, PR 생성 스킵"
            exit 0
          fi

          BRANCH="auto/sync-counts-$(date +%Y%m%d)"
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git checkout -b "$BRANCH"
          git add README.md README.en.md CHANGELOG.md
          git commit -m "🤖 chore: sync category counts ($(date +%Y-%m-%d))"
          git push -u origin "$BRANCH"

          gh pr create \
            --title "🤖 [auto] 카테고리 카운트 동기화 ($(date +%Y-%m-%d))" \
            --body "$(cat <<'EOF'
          > 🤖 이 PR은 `sync-counts` 워크플로우가 자동 생성했습니다.

          ## 변경 내용
          - 각 카테고리 파일의 실제 항목 수로 README 테이블 갱신
          - "최근 업데이트" 날짜 갱신
          - CHANGELOG 업데이트
          EOF
          )" \
            --label "auto-merge,sync-counts"

          gh pr merge "$BRANCH" --auto --squash
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- [ ] **Step 4: 커밋**

```bash
git add .github/scripts/sync-counts.sh .github/workflows/sync-counts.yml
git commit -m "feat: add sync-counts workflow for daily count synchronization"
```

---

### Task 4: link-checker 워크플로우

**Files:**
- Create: `.github/scripts/check-links.sh`
- Create: `.github/workflows/link-checker.yml`

- [ ] **Step 1: check-links.sh 스크립트 작성**

```bash
#!/usr/bin/env bash
# .github/scripts/check-links.sh
# 모든 카테고리 파일의 GitHub URL을 검사하고 죽은 링크가 있는 행을 제거

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
CATEGORIES_DIR="$REPO_ROOT/categories"
DEAD_LOG="$REPO_ROOT/.github/scripts/dead-links.log"

> "$DEAD_LOG"
removed=0

for cat_file in "$CATEGORIES_DIR"/*.md; do
  # 테이블 행에서 GitHub URL 추출 (행 번호 포함)
  while IFS= read -r line_info; do
    lineno=$(echo "$line_info" | cut -d: -f1)
    line=$(echo "$line_info" | cut -d: -f2-)

    # GitHub URL 추출
    url=$(echo "$line" | grep -oE 'https://github\.com/[^)]+' | head -1)
    [ -z "$url" ] && continue

    # URL 체크 (HEAD 요청, 10초 타임아웃, 2회 재시도)
    status="000"
    for attempt in 1 2; do
      status=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 "$url" 2>/dev/null || echo "000")
      [ "$status" -lt 400 ] && [ "$status" != "000" ] && break
      sleep 1
    done

    if [ "$status" -ge 400 ] || [ "$status" = "000" ]; then
      echo "DEAD ($status): $url in $(basename "$cat_file"):$lineno" | tee -a "$DEAD_LOG"

      # 해당 행 제거 (sed로 특정 행 삭제)
      sed -i.bak "${lineno}d" "$cat_file"
      rm -f "${cat_file}.bak"
      removed=$((removed + 1))
    fi
  done < <(grep -nE '^\|' "$cat_file" | grep -vE '^\|[-: |]+\|$' | grep -vE '^\|.*(이름|레포|Stars)' || true)

  # rate limit 방지
  sleep 0.5
done

echo "총 $removed 개 죽은 링크 제거"
echo "$removed" > /tmp/dead-link-count

# known-repos.json에서도 제거
if [ "$removed" -gt 0 ] && [ -f "$REPO_ROOT/data/known-repos.json" ]; then
  while IFS= read -r dead_entry; do
    dead_url=$(echo "$dead_entry" | grep -oE 'https://github\.com/[^/ ]+/[^/ ]+' | head -1)
    [ -z "$dead_url" ] && continue
    # jq로 해당 URL 제거
    if command -v jq &> /dev/null; then
      jq --arg url "$dead_url" '.repos = [.repos[] | select(.url != $url)]' \
        "$REPO_ROOT/data/known-repos.json" > /tmp/kr.json \
        && mv /tmp/kr.json "$REPO_ROOT/data/known-repos.json"
    fi
  done < "$DEAD_LOG"
fi
```

- [ ] **Step 2: link-checker.yml 워크플로우 작성**

```yaml
# .github/workflows/link-checker.yml
name: Link Checker

on:
  schedule:
    - cron: '0 5 * * *'  # 매일 05:00 UTC
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check links
        run: |
          chmod +x .github/scripts/check-links.sh
          bash .github/scripts/check-links.sh

      - name: Create PR if dead links found
        run: |
          if git diff --quiet; then
            echo "죽은 링크 없음"
            exit 0
          fi

          BRANCH="auto/link-check-$(date +%Y%m%d)"
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git checkout -b "$BRANCH"
          git add categories/ data/
          git commit -m "🤖 fix: remove dead links ($(date +%Y-%m-%d))"
          git push -u origin "$BRANCH"

          DEAD_COUNT=$(cat /tmp/dead-link-count 2>/dev/null || echo 0)
          DEAD_DETAILS=$(cat .github/scripts/dead-links.log 2>/dev/null || echo "없음")

          gh pr create \
            --title "🤖 [auto] 죽은 링크 ${DEAD_COUNT}개 제거 ($(date +%Y-%m-%d))" \
            --body "$(cat <<EOF
          > 🤖 이 PR은 \`link-checker\` 워크플로우가 자동 생성했습니다.

          ## 제거된 링크
          \`\`\`
          ${DEAD_DETAILS}
          \`\`\`

          ## 검증
          - 각 URL에 HEAD 요청 (10초 타임아웃, 2회 재시도)
          - 404 또는 타임아웃인 항목만 제거
          EOF
          )" \
            --label "auto-merge,link-check"

          gh pr merge "$BRANCH" --auto --squash
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- [ ] **Step 3: 로컬에서 스크립트 테스트 (dry-run)**

```bash
chmod +x .github/scripts/check-links.sh
# dry-run: 실제로 행을 삭제하지 않고 결과만 확인
# check-links.sh를 수정 없이 실행하되 git stash로 되돌리기
bash .github/scripts/check-links.sh
git diff --stat  # 변경 확인
git checkout -- categories/  # 되돌리기 (테스트 후)
```

- [ ] **Step 4: 커밋**

```bash
git add .github/scripts/check-links.sh .github/workflows/link-checker.yml
git commit -m "feat: add link-checker workflow for daily dead link removal"
```

---

### Task 5: weekly-picks 워크플로우

**Files:**
- Create: `.github/scripts/pick-weekly.mjs`
- Create: `.github/workflows/weekly-picks.yml`

- [ ] **Step 1: pick-weekly.mjs 스크립트 작성**

Anthropic Messages API로 주간 추천 3개를 선정하는 Node.js 스크립트.

```javascript
#!/usr/bin/env node
// .github/scripts/pick-weekly.mjs
// 모든 카테고리에서 후보를 모아 LLM으로 주간 추천 3개 선정

import { readFileSync, writeFileSync, readdirSync } from 'fs';
import { join, dirname } from 'path';
import { execSync } from 'child_process';

const REPO_ROOT = execSync('git rev-parse --show-toplevel', { encoding: 'utf-8' }).trim();
const CATEGORIES_DIR = join(REPO_ROOT, 'categories');
const HISTORY_FILE = join(REPO_ROOT, 'data', 'weekly-picks-history.json');
const README_KR = join(REPO_ROOT, 'README.md');
const README_EN = join(REPO_ROOT, 'README.en.md');

// 1. 모든 카테고리에서 스킬 항목 추출
function extractAllSkills() {
  const skills = [];
  for (const file of readdirSync(CATEGORIES_DIR)) {
    if (!file.endsWith('.md')) continue;
    const category = file.replace('.md', '');
    const content = readFileSync(join(CATEGORIES_DIR, file), 'utf-8');

    let currentType = '';
    for (const line of content.split('\n')) {
      if (line.startsWith('## ')) {
        if (line.includes('🤖')) currentType = '🤖';
        else if (line.includes('🔧')) currentType = '🔧';
        else if (line.includes('⚡')) currentType = '⚡';
        else if (line.includes('🪝')) currentType = '🪝';
        else currentType = '';
      }
      // 테이블 데이터 행 파싱
      if (line.startsWith('|') && !line.includes('---') && !line.includes('이름') && !line.includes('레포') && !line.includes('Stars')) {
        const cols = line.split('|').map(c => c.trim()).filter(Boolean);
        if (cols.length >= 4) {
          const repoMatch = line.match(/\[([^\]]+)\]\((https:\/\/github\.com\/[^)]+)\)/);
          if (repoMatch) {
            skills.push({
              name: cols[0],
              tools: cols[1],
              description: cols[2],
              language: cols[3] || '',
              repo: repoMatch[1],
              repoUrl: repoMatch[2],
              type: currentType || '🔧',
              category,
            });
          }
        }
      }
    }
  }
  return skills;
}

// 2. 이미 추천된 스킬 제외
function filterOutPreviousPicks(skills) {
  const history = JSON.parse(readFileSync(HISTORY_FILE, 'utf-8'));
  const previousRepos = new Set();
  for (const pick of history.picks) {
    for (const item of pick.items) {
      previousRepos.add(item.repo);
    }
  }
  return skills.filter(s => !previousRepos.has(s.repo));
}

// 3. LLM으로 3개 선정
async function selectPicks(candidates) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) throw new Error('ANTHROPIC_API_KEY 환경변수 필요');

  const candidateList = candidates.map((s, i) =>
    `${i + 1}. [${s.type}] ${s.name} (${s.tools}) — ${s.description} [카테고리: ${s.category}] [레포: ${s.repo}]`
  ).join('\n');

  const prompt = `아래는 한국어 AI 에이전트 스킬 목록입니다. "이 주의 스킬"로 추천할 3개를 골라주세요.

선정 기준:
- 카테고리가 서로 다른 3개 (다양성)
- 실용적이고 활용도가 높은 것
- 한국어 지원이 좋은 것 우선

후보 목록:
${candidateList}

응답 형식 (JSON만, 설명 없이):
[
  {"index": 번호, "reason_ko": "한국어 추천 이유 한 줄", "reason_en": "English one-line reason"},
  {"index": 번호, "reason_ko": "...", "reason_en": "..."},
  {"index": 번호, "reason_ko": "...", "reason_en": "..."}
]`;

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 1024,
      messages: [{ role: 'user', content: prompt }],
    }),
  });

  if (!response.ok) {
    throw new Error(`Anthropic API error: ${response.status} ${await response.text()}`);
  }

  const data = await response.json();
  const text = data.content[0].text;
  // JSON 추출 (markdown 코드블록 내부일 수 있음)
  const jsonMatch = text.match(/\[[\s\S]*\]/);
  if (!jsonMatch) throw new Error('LLM 응답에서 JSON 파싱 실패: ' + text);
  return JSON.parse(jsonMatch[0]);
}

// 4. README 갱신
function updateReadme(readmePath, picks, candidates, lang) {
  let content = readFileSync(readmePath, 'utf-8');
  const today = new Date().toISOString().split('T')[0];

  // "이 주의 스킬" 테이블 교체
  const tableRows = picks.map(p => {
    const skill = candidates[p.index - 1];
    const reason = lang === 'ko' ? p.reason_ko : p.reason_en;
    return `| ${skill.type} ${skill.name} | ${skill.tools} | ${reason} | [${skill.repo}](${skill.repoUrl}) |`;
  }).join('\n');

  // 기존 테이블 교체 (이 주의 스킬 섹션)
  const tablePattern = /(\| 스킬 \| 도구 \| 왜 추천\? \| 링크 \|\n\|[-:|\ ]+\|\n)([\s\S]*?)(\n---|\n\n##)/;
  const tablePatternEn = /(\| Skill \| Tools \| Why\? \| Link \|\n\|[-:|\ ]+\|\n)([\s\S]*?)(\n---|\n\n##)/;

  const pattern = lang === 'ko' ? tablePattern : tablePatternEn;
  content = content.replace(pattern, `$1${tableRows}\n$3`);

  // 날짜 갱신
  if (lang === 'ko') {
    content = content.replace(/최근 업데이트: [0-9-]+/, `최근 업데이트: ${today}`);
  } else {
    content = content.replace(/Last updated: [0-9-]+/, `Last updated: ${today}`);
  }

  writeFileSync(readmePath, content);
}

// 5. 히스토리 갱신
function updateHistory(picks, candidates) {
  const history = JSON.parse(readFileSync(HISTORY_FILE, 'utf-8'));
  const today = new Date().toISOString().split('T')[0];
  history.picks.push({
    date: today,
    items: picks.map(p => {
      const s = candidates[p.index - 1];
      return { name: s.name, repo: s.repo, category: s.category, type: s.type, tools: s.tools };
    }),
  });
  writeFileSync(HISTORY_FILE, JSON.stringify(history, null, 2) + '\n');
}

// Main
async function main() {
  const allSkills = extractAllSkills();
  console.log(`총 ${allSkills.length}개 스킬 발견`);

  const candidates = filterOutPreviousPicks(allSkills);
  console.log(`이전 추천 제외 후 ${candidates.length}개 후보`);

  if (candidates.length < 3) {
    console.log('후보 부족 (3개 미만), 히스토리 리셋');
    // 히스토리가 너무 쌓이면 리셋
    writeFileSync(HISTORY_FILE, JSON.stringify({ picks: [] }, null, 2) + '\n');
    // 전체에서 다시 선정
    const picks = await selectPicks(allSkills);
    updateReadme(README_KR, picks, allSkills, 'ko');
    updateReadme(README_EN, picks, allSkills, 'en');
    updateHistory(picks, allSkills);
  } else {
    const picks = await selectPicks(candidates);
    updateReadme(README_KR, picks, candidates, 'ko');
    updateReadme(README_EN, picks, candidates, 'en');
    updateHistory(picks, candidates);
  }

  console.log('✅ 이 주의 스킬 갱신 완료');
}

main().catch(e => { console.error(e); process.exit(1); });
```

- [ ] **Step 2: weekly-picks.yml 워크플로우 작성**

```yaml
# .github/workflows/weekly-picks.yml
name: Weekly Picks

on:
  schedule:
    - cron: '0 4 * * 1'  # 매주 월요일 04:00 UTC
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  picks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Select weekly picks
        run: node .github/scripts/pick-weekly.mjs
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}

      - name: Create PR
        run: |
          if git diff --quiet; then
            echo "변경 없음"
            exit 0
          fi

          BRANCH="auto/weekly-picks-$(date +%Y%m%d)"
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git checkout -b "$BRANCH"
          git add README.md README.en.md data/weekly-picks-history.json
          git commit -m "🤖 feat: update weekly picks ($(date +%Y-%m-%d))"
          git push -u origin "$BRANCH"

          gh pr create \
            --title "🤖 [auto] 이 주의 스킬 갱신 ($(date +%Y-%m-%d))" \
            --body "$(cat <<'EOF'
          > 🤖 이 PR은 `weekly-picks` 워크플로우가 자동 생성했습니다.

          ## 선정 기준
          - 카테고리 다양성 (서로 다른 카테고리에서 선정)
          - 실용성과 한국어 지원 품질
          - 이전 추천과 중복 방지
          EOF
          )" \
            --label "auto-merge,weekly-picks"

          gh pr merge "$BRANCH" --auto --squash
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- [ ] **Step 3: 커밋**

```bash
git add .github/scripts/pick-weekly.mjs .github/workflows/weekly-picks.yml
git commit -m "feat: add weekly-picks workflow for automatic skill rotation"
```

---

### Task 6: skill-scout 워크플로우

**Files:**
- Create: `.github/scripts/search-candidates.sh`
- Create: `.github/scripts/classify-skill.mjs`
- Create: `.github/workflows/skill-scout.yml`

- [ ] **Step 1: search-candidates.sh 스크립트 작성**

GitHub Search API로 후보 레포를 수집하고 JSON으로 출력.

```bash
#!/usr/bin/env bash
# .github/scripts/search-candidates.sh
# GitHub Search API로 한국어 에이전트 스킬 후보 레포 수집

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
KNOWN="$REPO_ROOT/data/known-repos.json"
OUTPUT="/tmp/candidates.json"

# known repos URL 목록 추출
known_urls=$(jq -r '.repos[].url' "$KNOWN" 2>/dev/null || echo "")

echo '[]' > "$OUTPUT"

# 검색 쿼리 목록
queries=(
  "topic:claude-skills"
  "topic:agent-skills"
  "topic:claude-code language:Markdown"
  "topic:gemini-cli language:Markdown"
  "filename:SKILL.md"
  "claude code skill in:readme language:Markdown"
  "에이전트 스킬 in:readme"
  "claude-code 한국어 in:readme"
)

for query in "${queries[@]}"; do
  echo "검색: $query"

  # gh search repos는 최대 100개 결과
  results=$(gh search repos "$query" \
    --limit 50 \
    --json url,name,description,stargazersCount,updatedAt,isArchived \
    2>/dev/null || echo '[]')

  # 필터: 아카이브 아님, 별 1+, 6개월 내 업데이트
  six_months_ago=$(date -u -v-6m +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d '6 months ago' +%Y-%m-%dT%H:%M:%SZ)

  filtered=$(echo "$results" | jq --arg cutoff "$six_months_ago" --arg known "$known_urls" '
    [.[] | select(
      .isArchived == false and
      .stargazersCount >= 1 and
      .updatedAt >= $cutoff
    )]
  ')

  # 기존 known repos 제외
  for url in $known_urls; do
    filtered=$(echo "$filtered" | jq --arg u "$url" '[.[] | select(.url != $u)]')
  done

  # 기존 결과에 병합 (중복 제거)
  merged=$(jq -s '.[0] + .[1] | unique_by(.url)' "$OUTPUT" <(echo "$filtered"))
  echo "$merged" > "$OUTPUT"

  # rate limit 방지
  sleep 2
done

total=$(jq 'length' "$OUTPUT")
echo "총 $total 개 신규 후보 발견"
echo "$total" > /tmp/candidate-count
```

- [ ] **Step 2: classify-skill.mjs 스크립트 작성**

각 후보 레포를 분석하여 한국어 여부, 카테고리, 스킬 정보를 분류.

```javascript
#!/usr/bin/env node
// .github/scripts/classify-skill.mjs
// 후보 레포를 LLM으로 분류하고 카테고리 파일에 추가

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'fs';
import { join } from 'path';
import { execSync } from 'child_process';

const REPO_ROOT = execSync('git rev-parse --show-toplevel', { encoding: 'utf-8' }).trim();
const CATEGORIES_DIR = join(REPO_ROOT, 'categories');
const KNOWN_FILE = join(REPO_ROOT, 'data', 'known-repos.json');
const CANDIDATES_FILE = '/tmp/candidates.json';

// 카테고리 목록 (파일명에서 추출)
const CATEGORIES = readdirSync(CATEGORIES_DIR)
  .filter(f => f.endsWith('.md'))
  .map(f => f.replace('.md', ''));

// 레포의 README 가져오기
async function fetchReadme(repoUrl) {
  // https://github.com/owner/repo → owner/repo
  const ownerRepo = repoUrl.replace('https://github.com/', '');
  try {
    const result = execSync(
      `gh api repos/${ownerRepo}/readme --jq '.content' 2>/dev/null | base64 -d`,
      { encoding: 'utf-8', timeout: 15000 }
    );
    return result.substring(0, 3000); // 토큰 절약
  } catch {
    return '';
  }
}

// 레포의 SKILL.md 파일 목록 가져오기
async function fetchSkillFiles(repoUrl) {
  const ownerRepo = repoUrl.replace('https://github.com/', '');
  try {
    const result = execSync(
      `gh api repos/${ownerRepo}/git/trees/HEAD?recursive=1 --jq '[.tree[] | select(.path | test("SKILL\\\\.md$"; "i")) | .path]'`,
      { encoding: 'utf-8', timeout: 15000 }
    );
    return JSON.parse(result);
  } catch {
    return [];
  }
}

// LLM으로 분류
async function classifyRepo(repo, readme, skillFiles) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) throw new Error('ANTHROPIC_API_KEY 필요');

  const prompt = `GitHub 레포를 한국어 AI 에이전트 스킬 큐레이션에 등록할지 분류해주세요.

레포 정보:
- URL: ${repo.url}
- 이름: ${repo.name}
- 설명: ${repo.description || '없음'}
- 별: ${repo.stargazersCount}
- SKILL.md 파일: ${skillFiles.length > 0 ? skillFiles.join(', ') : '없음'}

README (처음 3000자):
${readme || '(읽기 실패)'}

사용 가능한 카테고리: ${CATEGORIES.join(', ')}

판단 기준:
1. 한국어 지원 여부: "한국어" (본문 한국어), "영+한" (영어+한국어 README), "다국어(KO)" (다국어 지원), "해당없음"
2. 스킬/에이전트 유형: 🔧 Skill / 🤖 Agent / ⚡ Command / 🪝 Hook
3. 도구 호환성: CC (Claude Code) / GC (Gemini CLI) / CX (Codex) / CP (Copilot) / OC (OpenCode) / CR (Cursor) / WS (Windsurf)
4. 적합한 카테고리 (위 목록 중 택1, 해당없으면 "none")

응답 형식 (JSON만, 설명 없이):
{
  "is_korean": true/false,
  "language": "한국어/영+한/다국어(KO)/해당없음",
  "skills": [
    {
      "name": "스킬 이름",
      "type": "🔧",
      "tools": "CC",
      "category": "카테고리명",
      "description_ko": "한국어 설명 한 줄",
      "file_path": "SKILL.md 경로 (있으면)"
    }
  ],
  "reject_reason": "등록 부적합 시 사유 (적합하면 null)"
}

한국어 지원이 없으면 is_korean=false, skills=[]로 응답.
하나의 레포에 여러 스킬이 있을 수 있음.`;

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 2048,
      messages: [{ role: 'user', content: prompt }],
    }),
  });

  if (!response.ok) {
    const errText = await response.text();
    throw new Error(`API error ${response.status}: ${errText}`);
  }

  const data = await response.json();
  const text = data.content[0].text;
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (!jsonMatch) throw new Error('JSON 파싱 실패: ' + text);
  return JSON.parse(jsonMatch[0]);
}

// 카테고리 파일에 항목 추가
function addToCategory(category, skill, repoUrl, repoName) {
  const filePath = join(CATEGORIES_DIR, `${category}.md`);
  if (!existsSync(filePath)) {
    console.log(`  ⚠️ 카테고리 파일 없음: ${category}.md, Issue 생성 필요`);
    return false;
  }

  let content = readFileSync(filePath, 'utf-8');

  // 해당 타입 섹션 찾기
  const typeHeaders = {
    '🤖': '## 🤖 Agents',
    '🔧': '## 🔧 Skills',
    '⚡': '## ⚡ Commands',
    '🪝': '## 🪝 Hooks',
  };
  const sectionHeader = typeHeaders[skill.type] || '## 🔧 Skills';

  // 새 행
  const linkPath = skill.file_path
    ? `${repoUrl}/blob/main/${skill.file_path}`
    : repoUrl;
  const newRow = `| ${skill.name} | ${skill.tools} | ${skill.description_ko} | ${skill.language || '영+한'} | [${repoName}](${linkPath}) |`;

  // 섹션이 있는지 확인
  if (content.includes(sectionHeader)) {
    // 섹션의 테이블 마지막 행 뒤에 추가
    const lines = content.split('\n');
    let insertIdx = -1;
    let inSection = false;
    for (let i = 0; i < lines.length; i++) {
      if (lines[i].includes(sectionHeader)) {
        inSection = true;
        continue;
      }
      if (inSection && lines[i].startsWith('## ')) {
        // 다음 섹션 시작 → 여기 직전에 삽입
        insertIdx = i;
        break;
      }
      if (inSection && lines[i].startsWith('|') && !lines[i].includes('---') && !lines[i].includes('이름')) {
        insertIdx = i + 1; // 마지막 테이블 행 다음
      }
    }
    if (insertIdx === -1) insertIdx = lines.length;
    lines.splice(insertIdx, 0, newRow);
    content = lines.join('\n');
  } else {
    // 섹션이 없으면 파일 끝에 섹션 + 테이블 추가
    content += `\n\n${sectionHeader}\n\n| 이름 | 도구 | 설명 | 언어 | 레포 |\n|------|------|------|------|------|\n${newRow}\n`;
  }

  writeFileSync(filePath, content);
  return true;
}

// known-repos.json 업데이트
function updateKnownRepos(repoUrl, skills) {
  const known = JSON.parse(readFileSync(KNOWN_FILE, 'utf-8'));
  const existing = known.repos.find(r => r.url === repoUrl);
  if (existing) {
    existing.last_scanned = new Date().toISOString();
    existing.skills = skills;
  } else {
    known.repos.push({
      url: repoUrl,
      last_scanned: new Date().toISOString(),
      skills: skills.map(s => ({
        name: s.name,
        category: s.category,
        file_path: s.file_path || '',
        added_date: new Date().toISOString().split('T')[0],
      })),
    });
  }
  known.last_updated = new Date().toISOString();
  writeFileSync(KNOWN_FILE, JSON.stringify(known, null, 2) + '\n');
}

// Issue 생성 (분류 애매한 경우)
function createIssueCommand(repo, reason) {
  return `gh issue create --title "🤖 [scout] 분류 검토 필요: ${repo.name}" --body "레포: ${repo.url}\n사유: ${reason}" --label "needs-review"`;
}

// Main
async function main() {
  if (!existsSync(CANDIDATES_FILE)) {
    console.log('후보 파일 없음, 스킵');
    return;
  }

  const candidates = JSON.parse(readFileSync(CANDIDATES_FILE, 'utf-8'));
  console.log(`${candidates.length}개 후보 분류 시작`);

  let added = 0;
  let rejected = 0;
  let issues = [];
  const addedSkills = [];

  for (const repo of candidates) {
    console.log(`\n분석: ${repo.name} (${repo.url})`);

    const readme = await fetchReadme(repo.url);
    const skillFiles = await fetchSkillFiles(repo.url);

    try {
      const result = await classifyRepo(repo, readme, skillFiles);

      if (!result.is_korean || result.skills.length === 0) {
        console.log(`  ❌ 제외: ${result.reject_reason || '한국어 미지원'}`);
        rejected++;
        // known에는 등록 (재검사 방지)
        updateKnownRepos(repo.url, []);
        continue;
      }

      for (const skill of result.skills) {
        if (skill.category === 'none' || !CATEGORIES.includes(skill.category)) {
          console.log(`  ⚠️ 분류 불가: ${skill.name} → Issue 생성`);
          issues.push(createIssueCommand(repo, `카테고리 분류 불가: ${skill.name}`));
          continue;
        }

        const repoName = repo.url.split('/').slice(-2).join('/');
        const success = addToCategory(skill.category, skill, repo.url, repo.name);
        if (success) {
          console.log(`  ✅ 추가: ${skill.name} → ${skill.category}`);
          added++;
          addedSkills.push({ ...skill, repo: repoName });
        }
      }

      updateKnownRepos(repo.url, result.skills);

    } catch (err) {
      console.error(`  ⚠️ 분류 실패: ${err.message}`);
    }

    // rate limit 방지
    await new Promise(r => setTimeout(r, 1000));
  }

  // Issue 생성 명령어 출력
  for (const cmd of issues) {
    try {
      execSync(cmd, { encoding: 'utf-8' });
    } catch (e) {
      console.error(`Issue 생성 실패: ${e.message}`);
    }
  }

  // 결과 요약 저장
  const summary = { added, rejected, issues: issues.length, skills: addedSkills };
  writeFileSync('/tmp/scout-summary.json', JSON.stringify(summary, null, 2));
  console.log(`\n완료: 추가 ${added}, 제외 ${rejected}, Issue ${issues.length}`);
}

main().catch(e => { console.error(e); process.exit(1); });
```

- [ ] **Step 3: skill-scout.yml 워크플로우 작성**

```yaml
# .github/workflows/skill-scout.yml
name: Skill Scout

on:
  schedule:
    - cron: '0 3 * * 1'  # 매주 월요일 03:00 UTC
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write
  issues: write

jobs:
  scout:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Search candidates
        run: |
          chmod +x .github/scripts/search-candidates.sh
          bash .github/scripts/search-candidates.sh
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Skip if no candidates
        id: check
        run: |
          count=$(cat /tmp/candidate-count 2>/dev/null || echo 0)
          echo "count=$count" >> "$GITHUB_OUTPUT"
          if [ "$count" = "0" ]; then
            echo "신규 후보 없음, 종료"
          fi

      - name: Classify and add skills
        if: steps.check.outputs.count != '0'
        run: node .github/scripts/classify-skill.mjs
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Create PR
        if: steps.check.outputs.count != '0'
        run: |
          if git diff --quiet; then
            echo "분류 결과 추가할 항목 없음"
            exit 0
          fi

          BRANCH="auto/skill-scout-$(date +%Y%m%d)"
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git checkout -b "$BRANCH"
          git add categories/ data/
          git commit -m "🤖 feat: add new skills ($(date +%Y-%m-%d))"
          git push -u origin "$BRANCH"

          SUMMARY=$(cat /tmp/scout-summary.json 2>/dev/null || echo '{"added":0}')
          ADDED=$(echo "$SUMMARY" | jq -r '.added')
          SKILLS=$(echo "$SUMMARY" | jq -r '.skills[] | "- \(.type) **\(.name)** → `\(.category)` (\(.description_ko))"' 2>/dev/null || echo "없음")

          gh pr create \
            --title "🤖 [auto] 신규 스킬 ${ADDED}개 발견 ($(date +%Y-%m-%d))" \
            --body "$(cat <<EOF
          > 🤖 이 PR은 \`skill-scout\` 워크플로우가 자동 생성했습니다.
          > [워크플로우 실행 로그](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})

          ## 발견된 스킬
          ${SKILLS}

          ## 검증
          - GitHub Search API로 후보 수집
          - Anthropic API로 한국어 판별 + 카테고리 분류
          - 기존 등록 레포와 중복 검사 완료

          > ⏰ 24시간 후 자동 머지됩니다. 문제가 있으면 PR을 닫아주세요.
          EOF
          )" \
            --label "auto-merge,skill-scout"

          # skill-scout는 24시간 후 자동 머지 (다른 워크플로우와 달리)
          # GitHub에서 "Require approvals" 없이 auto-merge 설정 필요
          gh pr merge "$BRANCH" --auto --squash
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- [ ] **Step 4: 스크립트 실행 권한 설정 및 커밋**

```bash
chmod +x .github/scripts/search-candidates.sh
git add .github/scripts/search-candidates.sh .github/scripts/classify-skill.mjs .github/workflows/skill-scout.yml
git commit -m "feat: add skill-scout workflow for automatic skill discovery"
```

---

### Task 7: 브랜딩 변경

**Files:**
- Modify: `README.md`
- Modify: `README.en.md`
- Create: `docs/how-it-works.md`
- Create: `docs/how-it-works.en.md`
- Modify: `CHANGELOG.md`

- [ ] **Step 1: docs/how-it-works.md 작성**

```markdown
# 🤖 이 레포는 어떻게 돌아가나?

> awesome-korean-agent-skills는 **100% AI 에이전트가 자동으로 운영**합니다.

## 자동화 구조

```
GitHub Actions (cron)
├── 🔍 skill-scout     매주 월요일 — 신규 스킬 자동 발견 + 분류 + PR
├── 🔗 link-checker    매일 — 죽은 링크 감지 + 자동 제거
├── ⭐ weekly-picks     매주 월요일 — "이 주의 스킬" 자동 로테이션
└── 📊 sync-counts     매일 — 카테고리 항목 수 + 날짜 동기화
```

## 동작 방식

### 1. 스킬 발견 (skill-scout)

매주 GitHub을 검색하여 새로운 한국어 AI 에이전트 스킬을 찾습니다.

**검색 소스:**
- GitHub 토픽: `claude-skills`, `agent-skills`, `claude-code`, `gemini-cli`
- 파일명: `SKILL.md` 포함 레포
- 키워드: `에이전트 스킬`, `claude code 한국어` 등

**분류 과정:**
1. GitHub Search API로 후보 수집
2. 기존 등록 레포(`data/known-repos.json`)와 중복 제거
3. Anthropic Claude API로 각 후보 분석:
   - 한국어 지원 여부 판별
   - 26개 카테고리 중 적합한 곳 분류
   - 스킬 유형(🔧/🤖/⚡/🪝) 및 도구 호환성 판별
4. 해당 카테고리 파일에 자동 추가
5. PR 생성 → 24시간 대기 → 자동 머지

### 2. 링크 검증 (link-checker)

매일 모든 카테고리의 URL을 검사합니다.

- 각 URL에 HTTP HEAD 요청 (10초 타임아웃, 2회 재시도)
- 404 또는 타임아웃 → 해당 항목 자동 제거
- 아카이브된 레포 감지 및 처리

### 3. 주간 추천 (weekly-picks)

매주 "이 주의 스킬" 3개를 자동 선정합니다.

- 선정 기준: 카테고리 다양성, 실용성, 한국어 지원 품질
- 이전 추천과 중복 방지 (`data/weekly-picks-history.json`)
- Claude API로 추천 사유 자동 생성

### 4. 카운트 동기화 (sync-counts)

매일 README의 항목 수와 날짜를 갱신합니다.

- 각 카테고리 파일의 실제 행 수 집계
- README 테이블의 "항목 수" 동기화
- CHANGELOG에 당일 변경사항 기록

## 데이터 파일

| 파일 | 역할 |
|------|------|
| `data/known-repos.json` | 이미 처리한 레포 인덱스 (중복 방지) |
| `data/weekly-picks-history.json` | 과거 추천 이력 (로테이션) |

## 사람의 역할

- **감독**: 자동 생성된 PR 확인 (skill-scout PR은 24시간 대기)
- **개입**: 잘못된 분류 → PR 닫기, 카테고리 수정 후 수동 추가
- **카테고리 관리**: 신규 카테고리 생성은 사람이 결정 (에이전트는 Issue로 제안)

## 직접 만들고 싶다면?

이 자동화 시스템을 다른 awesome list에 적용하고 싶다면:

1. `.github/workflows/` 디렉토리의 워크플로우 파일 참고
2. `.github/scripts/` 디렉토리의 스크립트 복제
3. `ANTHROPIC_API_KEY` Secret 설정
4. 카테고리 구조에 맞게 스크립트 수정

라이선스는 CC0이므로 자유롭게 사용하세요.
```

- [ ] **Step 2: docs/how-it-works.en.md 작성**

```markdown
# 🤖 How Does This Repo Work?

> awesome-korean-agent-skills is **100% maintained by AI agents**.

## Automation Architecture

```
GitHub Actions (cron)
├── 🔍 skill-scout     Weekly (Mon) — Auto-discover + classify new skills → PR
├── 🔗 link-checker    Daily — Detect dead links + auto-remove
├── ⭐ weekly-picks     Weekly (Mon) — Rotate "Skill of the Week"
└── 📊 sync-counts     Daily — Sync category counts + dates
```

## How It Works

### 1. Skill Discovery (skill-scout)

Searches GitHub weekly for new Korean AI agent skills.

**Search sources:**
- GitHub topics: `claude-skills`, `agent-skills`, `claude-code`, `gemini-cli`
- Filename: repos containing `SKILL.md`
- Keywords: `에이전트 스킬`, `claude code 한국어`, etc.

**Classification process:**
1. Collect candidates via GitHub Search API
2. Deduplicate against `data/known-repos.json`
3. Analyze each candidate with Anthropic Claude API:
   - Korean language support detection
   - Category classification (26 categories)
   - Skill type (🔧/🤖/⚡/🪝) and tool compatibility
4. Auto-add to appropriate category file
5. Create PR → 24h wait → auto-merge

### 2. Link Verification (link-checker)

Daily health check on all URLs in category files.

### 3. Weekly Picks (weekly-picks)

Auto-selects 3 "Skills of the Week" with diversity and quality criteria.

### 4. Count Sync (sync-counts)

Daily sync of README item counts and dates.

## Human Role

- **Supervision**: Review auto-generated PRs (skill-scout PRs wait 24h)
- **Override**: Close incorrect PRs, manually fix misclassifications
- **Category management**: New category creation is human-decided (agent suggests via Issues)

## License

CC0 — Feel free to adapt this automation for your own awesome list.
```

- [ ] **Step 3: README.md 브랜딩 추가**

README.md 상단에 뱃지와 소개 문구 추가. 기존 내용의 바로 아래에 삽입:

기존 첫 줄들:
```markdown
# Awesome Korean Agent Skills

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![CC0](https://img.shields.io/badge/license-CC0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](contributing.md)
```

변경 후:
```markdown
# Awesome Korean Agent Skills

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![CC0](https://img.shields.io/badge/license-CC0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](contributing.md)
[![🤖 Agent-Maintained](https://img.shields.io/badge/maintained_by-AI_Agent-blueviolet)](docs/how-it-works.md)

> 한국어 AI 코딩 에이전트 스킬 · 에이전트 · 룰 · 훅을 **기능별**로 모은 큐레이션

> 🤖 **이 레포는 100% AI 에이전트가 자동으로 운영합니다.**
> 스킬 발견 · 분류 · 추가 · 링크 검증 · 주간 추천까지 모두 자동화되어 있습니다.
> 사람은 감독만 합니다. [어떻게 돌아가는지 보기 →](docs/how-it-works.md)
```

README 하단 "기여하기" 섹션 바로 위에 "이 레포는 어떻게 돌아가나?" 링크 섹션 추가:

```markdown
## 🤖 자동화

이 레포는 GitHub Actions 기반 AI 에이전트가 자동으로 운영합니다.

| 워크플로우 | 주기 | 역할 |
|---|---|---|
| skill-scout | 주 1회 | 신규 스킬 발견 · 분류 · 추가 |
| link-checker | 매일 | 죽은 링크 감지 · 제거 |
| weekly-picks | 주 1회 | "이 주의 스킬" 로테이션 |
| sync-counts | 매일 | 항목 수 · 날짜 동기화 |

자세한 동작 원리는 [여기](docs/how-it-works.md)에서 확인하세요.
```

- [ ] **Step 4: README.en.md 동일 브랜딩 추가**

README.en.md에도 동일한 구조로 영문 뱃지, 소개 문구, 자동화 섹션 추가:

뱃지 행에 추가:
```markdown
[![🤖 Agent-Maintained](https://img.shields.io/badge/maintained_by-AI_Agent-blueviolet)](docs/how-it-works.en.md)
```

소개 문구:
```markdown
> 🤖 **This repo is 100% maintained by AI agents.**
> Skill discovery, classification, link validation, and weekly picks — all automated.
> Humans only supervise. [See how it works →](docs/how-it-works.en.md)
```

자동화 섹션:
```markdown
## 🤖 Automation

This repo is automatically maintained by AI agents via GitHub Actions.

| Workflow | Schedule | Role |
|---|---|---|
| skill-scout | Weekly | Discover · classify · add new skills |
| link-checker | Daily | Detect · remove dead links |
| weekly-picks | Weekly | Rotate "Skill of the Week" |
| sync-counts | Daily | Sync item counts · dates |

See [how it works](docs/how-it-works.en.md) for details.
```

- [ ] **Step 5: CHANGELOG.md 갱신**

```markdown
# Changelog

## 2026-04-10

- 🤖 자동 유지보수 시스템 도입
  - skill-scout: 주간 신규 스킬 자동 발견 + 분류
  - link-checker: 매일 죽은 링크 자동 제거
  - weekly-picks: 주간 추천 자동 로테이션
  - sync-counts: 매일 카운트 + 날짜 동기화
  - CI: PR 검증 (테이블 포맷, 중복, 링크)
- README에 "100% AI Agent-Maintained" 브랜딩 추가
- `docs/how-it-works.md` 자동화 구조 설명 페이지 추가
- `data/` 디렉토리 초기화 (known-repos.json, weekly-picks-history.json)

## 2026-04-01

- 첫 릴리즈
- 26개 카테고리, 400+ 스킬/에이전트 수록
- 대상 도구: Claude Code, Gemini CLI, Codex CLI, Cursor, OpenCode, Windsurf
- 개발 스킬 15개 + 일상·업무 스킬 7개 + 종합 레포 4개 카테고리
- GitHub Pages 랜딩 페이지 + SEO 메타태그
- Google Search Console 등록
```

- [ ] **Step 6: 커밋**

```bash
git add docs/how-it-works.md docs/how-it-works.en.md README.md README.en.md CHANGELOG.md
git commit -m "feat: add 100% agent-maintained branding and how-it-works docs"
```

---

### Task 8: GitHub 레포 설정

**Files:** 없음 (GitHub 설정)

- [ ] **Step 1: 라벨 생성**

```bash
cd /path/to/awesome-korean-agent-skills
gh label create "auto-merge" --color "0E8A16" --description "자동 머지 대상 PR"
gh label create "skill-scout" --color "5319E7" --description "skill-scout 워크플로우가 생성한 PR"
gh label create "link-check" --color "D93F0B" --description "link-checker 워크플로우가 생성한 PR"
gh label create "weekly-picks" --color "FBCA04" --description "weekly-picks 워크플로우가 생성한 PR"
gh label create "sync-counts" --color "0075CA" --description "sync-counts 워크플로우가 생성한 PR"
gh label create "needs-review" --color "E4E669" --description "사람의 검토가 필요한 항목"
```

- [ ] **Step 2: ANTHROPIC_API_KEY Secret 설정 안내**

GitHub 레포 Settings → Secrets and variables → Actions → New repository secret:
- Name: `ANTHROPIC_API_KEY`
- Value: Anthropic API 키

```bash
# CLI로도 가능 (대화형)
gh secret set ANTHROPIC_API_KEY
```

- [ ] **Step 3: Auto-merge 활성화**

GitHub 레포 Settings → General → Pull Requests:
- ✅ "Allow auto-merge" 체크

Branch protection rule (main):
- "Require status checks to pass before merging" → CI workflow의 `validate` job 추가
- "Require approvals" → 0 (자동 머지를 위해 승인 불필요로 설정)
- 또는 `CODEOWNERS` 없이 운영

```bash
# branch protection 확인
gh api repos/J-nowcow/awesome-korean-agent-skills/branches/main/protection 2>/dev/null || echo "보호 규칙 없음"
```

- [ ] **Step 4: 워크플로우 수동 테스트**

모든 파일 push 후 각 워크플로우를 수동 실행하여 동작 확인:

```bash
# 먼저 모든 변경사항 push
git push origin main

# 각 워크플로우 수동 실행
gh workflow run sync-counts.yml
gh workflow run link-checker.yml
gh workflow run weekly-picks.yml
gh workflow run skill-scout.yml

# 실행 상태 확인
gh run list --limit 4
```

Expected: 각 워크플로우가 성공적으로 실행되거나, 변경 없음으로 스킵

---

### Task 9: 최종 검증

- [ ] **Step 1: 전체 워크플로우 확인**

```bash
# 워크플로우 목록 확인
gh workflow list

# 가장 최근 실행 결과 확인
gh run list --limit 8
```

- [ ] **Step 2: 생성된 PR 확인**

```bash
# 자동 생성된 PR 목록
gh pr list --label "auto-merge"
```

- [ ] **Step 3: README 렌더링 확인**

GitHub에서 README.md 열어서:
- 🤖 Agent-Maintained 뱃지 표시 확인
- 소개 문구 표시 확인
- "이 주의 스킬" 테이블 정상 확인
- 자동화 섹션 표시 확인
- how-it-works 링크 동작 확인

- [ ] **Step 4: 최종 커밋 (필요 시)**

마지막 조정사항이 있으면 커밋:

```bash
git add -A
git commit -m "chore: final adjustments for auto-maintenance system"
git push origin main
```
