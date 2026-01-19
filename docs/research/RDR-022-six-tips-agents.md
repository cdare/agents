# Research Decision Record: Six New Tips for Agents

| Field        | Value                                                                                  |
| ------------ | -------------------------------------------------------------------------------------- |
| **Source**   | https://steve-yegge.medium.com/six-new-tips-for-better-coding-with-agents-d4e9c86e42a9 |
| **Reviewed** | 2026-01-19                                                                             |
| **Status**   | Partially Adopted                                                                      |

## Summary

Steve Yegge's December 2025 article shares six emerging patterns from advanced agentic coding practice: software as throwaway, agent UX design, code health investment, timing projects for model capability, iterative self-review ("Rule of Five"), and agent swarming with merge queue challenges.

## Key Concepts

| Concept                   | Description                                                                                                                                                     |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Throwaway Software**    | Modern AI-generated code has ~1 year shelf life; regenerating is often easier than refactoring. Rewriting tests from scratch is faster than fixing broken ones. |
| **Agent UX**              | Tools must be designed for AI ergonomics, not just humans. Add flag aliases (e.g., `--body` as alias for `--description`) to match LLM training patterns.       |
| **Code Health 40%**       | Spend 30-40% of time/money on code reviews, smell detection, refactoring. Without this, vibe-coded bases accumulate invisible debt.                             |
| **Timing for Models**     | Some projects are ahead of current model capability. Wait 1-2 model releases (~3 months) for boundary-crossing problems.                                        |
| **Rule of Five**          | Have agents review their work 4-5 times before trusting output. Each review should vary scope (detailed → architectural). Convergence happens around pass 5.    |
| **Swarming & Merge Wall** | Parallel agents dramatically increase velocity, but merging work is the hard problem. Serialize rebases, defer conflicting tasks, expect messy reduction phase. |

## Decision

**Adopted:**

1. **Code Health Guidance** - Add recommendation to tech-debt skill about regular code health passes (30-40% of time)
2. **Rule of Five Principle** - Add iterative review pattern to Review agent (suggest re-review for complex changes)

**Partially Adopted:**

3. **Throwaway Mindset** - Acknowledged in philosophy but not enforced (users decide their code longevity expectations)

**Rejected:**

4. **Agent Swarming** - Out of scope for AGENTS framework. Swarming requires orchestration infrastructure (merge queues, worker pools) that AGENTS doesn't provide. This is a runtime concern, not an instruction concern.
5. **Agent UX Design** - Interesting but not applicable. AGENTS defines instructions, not tools. Tool UX is the domain of IDE vendors (VSCode, Claude Code).
6. **Model Timing** - Too situational for instructions. Users naturally discover this through experience.

**Rationale:**

The article focuses heavily on practices for solo developers running their own agent orchestrators (Beads, swarming). AGENTS is a minimal instruction framework for phase-based human-in-the-loop work. The applicable insights are the code health investment ratio and iterative review pattern, both of which reinforce existing AGENTS principles.

## Comparison to Current Framework

| Yegge Tip              | AGENTS Alignment                                                                                      |
| ---------------------- | ----------------------------------------------------------------------------------------------------- |
| Throwaway software     | Neutral. AGENTS doesn't dictate code longevity expectations.                                          |
| Agent UX               | N/A. AGENTS provides instructions, not tools.                                                         |
| Code health 40%        | **Aligns** with tech-debt skill. Could strengthen guidance on frequency.                              |
| Model timing           | N/A. Outside instruction scope.                                                                       |
| Rule of Five           | **Aligns** with Review agent's re-review handoff. Could suggest multiple review passes explicitly.    |
| Swarming / Merge Wall  | N/A. AGENTS is single-agent focused; swarming requires orchestration infrastructure beyond our scope. |
| Super-engineers (100x) | Implicit. AGENTS aims to make users more effective but doesn't make productivity claims.              |

## Key Quotes

> "Generating almost any code is easier (for AIs) than rewriting it."

> "If you are vibe coding, you need to spend at least 30-40% of your time, queries, and money on code health."

> "It typically takes 4 to 5 iterations before the agent declares that it's as good as it can get... that is the first point at which you can begin to moderately trust the output."

> "Reading code is... pretty much all you do all day [with vibe coding]. It's hard for most developers."

## Changes Made

1. Updated Review agent to suggest re-review for complex changes
2. Added code health frequency guidance to tech-debt skill description
