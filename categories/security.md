[← 목록으로](../README.md)

# 보안 감사

> OWASP, 시크릿 탐지, 위협 모델링, AWS 보안

### 🤖 Agents

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| security-reviewer | CC | 커뮤니티 | OWASP Top 10, 시크릿 탐지, 인증/인가 | 영+한 | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode/blob/main/agents/security-reviewer.md) |
| security-reviewer | CC | 커뮤니티 | OWASP·시크릿·SSRF·인젝션 자동 플래그 | 영+한 | [everything-claude-code](https://github.com/affaan-m/everything-claude-code/blob/main/agents/security-reviewer.md) |

### 🔧 Skills

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| owasp-review | CC | 커뮤니티 | OWASP Top 10 2025 기반 보안 코드 리뷰 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins/tree/main/plugins/security/skills/owasp-review) |
| aws-well-architected (6개 필러) | CC | 커뮤니티 | 보안·안정성·성능·비용·운영·지속가능성 | 한국어 | [roboco-io/plugins](https://github.com/roboco-io/plugins/tree/main/plugins/security/skills) |
| security-pipeline | CC | 커뮤니티 | CWE Top 25 + STRIDE 자동 보안 파이프라인 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/tree/main/skills/security-pipeline) |
| defense-in-depth | CC | 커뮤니티 | 모든 레이어에서 데이터 검증 | 한국어 | [claude-integration](https://github.com/m16khb/claude-integration/tree/main/superpowers/defense-in-depth) |

### ⚡ Commands

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| security-compliance | CC | 커뮤니티 | SOC2/ISO27001/GDPR/HIPAA 컴플라이언스 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/commands/security-compliance/SKILL.md) |

### 🪝 Hooks

| 이름 | 도구 | 출처 | 설명 | 언어 | 레포 |
|------|------|------|------|------|------|
| db-guard | CC | 커뮤니티 | DROP/TRUNCATE 등 위험한 SQL 차단 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/hooks/db-guard.sh) |
| output-secret-filter | CC | 커뮤니티 | 실행 결과에서 시크릿 감지·마스킹 | 영+한 | [claude-forge](https://github.com/sangrokjung/claude-forge/blob/main/hooks/output-secret-filter.sh) |
| config-change-guard | CC | 커뮤니티 | 설정 파일 변경 감지 및 경고 | 한국어 | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset/blob/main/hooks/config-change-guard.sh) |
