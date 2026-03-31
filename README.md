# Awesome Korean Agent Skills

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![CC0](https://img.shields.io/badge/license-CC0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](contributing.md)

> 한국어 AI 코딩 에이전트 스킬 · 에이전트 · 룰 · 훅을 **기능별**로 모은 큐레이션

[English](README.en.md)

여러 레포에 흩어진 한국어 스킬을 **같은 기능끼리** 모아서 한눈에 비교할 수 있습니다. "코드 리뷰 자동화하고 싶다" → 이 목록에서 도구와 출처를 보고 골라 쓰세요.

---

## 목차

- [AI 에이전트 스킬이란?](#ai-에이전트-스킬이란)
- [도구별 호환성](#도구별-호환성)
- [범례](#범례)
- **개발 스킬**
  - [코드 리뷰](#코드-리뷰)
  - [테스트 & TDD](#테스트--tdd)
  - [보안 감사](#보안-감사)
  - [프로젝트 초기화 & 스캐폴딩](#프로젝트-초기화--스캐폴딩)
  - [디버깅 & 빌드 에러](#디버깅--빌드-에러)
  - [문서화](#문서화)
  - [Git & 워크플로우](#git--워크플로우)
  - [리팩토링 & 코드 정리](#리팩토링--코드-정리)
  - [멀티에이전트 오케스트레이션](#멀티에이전트-오케스트레이션)
  - [AI & 프롬프트 엔지니어링](#ai--프롬프트-엔지니어링)
  - [웹 프론트엔드](#웹-프론트엔드)
  - [백엔드](#백엔드)
  - [성능 최적화](#성능-최적화)
  - [게임 개발](#게임-개발)
  - [DevOps & 배포](#devops--배포)
- **일상 · 업무 스킬**
  - [한국 생활 서비스](#한국-생활-서비스)
  - [커뮤니케이션](#커뮤니케이션)
  - [콘텐츠 & 마케팅](#콘텐츠--마케팅)
  - [글쓰기 & 한국어](#글쓰기--한국어)
  - [미디어](#미디어)
  - [오피스 & 문서](#오피스--문서)
  - [리서치 & 웹](#리서치--웹)
- **종합 레포**
  - [프레임워크 (올인원)](#프레임워크-올인원)
  - [종합 스킬 컬렉션](#종합-스킬-컬렉션)
  - [가이드 & 튜토리얼](#가이드--튜토리얼)
  - [유틸리티 도구](#유틸리티-도구)
- [기여하기](#기여하기)

---

## AI 에이전트 스킬이란?

AI 에이전트 스킬은 **AI 코딩 어시스턴트에게 새로운 능력을 가르치는 지침 파일**입니다. 마크다운(`SKILL.md`)으로 작성하며, AI가 필요할 때 자동으로 불러와서 사용합니다.

**작동 방식:**
1. **탐색** — AI가 사용 가능한 스킬 목록에서 이름과 설명을 확인
2. **로드** — 관련 작업을 감지하면 전체 지침을 읽어옴
3. **실행** — 지침에 따라 작업 수행

스킬 외에도 **Agent**(전문가 페르소나), **Command**(슬래시 명령), **Hook**(이벤트 트리거), **Rule**(코딩 규칙) 등 다양한 형태가 있으며, 이 목록은 이 모든 것을 기능 기준으로 분류합니다.

> 참고: [heilcheng/awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills)의 한국어 가이드에서 더 자세한 설명을 볼 수 있습니다.

---

## 도구별 호환성

`SKILL.md` 포맷이 사실상 업계 표준으로 수렴 중입니다. 같은 스킬 파일을 여러 도구에서 공유할 수 있습니다.

| 도구 | 설정 위치 | 포맷 | SKILL.md 호환 |
|------|-----------|------|:---:|
| Claude Code | `.claude/skills/` | SKILL.md | O |
| Gemini CLI | `.gemini/skills/` | SKILL.md | O |
| OpenAI Codex CLI | `~/.codex/skills/` | SKILL.md | O |
| GitHub Copilot | `.github/skills/` | .skill.md | O |
| OpenCode | `.opencode/skills/` | SKILL.md | O |
| Cursor | `.cursor/rules/` | .mdc | X (독자 포맷) |
| Windsurf | `.windsurf/rules/` | .md | △ (유사) |
| Cline | `.clinerules/` | .md | △ (유사) |
| Amazon Q | `.amazonq/rules/` | .md | △ (유사) |

---

## 범례

| 표기 | 의미 |
|------|------|
| 🔧 | Skill |
| 🤖 | Agent |
| ⚡ | Command |
| 🪝 | Hook |

| 도구 코드 | 도구 |
|-----------|------|
| CC | Claude Code |
| GC | Gemini CLI |
| CX | Codex CLI |
| CP | GitHub Copilot |
| CR | Cursor |
| OC | OpenCode |
| WS | Windsurf |

| 출처 | 의미 |
|------|------|
| `공식` | 도구 제작사가 직접 제공 |
| `파트너` | 제작사 공인 또는 협업 |
| `커뮤니티` | 개인 또는 팀이 제작 |

| 언어 표기 | 의미 |
|----------|------|
| `한국어` | 스킬 본문이 한국어 |
| `영+한` | 영어 기반, 한국어 README 제공 |
| `다국어(KO)` | 다국어 자동 감지, 한국어 포함 |

---

# 개발 스킬

## 코드 리뷰

> 코드 품질, 보안, 유지보수성을 검토하는 스킬과 에이전트

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| code-reviewer | 🤖 | CC | 커뮤니티 | SOLID 원칙, 심각도별 보안·성능 리뷰 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| critic | 🤖 | CC | 커뮤니티 | 작업 계획·코드 최종 품질 게이트, 승인/거부 판정 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| code-reviewer | 🤖 | CC | 커뮤니티 | 품질+보안 종합 리뷰, 모든 코드 변경에 필수 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Python/Go/Rust/Java/Kotlin/C++/TS Reviewer | 🤖 | CC | 커뮤니티 | 언어별 관용 패턴·보안 전문 리뷰 (7종) | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Flutter Reviewer | 🤖 | CC | 커뮤니티 | 위젯·상태관리·Dart 이디엄·접근성 검토 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Database Reviewer | 🤖 | CC | 커뮤니티 | 쿼리 최적화·스키마 설계·PostgreSQL/Supabase | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Healthcare Reviewer | 🤖 | CC | 커뮤니티 | 임상 안전성·PHI 컴플라이언스·의료 데이터 무결성 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| code-reviewer | 🤖 | CC | 커뮤니티 | 보안+품질 통합 리뷰 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| frontend-code-review | 🔧 | CC | 커뮤니티 | .tsx/.ts/.js 프론트엔드 전용 체크리스트 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| review | 🔧 | CC | 커뮤니티 | 현재 브랜치 변경사항 코드 리뷰 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| eval | 🔧 | CC | 커뮤니티 | 기능/품질/독창성/보안 4축 평가 점수 산출 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| code-review | 🔧 | CC | 커뮤니티 | 보안, 성능, 유지보수성 중심 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| code-reviewer | 🤖 | CC | 커뮤니티 | 보안, 베스트 프랙티스 전문 리뷰 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| requesting-code-review | 🔧 | CC | 커뮤니티 | 작업 완료/머지 전 서브에이전트 리뷰 디스패치 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| receiving-code-review | 🔧 | CC | 커뮤니티 | 리뷰 피드백 수신 시 기술적 엄격성으로 검토 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |

## 테스트 & TDD

> 테스트 주도 개발, E2E 테스트, 커버리지 분석

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| test-engineer | 🤖 | CC | 커뮤니티 | 단위/통합/E2E 테스트 전략 설계, TDD 가이드 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| qa-tester | 🤖 | CC | 커뮤니티 | tmux 세션 기반 인터랙티브 CLI 테스팅 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| verifier | 🤖 | CC | 커뮤니티 | 완료 주장에 대한 증거 기반 검증 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ultraqa | 🔧 | CC | 커뮤니티 | 목표 달성까지 테스트→검증→수정 반복 QA 사이클 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| visual-verdict | 🔧 | CC | 커뮤니티 | 스크린샷 vs 레퍼런스 비교 시각적 QA | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| tdd-guide | 🤖 | CC | 커뮤니티 | TDD 강제, 80%+ 커버리지 보장 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| e2e-runner | 🤖 | CC | 커뮤니티 | Playwright E2E 테스트 생성·실행·아티팩트 캡처 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Go/Rust/C++/Kotlin TDD | ⚡ | CC | 커뮤니티 | 언어별 TDD 워크플로 (4종) | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| tdd | 🔧 | CC | 커뮤니티 | RED-GREEN-REFACTOR 테스트 주도 개발 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| e2e-verify | 🔧 | CC | 커뮤니티 | 피처 기반 E2E 테스트 작성 및 실행 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| e2e-agent-browser | 🔧 | CC | 커뮤니티 | 접근성 트리 기반 안정적 브라우저 테스트 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| verify | 🔧 | CC | 커뮤니티 | 타입체크, 린트, 테스트, 빌드 통합 검증 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| python-testing-patterns | 🔧 | CC | 커뮤니티 | pytest, fixtures, mocking 포괄적 테스트 전략 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| test-generator | 🔧 | CC | 커뮤니티 | 유닛/통합/E2E 테스트 자동 생성 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| tdd | ⚡ | CC | 커뮤니티 | 테스트 먼저, 한 단위 작업 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| verify-loop | ⚡ | CC | 커뮤니티 | 자동 재검증 루프 (최대 3회 재시도) | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| verification-engine | 🔧 | CC | 커뮤니티 | 서브에이전트 기반 fresh-context 검증 엔진 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| test-driven-development | 🔧 | CC | 커뮤니티 | TDD 구현 전 테스트 먼저 작성 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| testing-patterns | 🔧 | CC | 커뮤니티 | Suites 3.x 기반 NestJS 테스트 패턴 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |

## 보안 감사

> OWASP, 시크릿 탐지, 위협 모델링, AWS 보안

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| security-reviewer | 🤖 | CC | 커뮤니티 | OWASP Top 10, 시크릿 탐지, 인증/인가 점검 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| security-reviewer | 🤖 | CC | 커뮤니티 | OWASP Top 10·시크릿·SSRF·인젝션 자동 플래그 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| owasp-review | 🔧 | CC | 커뮤니티 | OWASP Top 10 2025 기반 보안 코드 리뷰 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| aws-well-architected | 🔧 | CC | 커뮤니티 | AWS Well-Architected 보안·안정성·성능·비용·운영·지속가능성 (6개 필러) | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| security-pipeline | 🔧 | CC | 커뮤니티 | CWE Top 25 + STRIDE 자동 보안 검증 파이프라인 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| security-compliance | ⚡ | CC | 커뮤니티 | SOC2/ISO27001/GDPR/HIPAA 컴플라이언스 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| db-guard | 🪝 | CC | 커뮤니티 | DROP/TRUNCATE 등 위험한 SQL 차단 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| output-secret-filter | 🪝 | CC | 커뮤니티 | 도구 실행 결과에서 시크릿 감지·마스킹 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| defense-in-depth | 🔧 | CC | 커뮤니티 | 모든 레이어에서 데이터 검증 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| config-change-guard | 🪝 | CC | 커뮤니티 | 설정 파일 변경 감지 및 경고 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## 프로젝트 초기화 & 스캐폴딩

> 프레임워크별 프로젝트 생성, 명세·계획 수립

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| nextjs15-init | 🔧 | CC | 커뮤니티 | Next.js 15 + App Router + ShadCN + Zustand | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| flutter-init | 🔧 | CC | 커뮤니티 | Clean Architecture + Riverpod Flutter 프로젝트 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| landing-page-guide | 🔧 | CC | 커뮤니티 | 11가지 핵심 요소 고전환율 랜딩페이지 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| init-project | ⚡ | CC | 커뮤니티 | Next/Vite/Go/Python/Rust 프로젝트 초기화 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| fastapi-templates | 🔧 | CC | 커뮤니티 | 프로덕션 수준 FastAPI 프로젝트 생성 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| spec | 🔧 | CC | 커뮤니티 | 심층 질문으로 상세 SPEC.md 명세 생성 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| prd | ⚡ | CC | 커뮤니티 | PRD + SPEC 한 번에 생성 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| planner | 🤖 | CC | 커뮤니티 | 인터뷰로 요구사항 수집 후 실행 계획 저장 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| analyst | 🤖 | CC | 커뮤니티 | 제품 범위→인수 조건, 갭·엣지케이스 식별 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| deep-interview | 🔧 | CC | 커뮤니티 | 소크라테스식 인터뷰 후 자율 실행 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| deepinit | 🔧 | CC | 커뮤니티 | 코드베이스에 계층적 AGENTS.md 문서 생성 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| planner | 🤖 | CC | 커뮤니티 | 복잡한 기능/리팩토링 구현 계획 수립 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| spec-kit | ⚡ | CC | 커뮤니티 | constitution→specify→plan→tasks→implement 워크플로 (10개 커맨드) | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| $plan / $prd / $execute | 🔧 | GC | 커뮤니티 | 계획·PRD·실행 워크플로 | 영+한 | [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) |

## 디버깅 & 빌드 에러

> 루트 원인 분석, 빌드 에러 해결, 언어별 빌드 리졸버

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| debugger | 🤖 | CC | 커뮤니티 | 루트 원인 분석, 회귀 격리, 스택 트레이스 분석 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| tracer | 🤖 | CC | 커뮤니티 | 경쟁 가설·증거 수집으로 인과 관계 추론 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| build-error-resolver | 🤖 | CC | 커뮤니티 | 빌드/TS 오류 최소 diff로 수정 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| C++/Go/Java/Kotlin/Rust/PyTorch Build Resolver | 🤖 | CC | 커뮤니티 | 언어별 빌드 에러 전문 리졸버 (6종) | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| build-fix | 🔧 | CC | 커뮤니티 | TypeScript 빌드 에러 점진적 수정 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| failure-tracker | 🪝 | CC | 커뮤니티 | 도구 실패 패턴 기록, 반복 실패 시 에스컬레이션 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| debugging-strategies | ⚡ | CC | 커뮤니티 | 체계적 디버깅, 프로파일링, 루트 코즈 분석 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| systematic-debugging | 🔧 | CC | 커뮤니티 | 4단계(조사→패턴→가설→구현) 디버깅 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| root-cause-tracing | 🔧 | CC | 커뮤니티 | 콜 스택 역추적으로 원본 트리거 식별 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| bug-hunter | 🤖 | CC | 커뮤니티 | 버그 체계적 탐지·분석·수정 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

## 문서화

> 기술 문서 생성, 한국어 문서 작성, 코드맵

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| korean-docs | 🔧 | CC | 커뮤니티 | 전문 한국어 기술 문서 (README, API 문서, 가이드) | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| qa / qa-list / qa-merge | 🔧 | CC | 커뮤니티 | Q&A 문서 기록·목록·통합 (3종) | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| document-specialist | 🤖 | CC | 커뮤니티 | 로컬·외부 공식 문서 검색·종합 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| writer | 🤖 | CC | 커뮤니티 | README·API·아키텍처 문서·코드 주석 작성 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| doc-updater | 🤖 | CC | 커뮤니티 | 코드맵 업데이트·README·가이드 생성 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| docs-lookup | 🤖 | CC | 커뮤니티 | Context7으로 라이브러리 최신 문서 조회 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| update-codemaps / update-docs | ⚡ | CC | 커뮤니티 | 코드베이스 구조 문서 + 소스 기반 문서 동기화 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| handoff | 🔧 | CC | 커뮤니티 | 세션 종료 전 HANDOFF.md 작업 인계 문서 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| workthrough | 🔧 | CC | 커뮤니티 | 변경사항·검증결과 구조화 문서 자동 기록 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| web-to-markdown | 🔧 | CC | 커뮤니티 | 웹페이지 URL→마크다운 변환 저장 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| document-builder | 🤖 | CC | 커뮤니티 | 계층적 CLAUDE.md 및 agent-docs 생성 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| draw-diagram | 🔧 | CC | 커뮤니티 | Draw.io XML 다이어그램 (아키텍처, ERD, AWS) | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## Git & 워크플로우

> 커밋, PR, 워크트리, 브랜칭 전략

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| git-master | 🤖 | CC | 커뮤니티 | 원자적 커밋, 스타일 감지, 리베이스·히스토리 관리 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| commit-push-pr | 🔧 | CC | 커뮤니티 | 커밋→푸시→PR 한 번에 실행 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| git-commit | ⚡ | CC | 커뮤니티 | Conventional Commits 1.0.0 스마트 커밋 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| git-worktree | ⚡ | CC | 커뮤니티 | Git worktree 안전 관리 (add/remove/list/sync) | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| worktree-start / worktree-cleanup | ⚡ | CC | 커뮤니티 | 병렬 개발용 Worktree 생성 + PR 후 정리 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| git-workflow | 🔧 | CC | 커뮤니티 | 브랜칭 전략, 커밋 컨벤션, PR 관리 가이드 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| hook-git-auto-backup | 🪝 | CC | 커뮤니티 | 세션 종료 시 자동 git 커밋 백업 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| finishing-a-development-branch | 🔧 | CC | 커뮤니티 | 구현 완료 후 merge/PR/cleanup 옵션 제시 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| worktree-tracker | 🪝 | CC | 커뮤니티 | 워크트리 라이프사이클 추적 및 고아 방지 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## 리팩토링 & 코드 정리

> 데드 코드 제거, 기술 부채 해소, 코드 간소화

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| code-simplifier | 🤖 | CC | 커뮤니티 | 기능 유지하면서 명확성·유지보수성 향상 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ai-slop-cleaner | 🔧 | CC | 커뮤니티 | AI 생성 불필요 코드를 회귀 안전하게 삭제 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| refactor-cleaner | 🤖 | CC | 커뮤니티 | knip/depcheck/ts-prune으로 데드 코드 식별·제거 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| simplify | 🔧 | CC | 커뮤니티 | 불필요한 추상화, 중복, 복잡성 제거 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| techdebt | 🔧 | CC | 커뮤니티 | 중복 코드, console.log, 미사용 import 정리 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| refactor-clean | ⚡ | CC | 커뮤니티 | 테스트 검증으로 안전하게 데드 코드 제거 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |

## 멀티에이전트 오케스트레이션

> 여러 AI 에이전트를 병렬·순차로 조율하는 자동화

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| autopilot | 🔧 | CC | 커뮤니티 | 아이디어→설계→계획→구현→QA 전 주기 자율 수행 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| team | 🔧 | CC | 커뮤니티 | 공유 태스크 목록에서 N개 에이전트 조율 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ralph | 🔧 | CC | 커뮤니티 | 완료 조건까지 자기 참조 루프 반복 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ultrawork | 🔧 | CC | 커뮤니티 | 독립 태스크 동시 처리 병렬 실행 엔진 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ccg | 🔧 | CC | 커뮤니티 | Claude-Codex-Gemini 3중 모델 병렬 후 결과 종합 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| omc-teams | 🔧 | CC | 커뮤니티 | tmux에서 Claude/Codex/Gemini 워커 병렬 실행 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| devfleet | ⚡ | CC | 커뮤니티 | 멀티 Claude 에이전트를 워크트리에 병렬 배포 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| orchestrate | ⚡ | CC | 커뮤니티 | 순차·tmux·워크트리 오케스트레이션 가이드 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| multi-workflow | ⚡ | CC | 커뮤니티 | 프론트→Gemini, 백엔드→Codex 지능형 라우팅 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| team-orchestrator | 🔧 | CC | 커뮤니티 | 팀 구성, 작업 분배, 의존성 관리, 결과 집계 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| autodev / autodev-parallel | 🔧 | CC | 커뮤니티 | Ralph Loop 자율 개발 (순차/병렬) | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| tth | ⚡ | CC | 커뮤니티 | 토스 사일로 + 머스크 5-Step + Ralph Loop 결합 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| subagent-driven-development | 🔧 | CC | 커뮤니티 | 독립 작업마다 fresh 서브에이전트 디스패치 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |

## AI & 프롬프트 엔지니어링

> 프롬프트 최적화, 모델 간 협업, 자기 학습

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| codex-claude-loop | 🔧 | CC | 커뮤니티 | Claude(구현) ↔ Codex(검증) 듀얼 AI 피드백 루프 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| codex-claude-cursor-loop | 🔧 | CC | 커뮤니티 | Claude→Codex→Cursor 3중 AI 엔지니어링 루프 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| prompt-coach | 🔧 | CC | 커뮤니티 | 세션 로그 분석으로 프롬프트 품질 개선 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| prompt-enhancer | 🔧 | CC | 커뮤니티 | 짧은 요청→상세 구조화 요구사항 확장 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| meta-prompt-generator | 🔧 | CC | 커뮤니티 | 간단한 요청→병렬처리 최적화 슬래시 커맨드 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| ask | 🔧 | CC | 커뮤니티 | Claude/Codex/Gemini CLI 자동 라우팅 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| learner | 🔧 | CC | 커뮤니티 | 대화에서 재사용 가능한 스킬 자동 추출 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| context-budget | ⚡ | CC | 커뮤니티 | 컨텍스트 창 사용량 분석 및 최적화 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| model-route | ⚡ | CC | 커뮤니티 | 복잡도·예산 기반 최적 모델 추천 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| prompt-optimize | ⚡ | CC | 커뮤니티 | 프롬프트를 ECC 강화 최적화 버전으로 변환 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| continuous-learning-v2 | 🔧 | CC | 커뮤니티 | Instinct 기반 학습, 신뢰도 점수 원자적 instinct | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| skill-factory | 🔧 | CC | 커뮤니티 | 세션 패턴→재사용 스킬 자동 변환 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| prompt-engineering | 🔧 | CC | 커뮤니티 | 커맨드·훅·스킬 프롬프트 작성 최적화 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| compact-guide | 🔧 | CC | 커뮤니티 | 컨텍스트 윈도우 관리 및 토큰 최적화 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## 웹 프론트엔드

> React, Next.js, Tailwind, UI/UX 디자인

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| react-patterns | 🔧 | CC | 커뮤니티 | React 19 Server Components, Actions, use() hook | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| shadcn-ui | 🔧 | CC | 커뮤니티 | shadcn/ui 설치·설정·구현 가이드 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| tailwind-design-system | 🔧 | CC | 커뮤니티 | Tailwind CSS 디자인 시스템 구축 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| typescript-advanced-types | 🔧 | CC | 커뮤니티 | 제네릭, 조건부, 매핑, 유틸리티 타입 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| ui-ux-pro-max | 🔧 | CC | 커뮤니티 | 50 스타일, 21 팔레트, 9 스택 종합 UI 생성 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| frontend | 🔧 | CC | 커뮤니티 | 빅테크(Stripe, Vercel, Apple) 스타일 UI 개발 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| stitch 시리즈 | 🔧 | CC | 커뮤니티 | Stitch 분석→디자인→프롬프트→React 변환 (4종) | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| frontend-design | 🔧 | CC | 커뮤니티 | 독창적 프로덕션급 프론트엔드 UI 생성 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| designer | 🤖 | CC | 커뮤니티 | 시각적 UI/UX 구현, 컴포넌트·타이포·모션 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| cache-components | 🔧 | CC | 커뮤니티 | Next.js Cache Components + PPR 가이드 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| 토스 FE Cursor Rule | 🔧 | CR | 커뮤니티 | 토스 Frontend Fundamentals 600줄 룰 | 한국어 | [Gist](https://gist.github.com/toy-crane/dde6258997519d954063a536fc72d055) |

## 백엔드

> NestJS, FastAPI, API 설계, 데이터베이스

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| NestJS 전문 에이전트 7종 | 🤖 | CC | 커뮤니티 | Fastify, BullMQ, CQRS, Microservices, Redis, Suites, TypeORM | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| fastapi-templates | 🔧 | CC | 커뮤니티 | 프로덕션 수준 FastAPI 프로젝트 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| async-python-patterns | 🔧 | CC | 커뮤니티 | Python asyncio 비동기 패턴 가이드 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| api-design-principles | 🔧 | CC | 커뮤니티 | REST 및 GraphQL API 설계 원칙 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| api-design | 🔧 | CC | 커뮤니티 | RESTful API 및 GraphQL 스키마 설계 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## 성능 최적화

> 프로파일링, 캐싱, 번들 크기, AWS 성능

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| performance-optimizer | 🤖 | CC | 커뮤니티 | 병목 식별·번들 감소·메모리 누수·렌더링 최적화 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| performance-expert | 🤖 | CC | 커뮤니티 | 속도 및 효율성 향상 전문가 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| vercel-react-best-practices | 🔧 | CC | 커뮤니티 | Vercel React/Next.js 성능 최적화 가이드 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| aws-wa-performance | 🔧 | CC | 커뮤니티 | AWS 리소스 선택·스케일링·캐싱 검토 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## 게임 개발

> Unity, Blender, C# 스크립팅

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| unity-dev-toolkit (7 스킬) | 🔧 | CC | 커뮤니티 | 컴파일 수정, 씬 최적화, 스크립트 검증, 템플릿, 테스트, UI 선택, UIToolkit | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| unity-dev-toolkit (4 에이전트) | 🤖 | CC | 커뮤니티 | 아키텍트, 퍼포먼스, 리팩토링, 스크립팅 전문가 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| unity-editor-toolkit | 🔧 | CC | 커뮤니티 | WebSocket 기반 실시간 Unity Editor 제어 (500+ 기능) | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| blender-toolkit | 🔧 | CC | 커뮤니티 | Blender 실시간 제어, Mixamo 애니메이션 리타게팅 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

## DevOps & 배포

> CI/CD, 릴리즈 자동화, 모니터링, 세션 관리

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| ci-cd-patterns | 🔧 | CC | 커뮤니티 | GitHub Actions, 배포 전략 패턴 가이드 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration) |
| auto-release-manager | 🔧 | CC | 커뮤니티 | 모든 프로젝트 타입 버전 업데이트·릴리즈 자동화 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| harness-audit | 🔧 | CC | 커뮤니티 | hooks/skills/agents/rules 전체 건강도 진단 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| harness-diagnostics | 🔧 | CC | 커뮤니티 | 12원칙 기반 자가 진단 및 개선 제안 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| checkpoint | ⚡ | CC | 커뮤니티 | 작업 상태 save/restore/list/diff/delete | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| session-wrap | 🔧 | CC | 커뮤니티 | 세션 종료 전 4개 병렬 서브에이전트로 정리 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| pm2 | ⚡ | CC | 커뮤니티 | 프로젝트 분석 후 PM2 서비스 명령 생성 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| save/resume-session | ⚡ | CC | 커뮤니티 | 세션 상태 저장 및 복원 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| aws-wa-cost / operational-excellence | 🔧 | CC | 커뮤니티 | AWS 비용 최적화 / 운영 우수성 검토 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| hook-session-summary | 🪝 | CC | 커뮤니티 | 세션 중 파일 작업 추적 및 요약 리포트 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| hook-sound-notifications | 🪝 | CC | 커뮤니티 | 이벤트별 오디오 알림 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| hook-complexity-monitor | 🪝 | CC | 커뮤니티 | 코드 복잡도 모니터링, 14개 언어 지원 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

---

# 일상 · 업무 스킬

## 한국 생활 서비스

> 한국에서 일상적으로 쓰는 서비스 자동화

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| SRT/KTX 예매 | 🔧 | CC/CX/OC | 커뮤니티 | 열차 예매 자동화 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |
| 카카오톡 Mac CLI | 🔧 | CC/CX/OC | 커뮤니티 | 카카오톡 메시지 자동화 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |
| KBO 경기 | 🔧 | CC/CX/OC | 커뮤니티 | 야구 경기 결과 조회 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |
| 로또 확인 | 🔧 | CC/CX/OC | 커뮤니티 | 당첨 번호 조회 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |
| 택배 조회 | 🔧 | CC/CX/OC | 커뮤니티 | 배송 추적 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |
| 토스증권 | 🔧 | CC/CX/OC | 커뮤니티 | 토스증권 연동 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |

## 커뮤니케이션

> 이메일, 메신저, 알림 관리

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| chief-of-staff | 🤖 | CC | 커뮤니티 | 이메일·Slack·LINE·Messenger 트리아지 + 답장 초안 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| configure-notifications | 🔧 | CC | 커뮤니티 | Telegram·Discord·Slack 알림 자연어 설정 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

## 콘텐츠 & 마케팅

> 카드뉴스, 디자인 프롬프트, 이미지 생성

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| card-news-generator-v2 | 🔧 | CC | 커뮤니티 | 600x600 인스타그램 카드뉴스 자동 생성 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| design-prompt-generator-v2 | 🔧 | CC | 커뮤니티 | Lovable/Cursor/Bolt용 7단계 디자인 프롬프트 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| midjourney-cardnews-bg | 🔧 | CC | 커뮤니티 | 카드뉴스 배경용 Midjourney 프롬프트 생성 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| nano-banana | 🔧 | CC | 커뮤니티 | Gemini 기반 블로그 이미지·썸네일·아이콘 생성 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## 글쓰기 & 한국어

> AI 글 교정, 문체 변환, 한국어 문서 작성

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| humanizer | 🔧 | CC/CR/WS | 커뮤니티 | AI 글을 사람 문체로 변환 (KatFishNet 논문 기반) | 한국어 | [korean-skills](https://github.com/daleseo/korean-skills) |
| grammar-checker | 🔧 | CC/CR/WS | 커뮤니티 | 국립국어원 기준 한국어 맞춤법 교정 | 한국어 | [korean-skills](https://github.com/daleseo/korean-skills) |
| style-guide | 🔧 | CC/CR/WS | 커뮤니티 | 한국어 글쓰기 스타일 가이드 | 한국어 | [korean-skills](https://github.com/daleseo/korean-skills) |
| korean-docs | 🔧 | CC | 커뮤니티 | 전문 한국어 기술 문서 작성 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| writer-memory | 🔧 | CC | 커뮤니티 | 캐릭터·관계·테마 추적 한국어 창작 메모리 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

## 미디어

> 유튜브 자막, 이미지 처리

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| youtube-kr-subtitle | 🔧 | CC | 커뮤니티 | 유튜브 한글 자막 자동 생성 | 한국어 | [claude-skill-youtube-kr-subtitle](https://github.com/Koomook/claude-skill-youtube-kr-subtitle) |
| gemini-logo-remover | 🔧 | CC | 커뮤니티 | OpenCV inpainting으로 워터마크/로고 제거 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |

## 오피스 & 문서

> Word, Excel, PPT, PDF, HWP 처리

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| docx | 🔧 | CC | 공식 | Word 문서 생성·편집·변경 추적 | 영어 | [anthropics/skills](https://github.com/anthropics/skills) |
| xlsx | 🔧 | CC | 공식 | 스프레드시트 수식·차트·데이터 변환 | 영어 | [anthropics/skills](https://github.com/anthropics/skills) |
| pptx | 🔧 | CC | 공식 | 슬라이드 레이아웃·템플릿 조정 | 영어 | [anthropics/skills](https://github.com/anthropics/skills) |
| pdf | 🔧 | CC | 공식 | 텍스트·표·메타데이터 추출 | 영어 | [anthropics/skills](https://github.com/anthropics/skills) |
| HWP 처리 | 🔧 | CC/CX/OC | 커뮤니티 | 한글 파일 처리 | 한국어 | [k-skill](https://github.com/NomaDamas/k-skill) |

## 리서치 & 웹

> 웹 검색, 웹 스크래핑, 데이터 수집

| 이름 | 유형 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|:---:|:---:|:---:|------|:---:|------|
| web-search | 🔧 | CC | 커뮤니티 | DuckDuckGo 텍스트/뉴스/이미지 검색 | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| web-to-markdown | 🔧 | CC | 커뮤니티 | 웹페이지→마크다운 변환 (AI 최적화 모드) | 한국어 | [my-skills](https://github.com/bear2u/my-skills) |
| browser-pilot | 🔧 | CC | 커뮤니티 | CDP 기반 브라우저 자동화·스크래핑·폼 작성 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| external-context | 🔧 | CC | 커뮤니티 | 쿼리 분해 후 병렬 에이전트로 외부 문서 수집 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

---

# 종합 레포

## 프레임워크 (올인원)

> 설치하면 에이전트·스킬·훅·커맨드가 한꺼번에 세팅되는 도구

| 레포 | Stars | 도구 | 규모 | 언어 |
|------|------:|:---:|------|:---:|
| [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) | 17.6K | CC | 19 agents + 31 skills | 영+한 |
| [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) | 45K | OC | 25+ hooks | 영+한 |
| [claude-forge](https://github.com/sangrokjung/claude-forge) | 611 | CC | 11 agents + 16 skills + 40 cmds + 15 hooks | 영+한 |
| [everything-claude-code](https://github.com/affaan-m/everything-claude-code) | - | CC | 30 agents + 59 cmds | 영+한 |
| [bkit-claude-code](https://github.com/popup-studio-ai/bkit-claude-code) | 457 | CC | 37 skills + 32 agents | 다국어(KO) |
| [bkit-gemini](https://github.com/popup-studio-ai/bkit-gemini) | 47 | GC | 35 skills | 다국어(KO) |
| [bkit-codex](https://github.com/popup-studio-ai/bkit-codex) | 16 | CX | 27 skills | 다국어(KO) |
| [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) | 83 | GC | 7 skills | 영+한 |

## 종합 스킬 컬렉션

> 여러 분야의 스킬을 한 레포에 모아놓은 컬렉션

| 레포 | Stars | 도구 | 규모 | 언어 |
|------|------:|:---:|------|:---:|
| [my-skills](https://github.com/bear2u/my-skills) | 798 | CC | 21 skills | 한국어 |
| [k-skill](https://github.com/NomaDamas/k-skill) | 812 | CC/CX/OC | 15 skills (한국 특화) | 한국어 |
| [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) | 110 | CC | 34 skills + 12 agents + 14 hooks | 한국어 |
| [roboco-io/plugins](https://github.com/roboco-io/plugins) | 3 | CC | 17 skills | 한국어 |
| [claude-integration](https://github.com/m16khb/claude-integration) | 0 | CC | 24 skills + 11 agents | 한국어 |
| [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) | 77 | CC | 16 skills + 9 agents + 18 cmds + 6 hooks | 영+한 |
| [korean-skills](https://github.com/daleseo/korean-skills) | 17 | CC/CR/WS | 3 skills (한국어 글쓰기) | 한국어 |

## 가이드 & 튜토리얼

> 스킬 활용법, Claude Code 가이드, 학습 자료

| 레포 | Stars | 설명 | 언어 |
|------|------:|------|:---:|
| [claude-code-mastering](https://github.com/revfactory/claude-code-mastering) | 766 | Claude Code 한국어 가이드북 13장 | 한국어 |
| [vibecoding](https://github.com/taehojo/vibecoding) | 81 | "혼자 공부하는 바이브코딩" 도서 공식 레포 | 한국어 |
| [awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills) | 3.5K | 크로스 도구 스킬 큐레이션 디렉토리 | 영+한 |
| [ai-coding-guidelines](https://github.com/SongJohnhawk/ai-coding-guidelines) | 0 | AI 코딩 가이드 v8.0 | 한국어 |

## 유틸리티 도구

> 룰 변환·관리 도구, 한국어 지원 도구

| 레포 | 설명 |
|------|------|
| [rulesync](https://github.com/dyoshikawa/rulesync) | 하나의 소스에서 21개 AI 도구용 룰 파일 자동 생성 |
| [vibe-rules](https://github.com/FutureExcited/vibe-rules) | Cursor↔Claude Code 등 룰 포맷 간 변환 |
| [claude-code-korean](https://github.com/tantara/claude-code-korean) | Claude Code 한국어 i18n |

---

## 기여하기

[contributing.md](contributing.md)를 읽어주세요. 한국어 AI 코딩 스킬 생태계를 함께 만들어갑시다!

새로운 스킬을 발견하면 PR을, 카테고리 제안은 Issue를 열어주세요.
