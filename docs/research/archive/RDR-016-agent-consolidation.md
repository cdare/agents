# RDR-016: Agent Consolidation (Research + Plan → Explore)

| Field      | Value                               |
| ---------- | ----------------------------------- |
| **Source** | Internal analysis / user experience |
| **Date**   | 2026-01-04                          |
| **Status** | Adopted                             |

> **Superseded by [ADR-003](../../architecture/ADR-003-agent-consolidation.md)**

## Summary

Merged Research and Plan agents into Explore. Simplified workflow from 6 agents to 5.

## Decision

**Adopted:**

- Retire `research.agent.md` and `plan.agent.md`
- Enhance `explore.agent.md` with features from both
- Unify output format for deterministic handoffs
- Agents: Explore → Implement → Review → Commit

**Rationale:**

- Users preferred unified workflow
- One agent for understanding + planning = simpler mental model
- Handoff determinism: single source format
- No lost functionality

## Key Insight

Previously rejected this consolidation ("separation enforces different cognitive modes"). Reversed because Explore's phased steps preserve cognitive modes, and practical experience showed users prefer the unified workflow.

## See Also

- [memory-and-continuity.md](../synthesis/memory-and-continuity.md) — Updated workflow diagram
