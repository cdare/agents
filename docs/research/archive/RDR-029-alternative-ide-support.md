# RDR-029: Alternative IDE Support (Cursor, IntelliJ)

| Field      | Value                                                                                                                                                                                                                                                                                                                                                       |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Source** | [Cursor Modes](https://cursor.com/docs/agent/modes), [Cursor Commands](https://cursor.com/docs/context/commands), [IntelliJ Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions?tool=jetbrains), [Custom Instructions Support](https://docs.github.com/en/copilot/reference/custom-instructions-support) |
| **Date**   | 2026-01-26 (Updated 2026-02-12)                                                                                                                                                                                                                                                                                                                             |
| **Status** | Partial (IntelliJ: global instructions only)                                                                                                                                                                                                                                                                                                                |

## Summary

Analysis of AGENTS framework compatibility with Cursor and IntelliJ IDEA. Both IDEs lack the core features our agents rely on: **platform-enforced tool restrictions**, **agent discovery**, and **handoffs**. Global instructions can be installed for IntelliJ; Cursor gets skills only.

## The Core Problem

The AGENTS workflow (Explore → Implement → Review → Commit) depends on VS Code-specific features:

| Feature Required      | VS Code                          | Cursor               | IntelliJ             |
| --------------------- | -------------------------------- | -------------------- | -------------------- |
| Tool restrictions     | `tools:` frontmatter (enforced)  | ❌ Not supported     | ❌ Not supported     |
| Agent discovery       | `chat.agentFilesLocations`       | ❌ Not supported     | ❌ Not supported     |
| Skills auto-activate  | `chat.skillsFilesLocations`      | ✅ `~/.cursor/skills`| ❌ Not supported     |
| Handoff buttons       | In-context actions               | ❌ Not supported     | ❌ Not supported     |
| Global instructions   | `~/.copilot/instructions/`       | ❌ Not supported     | ✅ Supported         |

**Key insight:** Our Explore agent _cannot_ accidentally edit code—VS Code blocks the tools. In Cursor/IntelliJ, "don't edit files" is just a polite request the model can ignore.

---

## Cursor Analysis

### Built-in Modes (not extensible)

| Mode      | Purpose                               | Tool Access              |
| --------- | ------------------------------------- | ------------------------ |
| **Agent** | Full autonomous coding (default)      | All tools                |
| **Ask**   | Read-only exploration, no changes     | Search only              |
| **Plan**  | Creates detailed plans before coding  | All tools                |
| **Debug** | Hypothesis-driven debugging with logs | All tools + debug server |

These are **hardcoded modes**, not user-configurable. Users cannot create custom modes with specific tool restrictions or handoffs.

### Cursor Feature Compatibility

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

### Cursor Subagents

Cursor subagents (`.cursor/agents/`) are **spawned child workers**, not primary workflow modes. This is closer to our subagent fan-out pattern in Explore, not our top-level agent modes.

### Cursor Decision

**Rejected for agents.** Skills work identically and can be installed to `~/.cursor/skills/`.

---

## IntelliJ IDEA Analysis

### IntelliJ Feature Compatibility

| Feature                        | VS Code | IntelliJ | Notes                                                     |
| ------------------------------ | ------- | -------- | --------------------------------------------------------- |
| **Global instructions**        | ✅      | ✅       | `~/.config/github-copilot/intellij/global-copilot-instructions.md` |
| **Repo-wide instructions**     | ✅      | ✅       | `.github/copilot-instructions.md` (auto-detected)         |
| **Path-specific instructions** | ✅      | ✅       | `.github/instructions/**/*.instructions.md`               |
| **AGENTS.md**                  | ✅      | ✅       | Coding Agent only (not Chat)                              |
| **Prompt files**               | ✅      | ✅       | `.github/prompts/*.prompt.md`                             |
| **Custom agent modes**         | ✅      | ❌       | No `chat.agentFilesLocations` equivalent                  |
| **Tool restrictions**          | ✅      | ❌       | No `tools:` frontmatter enforcement                       |
| **Skills (auto-activate)**     | ✅      | ❌       | No `chat.skillsFilesLocations` equivalent                 |

### What Can Be Installed for IntelliJ

| Component            | Count | Installable | Reason                                    |
| -------------------- | ----- | ----------- | ----------------------------------------- |
| **Agents**           | 4     | ❌          | Require tool restrictions + handoffs      |
| **Skills**           | 11    | ❌          | Require skills file location discovery    |
| **Instructions**     | 5     | ✅ (1 only) | Only global instructions have target path |

**Global instructions path:**
- macOS/Linux: `~/.config/github-copilot/intellij/global-copilot-instructions.md`
- Windows: `C:\Users\USERNAME\AppData\Local\github-copilot\intellij\global-copilot-instructions.md`

### IntelliJ Decision

**Partial support.** Install global instructions only. Document limitation clearly.

---

## Decision Summary

| IDE        | Agents | Skills | Instructions | Status                     |
| ---------- | ------ | ------ | ------------ | -------------------------- |
| **VS Code**| ✅     | ✅     | ✅           | Full support               |
| **Cursor** | ❌     | ✅     | ❌           | Skills only                |
| **IntelliJ**| ❌    | ❌     | ✅ (global)  | Global instructions only   |

## What Would Enable Full Adoption

### Cursor
1. User-defined modes with tool restrictions (like VS Code's `tools:` frontmatter)
2. Mode persistence across messages
3. Handoff UI or next-mode suggestions

### IntelliJ
1. Custom agent mode files with tool restrictions
2. Skills file location discovery setting
3. Handoff UI mechanisms

## References

- [Cursor Modes](https://cursor.com/docs/agent/modes) - Built-in Agent/Ask/Plan/Debug
- [Cursor Commands](https://cursor.com/docs/context/commands) - Replacement for deprecated custom modes
- [IntelliJ Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions?tool=jetbrains)
- [Custom Instructions Support Matrix](https://docs.github.com/en/copilot/reference/custom-instructions-support)
- [Agent Skills Standard](https://agentskills.io/) - Skills format specification
