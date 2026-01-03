# Research Decision Record: planning-with-files

| Field        | Value                                            |
| ------------ | ------------------------------------------------ |
| **Source**   | https://github.com/OthmanAdi/planning-with-files |
| **Reviewed** | 2026-01-03                                       |
| **Status**   | Partially Adopted                                |

## Summary

A Claude Code skill implementing the "Manus pattern" — a 3-file approach (`task_plan.md`, `notes.md`, `[deliverable].md`) for persistent working memory during agentic sessions. Based on Manus AI's context engineering principles, it addresses goal drift and context loss during long sessions (50+ tool calls) by having agents re-read their plan file before major decisions.

## Key Concepts

| Concept                    | Description                                                               |
| -------------------------- | ------------------------------------------------------------------------- |
| **3-File Pattern**         | `task_plan.md` (phases/progress), `notes.md` (research), `deliverable.md` |
| **Attention Manipulation** | Re-read plan before decisions to refresh goals in attention window        |
| **Filesystem as Memory**   | Store in files, not context; keep only paths in working memory            |
| **Error Persistence**      | Log all failures in plan file for learning                                |
| **Append-Only Context**    | Never modify history—append only to preserve KV-cache                     |
| **Read-Before-Decide**     | Always read plan file before major decisions                              |

## Decision

### Adopted

1. **Read-Before-Decide Technique** - Added as "Attention Management" guidance in Implement agent
2. **Todo List as Attention Anchor** - Document that frequent todo updates serve as goal refresh
3. **Goal Drift Awareness** - Added to prevailing-wisdom.md as context engineering principle
4. **Framework Reference** - Document Manus pattern in framework-comparison.md

### Not Adopted

1. **Mandatory 3-File Infrastructure** - Too much friction for AGENTS' phase-based workflow
2. **New Skill/Agent** - Can be absorbed into existing guidance without new components
3. **Replacing Handoff Pattern** - Different problems (cross-session vs within-session)

### Rationale

AGENTS' phase-based workflow (Research → Plan → Implement → Review) already provides natural segmentation that reduces the "lost in the middle" problem. The Implement agent typically executes a recently-created plan, so goals are fresh at session start.

However, the insight about attention manipulation is valuable for long implementation sessions. Rather than mandating the full 3-file infrastructure, we adopt the principle: use existing mechanisms (todo list, handoff files) with periodic re-engagement to refresh goals.

## Comparison to Current Framework

| Aspect              | AGENTS (Handoff)         | planning-with-files        |
| ------------------- | ------------------------ | -------------------------- |
| **Problem solved**  | Cross-session continuity | Within-session goal drift  |
| **When to persist** | At phase boundaries      | Throughout execution       |
| **File location**   | `.github/handoffs/`      | Working directory          |
| **Trigger**         | Explicit handoff button  | Automatic on complex tasks |
| **Goal refresh**    | Re-read handoff file     | Re-read `task_plan.md`     |

## AGENTS Implementation

Instead of new files, AGENTS uses existing mechanisms:

| Manus Pattern        | AGENTS Equivalent                        |
| -------------------- | ---------------------------------------- |
| `task_plan.md`       | Handoff file + todo list                 |
| "Read before decide" | Re-read handoff file periodically        |
| Checkbox updates     | `manage_todo_list` updates               |
| Error logging        | "Handle Mismatches" section in Implement |

**Verdict**: Complementary patterns. Handoff solves session boundaries; Manus principles address within-session coherence. AGENTS adopts the principle without the mandatory infrastructure.

## Related Decisions

- [RDR-005](RDR-005-beads.md) - Beads memory (future consideration for scale)
- [RDR-007](RDR-007-mitsuhiko-agent-stuff.md) - Handoff pattern (adopted)
- [RDR-009](RDR-009-mcp-memory-rejected.md) - MCP memory (rejected)
