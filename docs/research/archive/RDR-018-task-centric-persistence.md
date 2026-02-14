# RDR-018: Task-Centric Persistence

| Field      | Value                                              |
| ---------- | -------------------------------------------------- |
| **Source** | [PR #2](https://github.com/mcouthon/agents/pull/2) |
| **Date**   | 2026-01-09                                         |
| **Status** | Adopted                                            |

> **Superseded by [ADR-002](../../architecture/ADR-002-task-centric-persistence.md)**

## Summary

Research persisted to `.tasks/[task-slug]/` directories with descriptive filenames. Explore has scoped write access (only to `.tasks/`), not to codebase.

## Decision

**Adopted:**

- `.tasks/` directory structure for research persistence
- Descriptive filenames (`auth_flow.md` not timestamps)
- "Continue working on X" pattern for task continuity
- Scoped write access for Explore (`.tasks/` only)

**Removed:**

- Optional step structure (over-engineering)
- Review write access (Review reports, doesn't persist)
- Handoff agent (redundant—Explore handles persistence)

## Key Insight

Explore can write to `.tasks/` without compromising safety. The philosophy exception: write to task files ≠ write to codebase.

## See Also

- [memory-and-continuity.md](../synthesis/memory-and-continuity.md) — Full memory strategy
- [RDR-005](RDR-005-beads.md) — Beads for multi-session memory (future)
