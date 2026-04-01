[← 목록으로](../README.md)

# 디버깅 & 빌드 에러

> 루트 원인 분석, 빌드 에러 해결, 언어별 빌드 리졸버

## 🤖 Agents

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| debugger | CC | 루트 원인 분석, 회귀 격리, 스택 트레이스 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/debugger.md) |
| tracer | CC | 경쟁 가설·증거 수집으로 인과 관계 추론 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/tracer.md) |
| build-error-resolver | CC | 빌드/TS 오류 최소 diff로 수정 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/build-error-resolver.md) |
| C++/Go/Java/Kotlin/Rust/PyTorch Build Resolver (6종) | CC | 언어별 빌드 에러 전문 리졸버 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/tree/main/agents) — cpp-build-resolver.md 등 |
| bug-hunter | CC | 버그 체계적 탐지·분석·수정 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace/blob/main/plugins/ai-pair-programming/agents/bug-hunter.md) |

## 🔧 Skills

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| build-fix | CC | TypeScript 빌드 에러 점진적 수정 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/build-fix) |
| systematic-debugging | CC | 4단계(조사→패턴→가설→구현) 디버깅 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/systematic-debugging) |
| root-cause-tracing | CC | 콜 스택 역추적으로 원본 트리거 식별 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/root-cause-tracing) |

## ⚡ Commands

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| debugging-strategies | CC | 체계적 디버깅, 프로파일링, 루트 코즈 분석 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/commands/debugging-strategies/SKILL.md) |

## 🪝 Hooks

| 이름 | 도구 | 설명 | 언어 | 레포 |
|------|------|------|------|------|
| failure-tracker | CC | 도구 실패 패턴 기록, 반복 실패 시 에스컬레이션 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/blob/main/hooks/failure-tracker.sh) |
