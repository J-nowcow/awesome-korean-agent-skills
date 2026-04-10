# Auto-Maintenance System Design

> awesome-korean-agent-skills를 AI 에이전트가 자동으로 유지보수하는 시스템

## 컨셉

**"100% AI Agent-Maintained Awesome List"** — 에이전트가 한국어 AI 코딩 스킬을 자동 발견·분류·추가·유지보수. 사람은 감독만.

## 결정 사항

| 항목 | 결정 | 근거 |
|------|------|------|
| 머지 모델 | PR + 조건부 자동 머지 | 자동이면서 개입 여지 유지 |
| 발견 소스 | 키워드 검색 + 기존 레포 업데이트 감지 | 토픽만으로는 커버리지 부족 |
| 작업 범위 | 스탠다드 (발견+유지보수+로테이션+기록+카운트) | 카테고리 신설만 제외 (Issue로 대체) |
| 실행 환경 | GitHub Actions + Node.js 스크립트 | 레포 내 완결, 관찰성 우수, 원격 트리거 제약 회피 |
| 브랜딩 | 전 요소 적용 | 레포 차별점이 자동 운영이므로 적극 표시 |

## 아키텍처

```
GitHub Actions (cron)
├── skill-scout.yml      — 주 1회 (월): 신규 스킬 발견 + 카테고리 분류 → PR (24h 대기 후 자동 머지)
├── link-checker.yml     — 매일: 죽은 링크 감지 + 제거 → PR (CI 통과 시 자동 머지)
├── weekly-picks.yml     — 주 1회 (월): "이 주의 스킬" 로테이션 → PR (CI 통과 시 자동 머지)
└── sync-counts.yml      — 매일: README 카운트/뱃지 + CHANGELOG 갱신 → PR (CI 통과 시 자동 머지)
```

## 워크플로우 상세

### 1. skill-scout.yml (핵심)

**스케줄**: `cron: '0 3 * * 1'` (매주 월요일 03:00 UTC = 한국 12:00)

**Step 1 — 후보 수집** (GitHub Search API)

토픽 기반:
- `topic:claude-skills`
- `topic:agent-skills`
- `topic:claude-code`
- `topic:gemini-cli`

파일명 기반:
- `filename:SKILL.md language:markdown`

키워드 기반:
- `"agent skill" OR "claude code" OR "gemini cli" in:readme`
- 한국어 키워드: `"스킬" OR "에이전트" OR "한국어" in:readme`

기존 레포 업데이트:
- `data/known-repos.json`에 등록된 레포들의 최근 커밋 확인
- 새 SKILL.md 파일이 추가되었는지 tree API로 체크

**Step 2 — 필터링**

- `data/known-repos.json` 대조 → 이미 처리된 레포/스킬 제외
- 최소 기준: 별 1개 이상, 최근 6개월 내 업데이트, 아카이브 아님

**Step 3 — 분류** (Gemini API)

각 후보에 대해:
1. README 및 SKILL.md 파일 fetch
2. 한국어 여부 판별 (본문 한국어 / 영+한 / 다국어(KO) / 해당없음)
3. 기존 26개 카테고리 중 매칭
4. 매칭 안 되면 → Issue 생성 ("카테고리 분류 제안")
5. 스킬 타입 판별: 🔧 Skill / 🤖 Agent / ⚡ Command / 🪝 Hook
6. 도구 호환성 판별: CC / GC / CX / CP / OC / CR / WS
7. 한 줄 설명 생성 (한국어)

**Step 4 — PR 생성**

- 해당 카테고리 md 파일에 row 추가
- `data/known-repos.json` 업데이트
- PR 제목: `🤖 [auto] 신규 스킬 N개 발견 (YYYY-MM-DD)`
- PR 본문: 발견 근거, 분류 결과, 각 항목 요약
- 라벨: `auto-merge`, `skill-scout`

**Step 5 — 자동 머지**

- CI 체크 통과 (링크 유효성, 중복 검사, 마크다운 lint)
- 24시간 대기 (사용자 검수 시간)
- 반대 없으면 자동 머지

### 2. link-checker.yml

**스케줄**: `cron: '0 5 * * *'` (매일 05:00 UTC)

**동작**:
1. 모든 카테고리 md에서 URL 추출
2. 각 URL에 HEAD 요청 (timeout 10s, retry 2회)
3. 404/timeout → 해당 row 제거
4. 아카이브된 레포 → `[Archived]` 표시 또는 제거
5. 변경 있으면 PR 생성 → CI 통과 시 자동 머지

### 3. weekly-picks.yml

**스케줄**: `cron: '0 4 * * 1'` (매주 월요일 04:00 UTC, skill-scout 이후)

**선정 기준**:
- `data/weekly-picks-history.json`에 없는 항목 (중복 방지)
- 별 수, 최근 업데이트일, 카테고리 다양성 (같은 카테고리 2개 이상 비선호)
- Gemini API로 "왜 추천?" 한 줄 생성

**동작**:
1. 전 카테고리에서 후보 풀 구성
2. 3개 선정 + 추천 사유 생성
3. README "이 주의 스킬" 테이블 교체
4. README.en.md 동일 적용 (영어)
5. `data/weekly-picks-history.json` 업데이트
6. PR 생성 → CI 통과 시 자동 머지

### 4. sync-counts.yml

**스케줄**: `cron: '0 6 * * *'` (매일 06:00 UTC, link-checker 이후)

**동작**:
1. 각 카테고리 md의 실제 항목 수(테이블 row 수) 집계
2. README 테이블의 "항목 수" 컬럼 동기화
3. README.en.md 동일 적용
4. "최근 업데이트" 날짜 갱신
5. CHANGELOG.md에 당일 변경사항 append (당일 머지된 PR 요약)
6. 변경 있으면 PR 생성 → CI 통과 시 자동 머지

