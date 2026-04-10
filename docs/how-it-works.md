# 🤖 이 레포는 어떻게 돌아가나?

> awesome-korean-agent-skills는 **100% AI 에이전트가 자동으로 운영**합니다.

## 자동화 구조

4개 GitHub Actions 워크플로우:
- 🔍 skill-scout (매주 월요일): 신규 스킬 자동 발견 + 분류 + PR
- 🔗 link-checker (매일): 죽은 링크 감지 + 자동 제거
- ⭐ weekly-picks (매주 월요일): "이 주의 스킬" 자동 로테이션
- 📊 sync-counts (매일): 카테고리 항목 수 + 날짜 동기화

## 동작 방식

### 1. 스킬 발견 (skill-scout)
- GitHub Search API로 후보 수집 (토픽, SKILL.md 파일명, 키워드)
- 기존 등록 레포와 중복 제거 (data/known-repos.json)
- Anthropic Claude API로 한국어 판별 + 카테고리 분류
- PR 생성 → 24시간 대기 → 자동 머지

### 2. 링크 검증 (link-checker)
- 매일 모든 URL에 HTTP HEAD 요청
- 404/타임아웃 → 자동 제거

### 3. 주간 추천 (weekly-picks)
- 다양성, 실용성, 한국어 지원 품질 기준
- Claude API로 추천 사유 자동 생성
- 이전 추천과 중복 방지

### 4. 카운트 동기화 (sync-counts)
- 매일 README 항목 수와 날짜 갱신

## 데이터 파일
| 파일 | 역할 |
|------|------|
| data/known-repos.json | 처리된 레포 인덱스 |
| data/weekly-picks-history.json | 과거 추천 이력 |

## 사람의 역할
- 감독: 자동 생성 PR 확인
- 개입: 잘못된 분류 → PR 닫기
- 카테고리 관리: 신규 카테고리는 사람이 결정 (에이전트는 Issue로 제안)

## 직접 만들고 싶다면?
1. .github/workflows/ 워크플로우 파일 참고
2. .github/scripts/ 스크립트 복제
3. ANTHROPIC_API_KEY Secret 설정
4. 카테고리 구조에 맞게 스크립트 수정

라이선스는 CC0이므로 자유롭게 사용하세요.
