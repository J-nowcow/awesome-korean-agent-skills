# Awesome Korean Agent Skills

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![CC0](https://img.shields.io/badge/license-CC0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](contributing.md)

> A curated collection of Korean AI coding agent skills, agents, rules, and hooks organized **by function**

English | [한국어](README.md)

Korean skills scattered across multiple repos are grouped **by function** so you can compare them at a glance. "I want to automate code reviews" — browse this list, check the tools and sources, and pick what fits.

---

## Table of Contents

- [What Are AI Agent Skills?](#what-are-ai-agent-skills)
- [Tool Compatibility](#tool-compatibility)
- [Legend](#legend)
- **Development Skills**
  - [Code Review](#code-review)
  - [Testing & TDD](#testing--tdd)
  - [Security Audit](#security-audit)
  - [Project Init & Scaffolding](#project-init--scaffolding)
  - [Debugging & Build Errors](#debugging--build-errors)
  - [Documentation](#documentation)
  - [Git & Workflow](#git--workflow)
  - [Refactoring & Code Cleanup](#refactoring--code-cleanup)
  - [Multi-Agent Orchestration](#multi-agent-orchestration)
  - [AI & Prompt Engineering](#ai--prompt-engineering)
  - [Web Frontend](#web-frontend)
  - [Backend](#backend)
  - [Performance Optimization](#performance-optimization)
  - [Game Development](#game-development)
  - [DevOps & Deployment](#devops--deployment)
- **Daily Life & Work Skills**
  - [Korean Life Services](#korean-life-services)
  - [Communication](#communication)
  - [Content & Marketing](#content--marketing)
  - [Writing & Korean Language](#writing--korean-language)
  - [Media](#media)
  - [Office & Documents](#office--documents)
  - [Research & Web](#research--web)
- **Comprehensive Repos**
  - [Frameworks (All-in-One)](#frameworks-all-in-one)
  - [Skill Collections](#skill-collections)
  - [Guides & Tutorials](#guides--tutorials)
  - [Utility Tools](#utility-tools)
- [Contributing](#contributing)

---

## What Are AI Agent Skills?

AI agent skills are **instruction files that teach AI coding assistants new capabilities**. Written in Markdown (`SKILL.md`), they are automatically loaded and used by the AI when needed.

**How it works:**
1. **Discovery** — The AI checks available skill names and descriptions from the skill list
2. **Load** — When a relevant task is detected, it reads the full instructions
3. **Execute** — Performs the task according to the instructions

Beyond skills, there are various forms including **Agents** (expert personas), **Commands** (slash commands), **Hooks** (event triggers), and **Rules** (coding conventions). This list categorizes all of them by function.

> See also: the Korean guide at [heilcheng/awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills) for more details.

---

## Tool Compatibility

The `SKILL.md` format is converging as the de facto industry standard. The same skill file can be shared across multiple tools.

| Tool | Config Location | Format | SKILL.md Compatible |
|------|----------------|--------|:---:|
| Claude Code | `.claude/skills/` | SKILL.md | O |
| Gemini CLI | `.gemini/skills/` | SKILL.md | O |
| OpenAI Codex CLI | `~/.codex/skills/` | SKILL.md | O |
| GitHub Copilot | `.github/skills/` | .skill.md | O |
| OpenCode | `.opencode/skills/` | SKILL.md | O |
| Cursor | `.cursor/rules/` | .mdc | X (proprietary format) |
| Windsurf | `.windsurf/rules/` | .md | △ (similar) |
| Cline | `.clinerules/` | .md | △ (similar) |
| Amazon Q | `.amazonq/rules/` | .md | △ (similar) |

---

## Legend

| Icon | Meaning |
|------|---------|
| 🔧 | Skill |
| 🤖 | Agent |
| ⚡ | Command |
| 🪝 | Hook |

| Tool Code | Tool |
|-----------|------|
| CC | Claude Code |
| GC | Gemini CLI |
| CX | Codex CLI |
| CP | GitHub Copilot |
| CR | Cursor |
| OC | OpenCode |
| WS | Windsurf |

| Source | Meaning |
|--------|---------|
| `Official` | Provided directly by the tool maker |
| `Partner` | Endorsed or collaborative with the maker |
| `Community` | Created by individuals or teams |

| Language Tag | Meaning |
|-------------|---------|
| `Korean` | Skill content is in Korean |
| `EN+KO` | English-based, Korean README provided |
| `Multi(KO)` | Multi-language auto-detection, includes Korean |

---

# Development Skills

## Code Review

> Skills and agents for reviewing code quality, security, and maintainability

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| code-reviewer | 🤖 | CC | Community | SOLID principles, severity-based security & performance review | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| critic | 🤖 | CC | Community | Work plan & code final quality gate, approve/reject judgment | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| code-reviewer | 🤖 | CC | Community | Comprehensive quality + security review, mandatory for all code changes | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Python/Go/Rust/Java/Kotlin/C++/TS Reviewer | 🤖 | CC | Community | Language-specific idiomatic pattern & security review (7 types) | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Flutter Reviewer | 🤖 | CC | Community | Widget, state management, Dart idioms, accessibility review | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Database Reviewer | 🤖 | CC | Community | Query optimization, schema design, PostgreSQL/Supabase | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Healthcare Reviewer | 🤖 | CC | Community | Clinical safety, PHI compliance, medical data integrity | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| code-reviewer | 🤖 | CC | Community | Integrated security + quality review | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| frontend-code-review | 🔧 | CC | Community | .tsx/.ts/.js frontend-specific checklist | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| review | 🔧 | CC | Community | Code review for current branch changes | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| eval | 🔧 | CC | Community | 4-axis evaluation scoring: functionality/quality/originality/security | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| code-review | 🔧 | CC | Community | Security, performance, maintainability focused | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| code-reviewer | 🤖 | CC | Community | Security and best practices expert review | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| requesting-code-review | 🔧 | CC | Community | Dispatch sub-agent review before task completion/merge | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| receiving-code-review | 🔧 | CC | Community | Review feedback reception with technical rigor | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |

## Testing & TDD

> Test-driven development, E2E testing, coverage analysis

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| test-engineer | 🤖 | CC | Community | Unit/integration/E2E test strategy design, TDD guide | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| qa-tester | 🤖 | CC | Community | tmux session-based interactive CLI testing | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| verifier | 🤖 | CC | Community | Evidence-based verification of completion claims | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ultraqa | 🔧 | CC | Community | QA cycle: test, verify, fix loop until goal is met | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| visual-verdict | 🔧 | CC | Community | Visual QA comparing screenshots vs reference | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| tdd-guide | 🤖 | CC | Community | Enforces TDD, guarantees 80%+ coverage | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| e2e-runner | 🤖 | CC | Community | Playwright E2E test creation, execution, artifact capture | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| Go/Rust/C++/Kotlin TDD | ⚡ | CC | Community | Language-specific TDD workflows (4 types) | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| tdd | 🔧 | CC | Community | RED-GREEN-REFACTOR test-driven development | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| e2e-verify | 🔧 | CC | Community | Feature-based E2E test creation and execution | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| e2e-agent-browser | 🔧 | CC | Community | Accessibility tree-based stable browser testing | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| verify | 🔧 | CC | Community | Integrated type check, lint, test, build verification | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| python-testing-patterns | 🔧 | CC | Community | Comprehensive pytest, fixtures, mocking test strategy | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| test-generator | 🔧 | CC | Community | Automatic unit/integration/E2E test generation | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| tdd | ⚡ | CC | Community | Test first, one unit of work at a time | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| verify-loop | ⚡ | CC | Community | Automatic re-verification loop (max 3 retries) | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| verification-engine | 🔧 | CC | Community | Sub-agent based fresh-context verification engine | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| test-driven-development | 🔧 | CC | Community | Write tests before implementation in TDD | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| testing-patterns | 🔧 | CC | Community | NestJS test patterns based on Suites 3.x | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |

## Security Audit

> OWASP, secret detection, threat modeling, AWS security

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| security-reviewer | 🤖 | CC | Community | OWASP Top 10, secret detection, auth/authz checks | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| security-reviewer | 🤖 | CC | Community | OWASP Top 10, secrets, SSRF, injection auto-flagging | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| owasp-review | 🔧 | CC | Community | Security code review based on OWASP Top 10 2025 | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| aws-well-architected | 🔧 | CC | Community | AWS Well-Architected security, reliability, performance, cost, operations, sustainability (6 pillars) | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| security-pipeline | 🔧 | CC | Community | CWE Top 25 + STRIDE automated security verification pipeline | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| security-compliance | ⚡ | CC | Community | SOC2/ISO27001/GDPR/HIPAA compliance | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| db-guard | 🪝 | CC | Community | Block dangerous SQL like DROP/TRUNCATE | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| output-secret-filter | 🪝 | CC | Community | Detect and mask secrets in tool execution output | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| defense-in-depth | 🔧 | CC | Community | Data validation at every layer | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| config-change-guard | 🪝 | CC | Community | Config file change detection and alerting | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## Project Init & Scaffolding

> Framework-specific project creation, spec & plan generation

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| nextjs15-init | 🔧 | CC | Community | Next.js 15 + App Router + ShadCN + Zustand | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| flutter-init | 🔧 | CC | Community | Clean Architecture + Riverpod Flutter project | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| landing-page-guide | 🔧 | CC | Community | High-conversion landing page with 11 key elements | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| init-project | ⚡ | CC | Community | Next/Vite/Go/Python/Rust project initialization | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| fastapi-templates | 🔧 | CC | Community | Production-grade FastAPI project generation | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| spec | 🔧 | CC | Community | Generate detailed SPEC.md through deep questioning | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| prd | ⚡ | CC | Community | Generate PRD + SPEC in one go | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| planner | 🤖 | CC | Community | Collect requirements via interview, save execution plan | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| analyst | 🤖 | CC | Community | Product scope to acceptance criteria, gap & edge case identification | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| deep-interview | 🔧 | CC | Community | Socratic interview followed by autonomous execution | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| deepinit | 🔧 | CC | Community | Generate hierarchical AGENTS.md docs for codebase | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| planner | 🤖 | CC | Community | Implementation planning for complex features/refactoring | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| spec-kit | ⚡ | CC | Community | constitution, specify, plan, tasks, implement workflow (10 commands) | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| $plan / $prd / $execute | 🔧 | GC | Community | Plan, PRD, execute workflow | EN+KO | [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) |

## Debugging & Build Errors

> Root cause analysis, build error resolution, language-specific build resolvers

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| debugger | 🤖 | CC | Community | Root cause analysis, regression isolation, stack trace analysis | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| tracer | 🤖 | CC | Community | Competing hypotheses, evidence collection for causal reasoning | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| build-error-resolver | 🤖 | CC | Community | Fix build/TS errors with minimal diff | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| C++/Go/Java/Kotlin/Rust/PyTorch Build Resolver | 🤖 | CC | Community | Language-specific build error resolvers (6 types) | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| build-fix | 🔧 | CC | Community | Incremental TypeScript build error fixing | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| failure-tracker | 🪝 | CC | Community | Record tool failure patterns, escalate on repeated failures | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| debugging-strategies | ⚡ | CC | Community | Systematic debugging, profiling, root cause analysis | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| systematic-debugging | 🔧 | CC | Community | 4-phase debugging (investigate, pattern, hypothesis, implement) | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| root-cause-tracing | 🔧 | CC | Community | Call stack backtracing to identify original trigger | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| bug-hunter | 🤖 | CC | Community | Systematic bug detection, analysis, and fixing | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

## Documentation

> Technical doc generation, Korean documentation, codemaps

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| korean-docs | 🔧 | CC | Community | Professional Korean technical docs (README, API docs, guides) | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| qa / qa-list / qa-merge | 🔧 | CC | Community | Q&A doc recording, listing, merging (3 types) | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| document-specialist | 🤖 | CC | Community | Local & external official doc search and synthesis | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| writer | 🤖 | CC | Community | README, API, architecture docs, code comments | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| doc-updater | 🤖 | CC | Community | Codemap updates, README & guide generation | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| docs-lookup | 🤖 | CC | Community | Look up latest library docs via Context7 | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| update-codemaps / update-docs | ⚡ | CC | Community | Codebase structure docs + source-based doc sync | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| handoff | 🔧 | CC | Community | HANDOFF.md task handover doc before session end | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| workthrough | 🔧 | CC | Community | Auto-record structured docs of changes & verification results | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| web-to-markdown | 🔧 | CC | Community | Convert web page URL to markdown and save | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| document-builder | 🤖 | CC | Community | Generate hierarchical CLAUDE.md and agent-docs | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| draw-diagram | 🔧 | CC | Community | Draw.io XML diagrams (architecture, ERD, AWS) | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## Git & Workflow

> Commits, PRs, worktrees, branching strategies

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| git-master | 🤖 | CC | Community | Atomic commits, style detection, rebase & history management | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| commit-push-pr | 🔧 | CC | Community | Commit, push, and PR in one step | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| git-commit | ⚡ | CC | Community | Conventional Commits 1.0.0 smart commit | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| git-worktree | ⚡ | CC | Community | Safe Git worktree management (add/remove/list/sync) | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| worktree-start / worktree-cleanup | ⚡ | CC | Community | Worktree creation for parallel dev + cleanup after PR | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| git-workflow | 🔧 | CC | Community | Branching strategy, commit conventions, PR management guide | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| hook-git-auto-backup | 🪝 | CC | Community | Auto git commit backup on session end | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| finishing-a-development-branch | 🔧 | CC | Community | Present merge/PR/cleanup options after implementation complete | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| worktree-tracker | 🪝 | CC | Community | Worktree lifecycle tracking and orphan prevention | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## Refactoring & Code Cleanup

> Dead code removal, technical debt resolution, code simplification

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| code-simplifier | 🤖 | CC | Community | Improve clarity & maintainability while preserving functionality | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ai-slop-cleaner | 🔧 | CC | Community | Safely delete AI-generated unnecessary code with regression safety | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| refactor-cleaner | 🤖 | CC | Community | Identify & remove dead code via knip/depcheck/ts-prune | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| simplify | 🔧 | CC | Community | Remove unnecessary abstractions, duplication, complexity | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| techdebt | 🔧 | CC | Community | Clean up duplicate code, console.log, unused imports | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| refactor-clean | ⚡ | CC | Community | Safely remove dead code with test verification | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |

## Multi-Agent Orchestration

> Automation that coordinates multiple AI agents in parallel or sequence

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| autopilot | 🔧 | CC | Community | Autonomous full-cycle: idea, design, plan, implement, QA | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| team | 🔧 | CC | Community | Coordinate N agents on a shared task list | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ralph | 🔧 | CC | Community | Self-referential loop until completion condition met | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ultrawork | 🔧 | CC | Community | Parallel execution engine for independent tasks | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| ccg | 🔧 | CC | Community | Claude-Codex-Gemini triple model parallel, then synthesize results | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| omc-teams | 🔧 | CC | Community | Run Claude/Codex/Gemini workers in parallel via tmux | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| devfleet | ⚡ | CC | Community | Deploy multiple Claude agents in parallel to worktrees | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| orchestrate | ⚡ | CC | Community | Sequential, tmux, and worktree orchestration guide | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| multi-workflow | ⚡ | CC | Community | Intelligent routing: frontend to Gemini, backend to Codex | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| team-orchestrator | 🔧 | CC | Community | Team composition, task distribution, dependency management, result aggregation | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| autodev / autodev-parallel | 🔧 | CC | Community | Ralph Loop autonomous development (sequential/parallel) | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| tth | ⚡ | CC | Community | Toss Silo + Musk 5-Step + Ralph Loop combined | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| subagent-driven-development | 🔧 | CC | Community | Dispatch fresh sub-agent for each independent task | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |

## AI & Prompt Engineering

> Prompt optimization, cross-model collaboration, self-learning

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| codex-claude-loop | 🔧 | CC | Community | Claude (implement) and Codex (verify) dual AI feedback loop | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| codex-claude-cursor-loop | 🔧 | CC | Community | Claude, Codex, Cursor triple AI engineering loop | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| prompt-coach | 🔧 | CC | Community | Improve prompt quality by analyzing session logs | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| prompt-enhancer | 🔧 | CC | Community | Expand short requests into detailed structured requirements | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| meta-prompt-generator | 🔧 | CC | Community | Simple request to parallel-optimized slash command | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| ask | 🔧 | CC | Community | Auto-routing to Claude/Codex/Gemini CLI | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| learner | 🔧 | CC | Community | Auto-extract reusable skills from conversations | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| context-budget | ⚡ | CC | Community | Context window usage analysis and optimization | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| model-route | ⚡ | CC | Community | Optimal model recommendation based on complexity & budget | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| prompt-optimize | ⚡ | CC | Community | Transform prompts into ECC-enhanced optimized versions | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| continuous-learning-v2 | 🔧 | CC | Community | Instinct-based learning with confidence scoring and atomic instincts | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| skill-factory | 🔧 | CC | Community | Auto-convert session patterns into reusable skills | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| prompt-engineering | 🔧 | CC | Community | Command, hook, and skill prompt writing optimization | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| compact-guide | 🔧 | CC | Community | Context window management and token optimization | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## Web Frontend

> React, Next.js, Tailwind, UI/UX design

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| react-patterns | 🔧 | CC | Community | React 19 Server Components, Actions, use() hook | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| shadcn-ui | 🔧 | CC | Community | shadcn/ui installation, config, and implementation guide | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| tailwind-design-system | 🔧 | CC | Community | Tailwind CSS design system construction | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| typescript-advanced-types | 🔧 | CC | Community | Generics, conditional, mapped, utility types | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| ui-ux-pro-max | 🔧 | CC | Community | 50 styles, 21 palettes, 9 stacks comprehensive UI generation | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| frontend | 🔧 | CC | Community | Big-tech style (Stripe, Vercel, Apple) UI development | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| stitch series | 🔧 | CC | Community | Stitch analyze, design, prompt, React conversion (4 types) | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| frontend-design | 🔧 | CC | Community | Original production-grade frontend UI generation | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| designer | 🤖 | CC | Community | Visual UI/UX implementation, components, typography, motion | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| cache-components | 🔧 | CC | Community | Next.js Cache Components + PPR guide | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| Toss FE Cursor Rule | 🔧 | CR | Community | Toss Frontend Fundamentals 600-line rule | Korean | [Gist](https://gist.github.com/toy-crane/dde6258997519d954063a536fc72d055) |

## Backend

> NestJS, FastAPI, API design, databases

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| NestJS Expert Agents (7 types) | 🤖 | CC | Community | Fastify, BullMQ, CQRS, Microservices, Redis, Suites, TypeORM | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| fastapi-templates | 🔧 | CC | Community | Production-grade FastAPI project | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| async-python-patterns | 🔧 | CC | Community | Python asyncio async patterns guide | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| api-design-principles | 🔧 | CC | Community | REST and GraphQL API design principles | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| api-design | 🔧 | CC | Community | RESTful API and GraphQL schema design | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## Performance Optimization

> Profiling, caching, bundle size, AWS performance

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| performance-optimizer | 🤖 | CC | Community | Bottleneck identification, bundle reduction, memory leak, rendering optimization | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| performance-expert | 🤖 | CC | Community | Speed and efficiency improvement expert | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| vercel-react-best-practices | 🔧 | CC | Community | Vercel React/Next.js performance optimization guide | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| aws-wa-performance | 🔧 | CC | Community | AWS resource selection, scaling, caching review | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |

## Game Development

> Unity, Blender, C# scripting

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| unity-dev-toolkit (7 skills) | 🔧 | CC | Community | Compile fix, scene optimization, script validation, templates, testing, UI selection, UIToolkit | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| unity-dev-toolkit (4 agents) | 🤖 | CC | Community | Architect, performance, refactoring, scripting experts | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| unity-editor-toolkit | 🔧 | CC | Community | WebSocket-based real-time Unity Editor control (500+ features) | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| blender-toolkit | 🔧 | CC | Community | Blender real-time control, Mixamo animation retargeting | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

## DevOps & Deployment

> CI/CD, release automation, monitoring, session management

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| ci-cd-patterns | 🔧 | CC | Community | GitHub Actions, deployment strategy patterns guide | Korean | [claude-integration](https://github.com/m16khb/claude-integration) |
| auto-release-manager | 🔧 | CC | Community | Version update & release automation for all project types | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| harness-audit | 🔧 | CC | Community | Full health diagnosis of hooks/skills/agents/rules | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| harness-diagnostics | 🔧 | CC | Community | 12-principle self-diagnosis and improvement suggestions | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |
| checkpoint | ⚡ | CC | Community | Work state save/restore/list/diff/delete | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| session-wrap | 🔧 | CC | Community | Session cleanup with 4 parallel sub-agents before end | EN+KO | [claude-forge](https://github.com/sangrokjung/claude-forge) |
| pm2 | ⚡ | CC | Community | Analyze project and generate PM2 service commands | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| save/resume-session | ⚡ | CC | Community | Session state save and restore | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| aws-wa-cost / operational-excellence | 🔧 | CC | Community | AWS cost optimization / operational excellence review | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| hook-session-summary | 🪝 | CC | Community | Track file operations during session and generate summary report | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| hook-sound-notifications | 🪝 | CC | Community | Audio notifications per event | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| hook-complexity-monitor | 🪝 | CC | Community | Code complexity monitoring, 14 language support | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |

---

# Daily Life & Work Skills

## Korean Life Services

> Automation for everyday services used in Korea

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| SRT/KTX Booking | 🔧 | CC/CX/OC | Community | Train reservation automation | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |
| KakaoTalk Mac CLI | 🔧 | CC/CX/OC | Community | KakaoTalk message automation | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |
| KBO Games | 🔧 | CC/CX/OC | Community | Baseball game results lookup | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |
| Lotto Check | 🔧 | CC/CX/OC | Community | Winning number lookup | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |
| Package Tracking | 🔧 | CC/CX/OC | Community | Delivery tracking | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |
| Toss Securities | 🔧 | CC/CX/OC | Community | Toss Securities integration | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |

## Communication

> Email, messenger, notification management

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| chief-of-staff | 🤖 | CC | Community | Email, Slack, LINE, Messenger triage + reply drafting | EN+KO | [everything-claude-code](https://github.com/affaan-m/everything-claude-code) |
| configure-notifications | 🔧 | CC | Community | Natural language configuration for Telegram, Discord, Slack notifications | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

## Content & Marketing

> Card news, design prompts, image generation

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| card-news-generator-v2 | 🔧 | CC | Community | Auto-generate 600x600 Instagram card news | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| design-prompt-generator-v2 | 🔧 | CC | Community | 7-step design prompt for Lovable/Cursor/Bolt | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| midjourney-cardnews-bg | 🔧 | CC | Community | Midjourney prompt for card news backgrounds | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| nano-banana | 🔧 | CC | Community | Gemini-based blog images, thumbnails, icon generation | Korean | [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) |

## Writing & Korean Language

> AI text correction, style transformation, Korean document writing

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| humanizer | 🔧 | CC/CR/WS | Community | Transform AI text to human style (KatFishNet paper-based) | Korean | [korean-skills](https://github.com/daleseo/korean-skills) |
| grammar-checker | 🔧 | CC/CR/WS | Community | Korean grammar check based on National Institute of Korean Language standards | Korean | [korean-skills](https://github.com/daleseo/korean-skills) |
| style-guide | 🔧 | CC/CR/WS | Community | Korean writing style guide | Korean | [korean-skills](https://github.com/daleseo/korean-skills) |
| korean-docs | 🔧 | CC | Community | Professional Korean technical document writing | Korean | [roboco-io/plugins](https://github.com/roboco-io/plugins) |
| writer-memory | 🔧 | CC | Community | Korean creative writing memory tracking characters, relationships, themes | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

## Media

> YouTube subtitles, image processing

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| youtube-kr-subtitle | 🔧 | CC | Community | Auto-generate Korean YouTube subtitles | Korean | [claude-skill-youtube-kr-subtitle](https://github.com/Koomook/claude-skill-youtube-kr-subtitle) |
| gemini-logo-remover | 🔧 | CC | Community | Watermark/logo removal via OpenCV inpainting | Korean | [my-skills](https://github.com/bear2u/my-skills) |

## Office & Documents

> Word, Excel, PPT, PDF, HWP processing

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| docx | 🔧 | CC | Official | Word document creation, editing, change tracking | English | [anthropics/skills](https://github.com/anthropics/skills) |
| xlsx | 🔧 | CC | Official | Spreadsheet formulas, charts, data transformation | English | [anthropics/skills](https://github.com/anthropics/skills) |
| pptx | 🔧 | CC | Official | Slide layouts, template adjustments | English | [anthropics/skills](https://github.com/anthropics/skills) |
| pdf | 🔧 | CC | Official | Text, table, metadata extraction | English | [anthropics/skills](https://github.com/anthropics/skills) |
| HWP Processing | 🔧 | CC/CX/OC | Community | Korean HWP file processing | Korean | [k-skill](https://github.com/NomaDamas/k-skill) |

## Research & Web

> Web search, web scraping, data collection

| Name | Type | Tool | Source | Description | Lang | Repo |
|------|:---:|:---:|:---:|-------------|:---:|------|
| web-search | 🔧 | CC | Community | DuckDuckGo text/news/image search | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| web-to-markdown | 🔧 | CC | Community | Web page to markdown conversion (AI-optimized mode) | Korean | [my-skills](https://github.com/bear2u/my-skills) |
| browser-pilot | 🔧 | CC | Community | CDP-based browser automation, scraping, form filling | EN+KO | [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) |
| external-context | 🔧 | CC | Community | Query decomposition then parallel agent external doc collection | EN+KO | [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |

---

# Comprehensive Repos

## Frameworks (All-in-One)

> Tools that set up agents, skills, hooks, and commands all at once upon installation

| Repo | Stars | Tool | Scale | Lang |
|------|------:|:---:|-------|:---:|
| [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) | 17.6K | CC | 19 agents + 31 skills | EN+KO |
| [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) | 45K | OC | 25+ hooks | EN+KO |
| [claude-forge](https://github.com/sangrokjung/claude-forge) | 611 | CC | 11 agents + 16 skills + 40 cmds + 15 hooks | EN+KO |
| [everything-claude-code](https://github.com/affaan-m/everything-claude-code) | - | CC | 30 agents + 59 cmds | EN+KO |
| [bkit-claude-code](https://github.com/popup-studio-ai/bkit-claude-code) | 457 | CC | 37 skills + 32 agents | Multi(KO) |
| [bkit-gemini](https://github.com/popup-studio-ai/bkit-gemini) | 47 | GC | 35 skills | Multi(KO) |
| [bkit-codex](https://github.com/popup-studio-ai/bkit-codex) | 16 | CX | 27 skills | Multi(KO) |
| [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) | 83 | GC | 7 skills | EN+KO |

## Skill Collections

> Collections that bundle skills from various domains in a single repo

| Repo | Stars | Tool | Scale | Lang |
|------|------:|:---:|-------|:---:|
| [my-skills](https://github.com/bear2u/my-skills) | 798 | CC | 21 skills | Korean |
| [k-skill](https://github.com/NomaDamas/k-skill) | 812 | CC/CX/OC | 15 skills (Korea-specific) | Korean |
| [my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) | 110 | CC | 34 skills + 12 agents + 14 hooks | Korean |
| [roboco-io/plugins](https://github.com/roboco-io/plugins) | 3 | CC | 17 skills | Korean |
| [claude-integration](https://github.com/m16khb/claude-integration) | 0 | CC | 24 skills + 11 agents | Korean |
| [claude-code-marketplace](https://github.com/Dev-GOM/claude-code-marketplace) | 77 | CC | 16 skills + 9 agents + 18 cmds + 6 hooks | EN+KO |
| [korean-skills](https://github.com/daleseo/korean-skills) | 17 | CC/CR/WS | 3 skills (Korean writing) | Korean |

## Guides & Tutorials

> Skill usage guides, Claude Code guides, learning resources

| Repo | Stars | Description | Lang |
|------|------:|-------------|:---:|
| [claude-code-mastering](https://github.com/revfactory/claude-code-mastering) | 766 | Claude Code Korean guidebook (13 chapters) | Korean |
| [vibecoding](https://github.com/taehojo/vibecoding) | 81 | "Vibe Coding on Your Own" book official repo | Korean |
| [awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills) | 3.5K | Cross-tool skill curation directory | EN+KO |
| [ai-coding-guidelines](https://github.com/SongJohnhawk/ai-coding-guidelines) | 0 | AI Coding Guide v8.0 | Korean |

## Utility Tools

> Rule conversion & management tools, Korean language support tools

| Repo | Description |
|------|-------------|
| [rulesync](https://github.com/dyoshikawa/rulesync) | Auto-generate rule files for 21 AI tools from a single source |
| [vibe-rules](https://github.com/FutureExcited/vibe-rules) | Convert rule formats between Cursor, Claude Code, and others |
| [claude-code-korean](https://github.com/tantara/claude-code-korean) | Claude Code Korean i18n |

---

## Contributing

Please read [contributing.md](contributing.md). Let's build the Korean AI coding skill ecosystem together!

If you discover a new skill, open a PR. For category suggestions, open an Issue.
