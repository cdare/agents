# RDR-022: Six New Tips for Agents

| Field      | Value                                                                                  |
| ---------- | -------------------------------------------------------------------------------------- |
| **Source** | https://steve-yegge.medium.com/six-new-tips-for-better-coding-with-agents-d4e9c86e42a9 |
| **Date**   | 2026-01-19                                                                             |
| **Status** | Partially Adopted                                                                      |

## Summary

Steve Yegge's six patterns: throwaway software, agent UX, code health 30-40%, model timing, "Rule of Five" reviews, and agent swarming.

## Decision

**Adopted:**

- **Code Health 30-40%** — Spend 30-40% of time on reviews, smell detection, refactoring
- **Rule of Five** — Review work 4-5 times before trusting output; convergence happens around pass 5

**Rejected:**

- Agent swarming (requires orchestration infrastructure outside AGENTS scope)
- Agent UX design (AGENTS defines instructions, not tools)
- Model timing (too situational)

## Key Insight

Without 30-40% code health investment, vibe-coded bases accumulate invisible debt. Iterative review (4-5 passes) is when agent output becomes trustworthy.

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Code health and review patterns