## 데이터 파일

```
data/
├── known-repos.json              — 처리된 레포 인덱스
└── weekly-picks-history.json     — 과거 추천 이력
```

### known-repos.json 스키마

```json
{
  "repos": [
    {
      "url": "https://github.com/bear2u/my-skills",
      "last_scanned": "2026-04-10T03:00:00Z",
      "skills": [
        {
          "name": "humanizer",
          "category": "korean-writing",
          "file_path": "skills/humanizer/SKILL.md",
          "added_date": "2026-04-01"
        }
      ]
    }
  ],
  "last_updated": "2026-04-10T03:00:00Z"
}
```

### weekly-picks-history.json 스키마

```json
{
  "picks": [
    {
      "date": "2026-04-07",
      "items": [
        {"name": "humanizer", "repo": "daleseo/korean-skills", "category": "korean-writing"},
        {"name": "SRT/KTX 예매", "repo": "NomaDamas/k-skill", "category": "korean-services"},
        {"name": "code-reviewer", "repo": "Yeachan-Heo/oh-my-claudecode", "category": "code-review"}
      ]
    }
  ]
}
```

## 자동 머지 조건

| 워크플로우 | 대기 시간 | CI 체크 | 라벨 |
|---|---|---|---|
| skill-scout | 24시간 | 링크·중복·lint | `auto-merge`, `skill-scout` |
| link-checker | 즉시 | lint | `auto-merge`, `link-check` |
| weekly-picks | 즉시 | lint | `auto-merge`, `weekly-picks` |
| sync-counts | 즉시 | lint | `auto-merge`, `sync-counts` |

자동 머지 구현: `peter-evans/enable-pull-request-automerge` 또는 `gh pr merge --auto --squash`

## CI 체크 (PR 검증)

`.github/workflows/ci.yml`:
- 마크다운 lint (markdownlint)
- 테이블 포맷 검증 (각 카테고리 md의 row 형식)
- URL 중복 검사 (같은 레포가 같은 카테고리에 중복 등록)
- 링크 유효성 (신규 추가 URL만)

## 브랜딩 변경

### README.md 상단 추가

뱃지:
```markdown
[![🤖 Agent-Maintained](https://img.shields.io/badge/maintained_by-AI_Agent-blueviolet)](docs/how-it-works.md)
```

소개 문단 (기존 소개글 아래):
```markdown
> 🤖 **이 레포는 100% AI 에이전트가 자동으로 운영합니다.**
> 스킬 발견 · 분류 · 추가 · 링크 검증 · 주간 추천까지 모두 자동화되어 있습니다.
> 사람은 감독만 합니다. [어떻게 돌아가는지 보기 →](docs/how-it-works.md)
```

### "이 레포는 어떻게 돌아가나?" 페이지

`docs/how-it-works.md`:
- 4개 워크플로우 구조 설명
- 발견 → 분류 → PR → 자동 머지 플로우 다이어그램
- data 파일 역할 설명
- CI 체크 목록
- "직접 만들고 싶다면?" 섹션 (워크플로우 복제 가이드)

### README.en.md 동일 적용

영문 버전도 동일한 뱃지·소개·링크 추가.

### PR 본문 템플릿

각 워크플로우별 자동 생성 PR 본문에:
```markdown
> 🤖 이 PR은 `{workflow_name}` 워크플로우가 자동 생성했습니다.
> [워크플로우 실행 로그]({run_url})
```

### 커밋/PR author

- GitHub Actions 기본: `github-actions[bot]`
- PR 본문에 워크플로우 출처 명시

### CHANGELOG 포맷

```markdown
## [YYYY-MM-DD]

### 🤖 자동 업데이트
- 신규 스킬 N개 추가 (skill-scout)
- 죽은 링크 N개 제거 (link-checker)
- 이 주의 스킬 갱신 (weekly-picks)
```

## 필요 Secrets

| Secret | 용도 |
|---|---|
| `GEMINI_API_KEY` | Gemini API LLM 호출 |

GitHub Actions 기본 `GITHUB_TOKEN`으로 PR 생성·머지 가능.
단, 자동 머지에 branch protection이 걸려있으면 `PAT` 또는 GitHub App token 필요.

## 구현 순서 (권장)

1. **data 파일 생성** — known-repos.json, weekly-picks-history.json 초기 데이터
2. **CI 워크플로우** — ci.yml (다른 워크플로우의 체크 기반)
3. **sync-counts** — 가장 단순, 외부 API 불필요, 동작 검증용
4. **link-checker** — 외부 HTTP만 필요, LLM 불필요
5. **weekly-picks** — LLM 필요하지만 스코프 작음
6. **skill-scout** — 가장 복잡, 마지막
7. **브랜딩 변경** — README, docs/how-it-works.md, CHANGELOG
8. **README.en.md 동기화**

## 리스크 & 대응

| 리스크 | 대응 |
|---|---|
| GitHub Search API rate limit (인증 시 30req/min) | 후보 수집을 배치로, 필요 시 페이지네이션 |
| Gemini API 비용 | skill-scout만 LLM 사용, 나머지는 스크립트 (free tier 사용) |
| 스팸/저품질 레포 자동 추가 | 최소 기준(별 1+, 6개월 내 업데이트), LLM 필터 |
| 카테고리 잘못 분류 | 24시간 대기로 사용자 검수 시간 확보 |
| 자동 머지 실패 (conflict) | PR에 conflict 라벨 → 수동 해결 알림 |
