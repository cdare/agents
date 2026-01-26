# RDR-027: Skill-Powered Subagents

| Field      | Value           |
| ---------- | --------------- |
| **Source** | Internal design |
| **Date**   | 2026-01-26      |
| **Status** | Adopted ⭐      |

## Summary

Agents can invoke skills via subagents by including skill trigger keywords in the subagent prompt. This combines skill expertise with context isolation—the subagent operates in skill mode, and only its summary returns to the main agent.

## Decision

**Adopted:**

- Add "Skill-Powered Subagents" section to `prevailing-wisdom.md`
- Document agent → skill pairings with invocation patterns
- Update agent docs to reference this pattern when applicable

**Why subagent + skill > inline skill activation:**

| Factor         | Inline Skill                      | Subagent + Skill                   |
| -------------- | --------------------------------- | ---------------------------------- |
| Context impact | All findings stay in main context | Subagent context garbage-collected |
| Focus          | Mixed with other agent concerns   | Pure skill mode operation          |
| Output         | Full reasoning visible            | Summary only returned              |
| Control        | Auto-triggered by keywords        | Agent decides when to invoke       |

**Agent → Skill Pairings:**

| Agent     | Skill        | Trigger Scenario                    |
| --------- | ------------ | ----------------------------------- |
| Explore   | architecture | Understanding system structure      |
| Implement | debug        | Tests failing during implementation |
| Review    | critic       | Stress-testing implementation       |
| Review    | tech-debt    | Code quality scanning               |

## Key Insight

Subagents act as "skill invokers"—by crafting prompts with skill trigger keywords, agents get specialized behavior without bloating their own context. The skill's progressive loading (discovery → instructions → resources) happens in the subagent's isolated context.

## See Also

- [RDR-010](RDR-010-subagents-context-fork.md) — Subagents fork context, return only summary
- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Section 8: Skill-Powered Subagents
