# RDR-004: Superpowers

| Field      | Value                               |
| ---------- | ----------------------------------- |
| **Source** | https://github.com/obra/superpowers |
| **Date**   | 2025-12-29                          |
| **Status** | Partially Adopted                   |

## Summary

Skills-based workflow framework for AI agents with TDD-inspired skill creation methodology. Skills are tested using "pressure scenarios" before deployment.

## Decision

**Adopted:**

- TDD-based skill testing (validate skills with test scenarios)
- Rich skill descriptions with trigger keywords for discovery
- Progressive disclosure (<500 lines for main skill file)
- Skill namespace (personal skills override framework skills)

**Rejected:**

- Mandatory workflow enforcement (too prescriptive for advisory philosophy)
- Emphatic/forceful tone ("YOU MUST")
- Command system (`/superpowers:brainstorm`)—we use agent modes
- Subagent-driven development (platform-specific)

## Key Insight

Skills should be TDD-tested: watch agent fail without skill (RED), write skill (GREEN), close loopholes (REFACTOR). This is unit testing for documentation.

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Skill evaluation checklist
- [RDR-019](RDR-019-skill-review.md) — Applied these criteria to review existing skills
