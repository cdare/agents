# Research Decision Record: Code Protection Markers Removal

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| **Source**   | CursorRIPER framework (internal evaluation) |
| **Reviewed** | 2026-01-02                                  |
| **Status**   | Removed                                     |

## Summary

Code protection markers (`[P]`, `[G]`, `[D]`) were adopted from CursorRIPER as advisory conventions for marking protected, guarded, and debug code. After usage evaluation, these markers are being removed from the framework as they add documentation overhead without providing measurable value.

## Key Concepts

| Concept         | Description                                         |
| --------------- | --------------------------------------------------- |
| `[P]` Protected | Code that should never be modified without approval |
| `[G]` Guarded   | Code requiring human review before changes          |
| `[D]` Debug     | Temporary code to be removed before merge           |

## Decision

**Removed:** All references to code protection markers

**Rationale:**

1. **No actual usage** - Zero code files in the framework contain these markers
2. **Advisory only** - Markers have no programmatic enforcement
3. **Cognitive overhead** - Documentation burden without commensurate benefit
4. **Better alternatives exist**:
   - Git branch protection for critical code
   - Code review requirements in PRs
   - Linter rules for debug code detection
   - Comments explaining sensitive code sections

## What Was Removed

- Section in `instructions/global.instructions.md`
- Section in `AGENTS.md`
- Section in `README.md`
- References in `.github/agents/implement.agent.md`
- Attribution in README Further Reading section

## Comparison to Current Framework

CursorRIPER's protection markers made more sense in its context (complex permission system with programmatic enforcement). Our simplified framework relies on agent modes with enforced tool restrictions, making comment-based protection markers redundant.
