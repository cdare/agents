# Research Decision Record: Agent Consolidation (Research + Plan → Explore)

| Field        | Value                               |
| ------------ | ----------------------------------- |
| **Source**   | Internal analysis / user experience |
| **Reviewed** | 2026-01-04                          |
| **Status**   | Adopted                             |

## Summary

Consolidate Research and Plan agents into a single Explore agent. This simplifies the workflow from 6 agents to 5, reduces handoff complexity, and enables deterministic handoff file generation by having a single consistent output format.

## Key Concepts

| Concept                     | Description                                                                         |
| --------------------------- | ----------------------------------------------------------------------------------- |
| **Agent Consolidation**     | Merging Research + Plan into Explore while preserving all unique features           |
| **Format Unification**      | Making Explore output format identical to Handoff format for deterministic handoffs |
| **Workflow Simplification** | Explore → Implement → Review → Commit (plus Handoff for persistence)                |

## Decision

**Adopted:**

1. Retire `research.agent.md` and `plan.agent.md`
2. Enhance `explore.agent.md` with missing features from both agents
3. Simplify `handoff.agent.md` to only handle Explore output
4. Unify output format: Explore outputs in handoff-ready format
5. Handoff agent copies content verbatim, adding only YAML frontmatter

**Rationale:**

1. **User experience**: The Explore agent is more frequently used because it combines both capabilities
2. **Simpler mental model**: One agent for understanding + planning, not two
3. **Deterministic handoffs**: Single source format eliminates transformation variance
4. **Reduced maintenance**: Fewer agents to keep in sync
5. **No lost functionality**: All Research/Plan features are preserved in Explore

## Features Migrated to Explore

From Research agent:

- "DOCUMENT AND EXPLAIN ONLY" critical section (for research phase)
- Tests table in research output format
- Explicit follow-up handling

From Plan agent:

- Step Sizing guidance
- Dependencies/Scope Management guidance
- Project Maturity Level in testing strategy
- "No Open Questions in Final Plan" requirement

## Comparison to Previous Decision

Previously (in RESEARCH.md) the decision to "Combine Research + Plan agents" was **Rejected** with rationale:

> "Separation enforces read-only research and different cognitive modes"

This decision is now **Reversed** because:

1. Explore agent already has the same read-only tool restrictions as Research/Plan
2. The "different cognitive modes" are preserved within Explore's phased steps
3. Practical experience shows users prefer the unified workflow
4. Handoff determinism benefits outweigh the theoretical separation benefits

## Files Modified

| File                                      | Change                     |
| ----------------------------------------- | -------------------------- |
| `.github/agents/explore.agent.md`         | Enhanced with all features |
| `.github/agents/handoff.agent.md`         | Simplified, format unified |
| `.github/agents/review.agent.md`          | Re-Plan → Re-Explore       |
| `README.md`                               | Updated workflow, counts   |
| `AGENTS.md`                               | Updated agent list         |
| `RESEARCH.md`                             | Updated decision status    |
| `docs/synthesis/prevailing-wisdom.md`     | Updated phase references   |
| `docs/synthesis/memory-and-continuity.md` | Updated workflow diagram   |
| `tests/scenarios/skill-activation.md`     | Updated agent tables       |
| `.github/ISSUE_TEMPLATE/share_agent.md`   | Updated example workflow   |

## Files Deleted

- `.github/agents/research.agent.md`
- `.github/agents/plan.agent.md`
