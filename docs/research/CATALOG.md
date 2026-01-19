# RDR Catalog

Quick reference for Research Decision Records.

> **Synthesis docs are authoritative** — RDRs document decisions, synthesis docs document the resulting patterns. When in doubt, consult [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md).

## Quick Reference

| I want to understand...        | Start with                |
| ------------------------------ | ------------------------- |
| How agents hand off context    | RDR-018 (task-centric)    |
| Why we have 5 agents not 6     | RDR-016 (consolidation)   |
| What tools Copilot provides    | RDR-015 (agent tools)     |
| Memory/persistence approaches  | RDR-018, RDR-005          |
| External framework comparisons | RDR-003, RDR-004, RDR-023 |
| Skill creation guidance        | RDR-019, RDR-020          |

## By Status

| Status            | RDRs                                                  |
| ----------------- | ----------------------------------------------------- |
| Adopted           | 016, 018, 020                                         |
| Partially Adopted | 003, 004, 010, 012, 014, 015, 017, 019, 022, 023, 024 |
| Future            | 005, 013                                              |
| Informational     | 006                                                   |

## By Topic

### External Frameworks

| RDR                                   | Title                 | Status            | Summary                                               |
| ------------------------------------- | --------------------- | ----------------- | ----------------------------------------------------- |
| [003](RDR-003-feature-dev.md)         | Anthropic Feature-Dev | Partially Adopted | 7-phase workflow; adopted clarifying Qs, arch options |
| [004](RDR-004-superpowers.md)         | Superpowers           | Partially Adopted | Skills-based TDD; adopted skill testing methodology   |
| [005](RDR-005-beads.md)               | Beads Memory          | Future            | JSONL memory system for multi-session continuity      |
| [023](RDR-023-ralph-wiggum.md)        | Ralph Wiggum          | Partially Adopted | Bash loop methodology; reinforces subagent fan-out    |
| [024](RDR-024-claude-code-mastery.md) | Claude Code Mastery   | Partially Adopted | CLAUDE.md guide; reinforces phase-based workflow      |

### Context Management

| RDR                                      | Title                  | Status            | Summary                                      |
| ---------------------------------------- | ---------------------- | ----------------- | -------------------------------------------- |
| [010](RDR-010-subagents-context-fork.md) | Subagents Context Fork | Partially Adopted | Subagents fork context; handoffs preserve it |
| [012](RDR-012-planning-with-files.md)    | Planning with Files    | Partially Adopted | 3-file pattern; adopted read-before-decide   |

### VSCode / Platform

| RDR                                        | Title              | Status            | Summary                                  |
| ------------------------------------------ | ------------------ | ----------------- | ---------------------------------------- |
| [013](RDR-013-vscode-browser-testing.md)   | Browser Testing    | Future            | Playwright MCP for browser automation    |
| [014](RDR-014-vscode-copilot-settings.md)  | Copilot Settings   | Partially Adopted | ~50 settings; documented recommendations |
| [015](RDR-015-copilot-agent-tools.md)      | Agent Tools        | Partially Adopted | 30+ tools; validated current selections  |
| [017](RDR-017-agent-spec-compatibility.md) | Spec Compatibility | Partially Adopted | VS Code vs Claude Code spec alignment    |

### Agent Workflow

| RDR                                        | Title                    | Status  | Summary                                      |
| ------------------------------------------ | ------------------------ | ------- | -------------------------------------------- |
| [016](RDR-016-agent-consolidation.md)      | Agent Consolidation      | Adopted | Merged Research+Plan → Explore               |
| [018](RDR-018-task-centric-persistence.md) | Task-Centric Persistence | Adopted | `.tasks/` persistence; removed Handoff agent |

### Skills

| RDR                            | Title        | Status            | Summary                                   |
| ------------------------------ | ------------ | ----------------- | ----------------------------------------- |
| [019](RDR-019-skill-review.md) | Skill Review | Partially Adopted | Systematic skill evaluation               |
| [020](RDR-020-design-skill.md) | Design Skill | Adopted           | UI/UX skill with Linear/Stripe aesthetics |

### Best Practices

| RDR                               | Title               | Status            | Summary                                    |
| --------------------------------- | ------------------- | ----------------- | ------------------------------------------ |
| [006](RDR-006-agentic-future.md)  | Agentic Future      | Informational     | Predictions; validates framework direction |
| [022](RDR-022-six-tips-agents.md) | Six Tips for Agents | Partially Adopted | Code health 30-40%; Rule of Five review    |

## Archive

_See [archive/](archive/) for rejected/superseded RDRs._
