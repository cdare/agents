# RDR-010: Subagents and Context Forking

| Field      | Value                                                                                                            |
| ---------- | ---------------------------------------------------------------------------------------------------------------- |
| **Source** | [VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#context-isolated-subagents) |
| **Date**   | 2026-01-01                                                                                                       |
| **Status** | Partially Adopted                                                                                                |

## Summary

VS Code supports **handoffs** (preserve context) and **subagents** (fork to isolated context). Subagents return only final summaries, compacting context automatically.

## Decision

**Adopted:**

- Enable `runSubagent` tool in Explore agent
- Use subagents for context-heavy explorations (file tracing, dependency analysis)
- Subagents auto-compact: main context receives summaries, not intermediate file reads

**Rejected:**

- Subagents for phase transitions—handoffs preserve needed context
- Tasks requiring user interaction

## Key Insight

Subagents complement handoffs, don't replace them. Use handoffs for phase transitions (Explore→Implement); use subagents for parallel investigations within a phase.

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — "Frequent Intentional Compaction"
- [RDR-023](RDR-023-ralph-wiggum.md) — Reinforces subagent fan-out pattern
