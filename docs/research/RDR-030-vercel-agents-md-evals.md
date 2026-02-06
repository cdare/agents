# RDR-030: Vercel AGENTS.md Eval Study

| Field      | Value                                                                                                                   |
| ---------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Source** | [vercel.com/blog/agents-md-outperforms-skills](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) |
| **Date**   | 2026-02-06                                                                                                              |
| **Status** | Partially Adopted                                                                                                       |

## Summary

Vercel ran evals testing skills vs AGENTS.md for teaching Next.js 16 APIs. AGENTS.md (8KB compressed docs index) achieved 100% pass rate; skills hit 53% without prompting, 79% with explicit instructions.

## Decision

**Adopted:**

- "Retrieval over recall" principle added to prevailing-wisdom.md
- Horizontal (AGENTS.md) vs vertical (skills) distinction documented
- Validation of explicit-trigger skill design

**Rejected:**

- Docs index compression pattern (out of scope—we don't ship framework docs)
- `npx` codemod tooling (Next.js-specific)

## Key Insight

Skills fail when agent-decided (56% never invoked). Passive context beats active retrieval because there's no decision point. Our explicit-trigger design ("use debug mode") sidesteps this entirely.

| Configuration                 | Pass Rate |
| ----------------------------- | --------- |
| Baseline (no docs)            | 53%       |
| Skill (default)               | 53%       |
| Skill + explicit instructions | 79%       |
| AGENTS.md docs index          | 100%      |

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) - Retrieval Over Recall section
- [RDR-028-skills-sh.md](RDR-028-skills-sh.md) - Earlier skills ecosystem review
