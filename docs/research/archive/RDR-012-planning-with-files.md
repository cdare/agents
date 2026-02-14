# RDR-012: Planning-with-Files (Manus Pattern)

| Field      | Value                                            |
| ---------- | ------------------------------------------------ |
| **Source** | https://github.com/OthmanAdi/planning-with-files |
| **Date**   | 2026-01-03                                       |
| **Status** | Partially Adopted                                |

## Summary

3-file approach for persistent working memory during long sessions. Agents re-read plan file before major decisions to combat goal drift.

## Decision

**Adopted:**

- Read-before-decide technique ("Attention Management" in Implement agent)
- Todo list as attention anchor (frequent updates refresh goals)
- Goal drift awareness in prevailing-wisdom.md

**Rejected:**

- Mandatory 3-file infrastructure (too much friction)
- New skill/agent (absorbed into existing guidance)

## Key Insight

Attention manipulation: re-reading plan before major decisions refreshes goals in the attention window, combating "lost in the middle" during long sessions (50+ tool calls).

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Goal drift and context engineering
- [RDR-005](RDR-005-beads.md) — Beads for structured memory at scale
