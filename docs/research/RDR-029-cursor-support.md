# RDR-029: Cursor Skills and Agents Support

| Field      | Value                                                                                                                                                                                                                                                                  |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Source** | [Cursor 2.4 Changelog](https://cursor.com/changelog/2-4), [Skills](https://cursor.com/docs/context/skills), [Subagents](https://cursor.com/docs/context/subagents), [Modes](https://cursor.com/docs/agent/modes), [Commands](https://cursor.com/docs/context/commands) |
| **Date**   | 2026-01-26                                                                                                                                                                                                                                                             |
| **Status** | Rejected                                                                                                                                                                                                                                                               |

## Summary

Deep dive into Cursor's agent architecture. While skills use the same SKILL.md format, Cursor lacks the core features our agents rely on: **platform-enforced tool restrictions** and **handoffs**. Custom modes were deprecated in 2.1; their replacement (slash commands) only offers instruction-based guidance that models can ignore.

## Key Findings

### Cursor's Built-in Modes (not extensible)

| Mode      | Purpose                               | Tool Access              |
| --------- | ------------------------------------- | ------------------------ |
| **Agent** | Full autonomous coding (default)      | All tools                |
| **Ask**   | Read-only exploration, no changes     | Search only              |
| **Plan**  | Creates detailed plans before coding  | All tools                |
| **Debug** | Hypothesis-driven debugging with logs | All tools + debug server |

These are **hardcoded modes**, not user-configurable. Users cannot create custom modes with specific tool restrictions or handoffs.

### What Cursor Offers vs What We Need

| Our Feature           | Cursor Equivalent             | Compatible?              |
| --------------------- | ----------------------------- | ------------------------ |
| **Skills (SKILL.md)** | `~/.cursor/skills/`           | ✅ Identical format      |
| **Agent modes**       | Built-in modes only (4 fixed) | ❌ Not extensible        |
| **Custom modes**      | Deprecated → slash commands   | ❌ Soft enforcement      |
| **Tool restrictions** | Instructions in commands only | ❌ Not enforced          |
| **Handoffs**          | Not supported                 | ❌                       |
| **Mode persistence**  | N/A                           | ❌ Commands are one-shot |

### Why Rules + Commands Can't Simulate Agents

Considered: using `.cursor/rules/` for workflow discipline + `.cursor/commands/` for agent prompts.

| Feature           | Simulation Approach          | Why It Fails                                                 |
| ----------------- | ---------------------------- | ------------------------------------------------------------ |
| Tool restrictions | "Don't edit files" in prompt | Model can still call edit tools—instruction, not enforcement |
| Mode persistence  | N/A                          | Commands are one-shot; next message loses mode context       |
| Handoffs          | N/A                          | No UI mechanism; user must manually invoke next command      |
| Model selection   | N/A                          | Can't specify Opus for Explore, Sonnet for Implement         |

**The core problem:** Our Explore agent _cannot_ accidentally edit code—the platform blocks the tools. A Cursor `/explore` command would just be a polite request not to edit, which models may override under pressure.

### Subagents: Different Architecture

Cursor subagents (`.cursor/agents/`) are **spawned child workers**, not primary workflow modes. This is closer to our subagent fan-out pattern in Explore, not our top-level agent modes.

## Decision

**Rejected.** Cursor lacks platform-enforced tool restrictions and mode persistence. The methodology (prompts) would transfer, but the guardrails that make the workflow reliable would not.

**Future:** If Cursor adds custom modes with tool allowlists, revisit.

## What Would Enable Adoption

1. User-defined modes with tool restrictions (like VS Code's `tools:` frontmatter)
2. Mode persistence across messages
3. Handoff UI or next-mode suggestions

## References

- [Cursor Modes](https://cursor.com/docs/agent/modes) - Built-in Agent/Ask/Plan/Debug
- [Cursor Commands](https://cursor.com/docs/context/commands) - Replacement for deprecated custom modes
- [Agent Skills Standard](https://agentskills.io/) - Skills are compatible, but not sufficient alone
