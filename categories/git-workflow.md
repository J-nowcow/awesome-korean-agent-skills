[← 목록으로](../README.md)

# Git & 워크플로우

> 커밋, PR, 워크트리, 브랜칭 전략

### 🤖 Agents

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| git-master | CC | 커뮤니티 | 원자적 커밋, 스타일 감지, 리베이스·히스토리 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/git-master.md) |

### 🔧 Skills

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| commit-push-pr | CC | 커뮤니티 | 커밋→푸시→PR 한 번에 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/tree/main/skills/commit-push-pr) |
| git-workflow | CC | 커뮤니티 | 브랜칭, 커밋 컨벤션, PR 관리 가이드 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins/tree/main/plugins/workflow/skills/git-workflow) |
| finishing-a-development-branch | CC | 커뮤니티 | merge/PR/cleanup 옵션 제시 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/finishing-a-development-branch) |
| project-session-manager | CC | 커뮤니티 | 워크트리 기반 이슈·PR 개발 환경 관리 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/tree/main/skills/project-session-manager) |

### ⚡ Commands

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| git-commit | CC | 커뮤니티 | Conventional Commits 1.0.0 스마트 커밋 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/blob/main/plugins/git-workflows/commands/git-commit.md) |
| git-worktree | CC | 커뮤니티 | worktree 안전 관리 (add/remove/list/sync) | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/blob/main/plugins/git-workflows/commands/git-worktree.md) |
| worktree-start / worktree-cleanup | CC | 커뮤니티 | 병렬 개발용 Worktree 생성 + PR 후 정리 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/tree/main/commands) — worktree-start.md, worktree-cleanup.md |

### 🪝 Hooks

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| hook-git-auto-backup | CC | 커뮤니티 | 세션 종료 시 자동 git 커밋 백업 | 영+한 | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace/tree/main/plugins/hook-git-auto-backup) |
| worktree-tracker | CC | 커뮤니티 | 워크트리 라이프사이클 추적, 고아 방지 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/blob/main/hooks/worktree-tracker.sh) |
