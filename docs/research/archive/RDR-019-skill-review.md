# RDR-019: Skill Review

| Field      | Value             |
| ---------- | ----------------- |
| **Source** | Internal review   |
| **Date**   | 2026-01-09        |
| **Status** | Partially Adopted |

## Summary

Systematic review of 6 existing skills against quality criteria from Superpowers and prevailing wisdom. Resulted in merging `janitor` into `tech-debt` and polishing `architecture`.

## Decision

**Skill Verdicts:**

| Skill          | Verdict   | Rationale                                      |
| -------------- | --------- | ---------------------------------------------- |
| `debug`        | ✅ Keep   | Strong: hypothesis-driven investigation        |
| `mentor`       | ✅ Keep   | Strong: Socratic questions-only mode           |
| `critic`       | ✅ Keep   | Strong: adversarial probing, no solutions      |
| `architecture` | ⚠️ Polish | Strengthen scope constraint, add anti-patterns |
| `tech-debt`    | ⚠️ Expand | Absorb janitor's deletion philosophy           |
| `janitor`      | 🔴 Remove | 80% overlap with tech-debt                     |

**Actions Taken:**

- Merged janitor into tech-debt (added deletion philosophy, safe deletion patterns)
- Polished architecture (strengthened "interfaces in, interfaces out" constraint)
- Skills reduced from 6 → 5

## Key Insight

Future skills should pass the overlap test before creation. Strong skills have distinct behavioral constraints that change how agents work, not just format guidance.

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Skill evaluation checklist (6 criteria)
- [RDR-004](RDR-004-superpowers.md) — Source of TDD skill testing methodology
