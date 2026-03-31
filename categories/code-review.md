[← 목록으로](../README.md)

# 코드 리뷰

> 코드 품질, 보안, 유지보수성을 검토하는 스킬과 에이전트

### 🤖 Agents

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| code-reviewer | CC | 커뮤니티 | SOLID 원칙, 심각도별 보안·성능 리뷰 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/code-reviewer.md) |
| critic | CC | 커뮤니티 | 작업 계획·코드 최종 품질 게이트, 승인/거부 판정 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/critic.md) |
| code-reviewer | CC | 커뮤니티 | 품질+보안 종합 리뷰, 모든 코드 변경에 필수 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/code-reviewer.md) |
| Python/Go/Rust/Java/Kotlin/C++/TS Reviewer (7종) | CC | 커뮤니티 | 언어별 관용 패턴·보안 전문 리뷰 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/tree/main/agents) — python-reviewer.md, go-reviewer.md, rust-reviewer.md, java-reviewer.md, kotlin-reviewer.md, cpp-reviewer.md, typescript-reviewer.md |
| Flutter Reviewer | CC | 커뮤니티 | 위젯·상태관리·Dart 접근성 검토 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/flutter-reviewer.md) |
| Database Reviewer | CC | 커뮤니티 | 쿼리 최적화·스키마·PostgreSQL/Supabase | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/database-reviewer.md) |
| Healthcare Reviewer | CC | 커뮤니티 | 임상 안전성·PHI 컴플라이언스 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/healthcare-reviewer.md) |
| code-reviewer | CC | 커뮤니티 | 보안+품질 통합 리뷰 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/agents/code-reviewer.md) |
| code-reviewer | CC | 커뮤니티 | 보안, 베스트 프랙티스 전문 리뷰 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace/blob/main/plugins/ai-pair-programming/agents/code-reviewer.md) |

### 🔧 Skills

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| frontend-code-review | CC | 커뮤니티 | .tsx/.ts/.js 프론트엔드 전용 체크리스트 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/tree/main/skills/frontend-code-review) |
| review | CC | 커뮤니티 | 현재 브랜치 변경사항 코드 리뷰 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/review) |
| eval | CC | 커뮤니티 | 기능/품질/독창성/보안 4축 평가 점수 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/eval) |
| code-review | CC | 커뮤니티 | 보안, 성능, 유지보수성 중심 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins/tree/main/plugins/development/skills/code-review) |
| requesting-code-review | CC | 커뮤니티 | 작업 완료/머지 전 서브에이전트 리뷰 디스패치 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/requesting-code-review) |
| receiving-code-review | CC | 커뮤니티 | 리뷰 피드백 수신 시 기술적 엄격성으로 검토 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/receiving-code-review) |
