[← 목록으로](../README.md)

# 코드 리뷰


<!-- CAT_STATS:START -->
> 📦 **20개 항목** · 자동 갱신: 2026-07-23
<!-- CAT_STATS:END -->
> 코드 품질, 보안, 유지보수성을 검토하는 스킬과 에이전트

## 🤖 Agents

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| code-reviewer | CC | SOLID 원칙, 심각도별 보안·성능 리뷰 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/code-reviewer.md) |
| critic | CC | 작업 계획·코드 최종 품질 게이트, 승인/거부 판정 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/critic.md) |
| code-reviewer | CC | 품질+보안 종합 리뷰, 모든 코드 변경에 필수 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/code-reviewer.md) |
| Python/Go/Rust/Java/Kotlin/C++/TS Reviewer (7종) | CC | 언어별 관용 패턴·보안 전문 리뷰 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/tree/main/agents) — python-reviewer.md, go-reviewer.md, rust-reviewer.md, java-reviewer.md, kotlin-reviewer.md, cpp-reviewer.md, typescript-reviewer.md |
| Flutter Reviewer | CC | 위젯·상태관리·Dart 접근성 검토 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/flutter-reviewer.md) |
| Database Reviewer | CC | 쿼리 최적화·스키마·PostgreSQL/Supabase | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/database-reviewer.md) |
| Healthcare Reviewer | CC | 임상 안전성·PHI 컴플라이언스 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/healthcare-reviewer.md) |
| code-reviewer | CC | 보안+품질 통합 리뷰 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/agents/code-reviewer.md) |
| code-reviewer | CC | 보안, 베스트 프랙티스 전문 리뷰 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace/blob/main/plugins/ai-pair-programming/agents/code-reviewer.md) |

| ponytail | CC/GC | 가장 게으른 시니어 개발자처럼 생각하는 AI 에이전트 | 영+한 | [ponytail](https://github.com/DietrichGebert/ponytail) |
| oh-my-pi |  | 터미널용 AI 코딩 에이전트 | 영+한 | [oh-my-pi](https://github.com/can1357/oh-my-pi) |
## 🔧 Skills

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| frontend-code-review | CC | .tsx/.ts/.js 프론트엔드 전용 체크리스트 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/tree/main/skills/frontend-code-review) |
| review | CC | 현재 브랜치 변경사항 코드 리뷰 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/review) |
| eval | CC | 기능/품질/독창성/보안 4축 평가 점수 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/eval) |
| code-review | CC | 보안, 성능, 유지보수성 중심 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins/tree/main/plugins/development/skills/code-review) |

| caveman | CC | Claude Code 토큰 사용량을 줄이는 동굴인 말투 스킬 | 영+한 | [caveman](https://github.com/JuliusBrussee/caveman) |

| pipecat |  | 코드 리뷰 및 문서 자동화 스킬 | 영+한 | [pipecat](https://github.com/pipecat-ai/pipecat) |

| claude-howto-zh-cn | CC | Claude Code 코드 리뷰 전문가 스킬 | 영+한 | [claude-howto-zh-cn](https://github.com/lhfer/claude-howto-zh-cn) |

| claude-code-book-sample | CC | Claude Code 스킬을 활용한 코드 리뷰 | 영+한 | [claude-code-book-sample](https://github.com/devstefancho/claude-code-book-sample) |

| open-code-review | CC | AI 기반 코드 리뷰 CLI 도구 | 다국어(KO) | [open-code-review](https://github.com/alibaba/open-code-review) |
