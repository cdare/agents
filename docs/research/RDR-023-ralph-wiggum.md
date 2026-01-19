# RDR-023: Ralph Wiggum

| Field      | Value                                                                                                     |
| ---------- | --------------------------------------------------------------------------------------------------------- |
| **Source** | [anthropics/claude-code plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) |
| **Date**   | 2026-01-19                                                                                                |
| **Status** | Partially Adopted                                                                                         |

## Summary

Autonomous development via bash loops (`while true; do cat PROMPT.md | claude; done`). Fresh context per iteration, disk-based state, one task per loop.

## Decision

**Adopted:**

- Subagent fan-out for context preservation (reinforces RDR-010)
- Disposable plans (regenerate when trajectory goes wrong)
- Backpressure via tests/lints as gates
- 40-60% context utilization as "smart zone"

**Rejected:**

- External bash orchestration (AGENTS is interactive, human-in-loop)
- Skip permissions (AGENTS uses per-agent tool restrictions)
- Completion promise pattern (AGENTS uses handoff buttons)

## Key Insight

Ralph maximizes autonomous throughput; AGENTS maximizes collaboration quality. Ralph's context management insights (subagents as memory extension, disposable plans) are valuable without adopting its autonomous architecture.

## See Also

- [RDR-010](RDR-010-subagents-context-fork.md) — Subagent fan-out
- [memory-and-continuity.md](../synthesis/memory-and-continuity.md) — Disk-based state patterns
