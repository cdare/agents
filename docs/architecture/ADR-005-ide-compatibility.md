# IDE Compatibility Approach

**Source:** RDR-017, RDR-029 (via ide-compatibility.md), February 2026

## Decision

VS Code is the primary platform with full feature support. Other IDEs (Claude Code, Cursor, IntelliJ) get degraded but functional experiences via compatibility layers.

## Why

- VS Code has unique features (tool restrictions, agent discovery, handoffs)
- Core value is methodology in agent instructions, not UI enforcement
- 80/20 approach: instructions work everywhere, enforcement is platform-specific
- Better to support partially than not at all
- Claude respects instructions even without tool enforcement

## Problem Statement

The AGENTS framework depends on VS Code-specific capabilities:

| Capability           | VS Code Feature                   |
| -------------------- | --------------------------------- |
| Tool restrictions    | `tools:` frontmatter (enforced)   |
| Agent discovery      | `chat.agentFilesLocations`        |
| Workflow transitions | Handoff buttons                   |
| Skills auto-activate | `chat.skillsFilesLocations`       |
| Per-agent models     | `model:` frontmatter              |

How do we support Cursor, Claude Code, and IntelliJ without these features?

## Solution

### Support Matrix

| IDE         | Agents | Skills | Instructions | Enforcement |
| ----------- | ------ | ------ | ------------ | ----------- |
| VS Code     | ✅     | ✅     | ✅           | Hard        |
| Claude Code | ⚠️     | ✅     | ✅           | Soft        |
| Cursor      | ❌     | ✅     | ❌           | None        |
| IntelliJ    | ❌     | ❌     | ✅ (global)  | None        |

### Compatibility Layers

**Claude Code:**
- `install.sh` generates slash commands from agent bodies
- Strip frontmatter, copy body to `~/.claude/commands/<agent>.md`
- Skills symlinked to `~/.claude/skills/`
- Users invoke `/explore`, `/implement`, etc.

**Cursor:**
- Skills only (identical `SKILL.md` format)
- Copy to `~/.cursor/skills/`
- No custom agent support—built-in modes (Agent, Ask, Plan, Debug) are hardcoded
- Slash commands are one-shot, no mode persistence

**IntelliJ:**
- Global instructions only
- Path: `~/.config/github-copilot/intellij/global-copilot-instructions.md`
- No skills or custom agents
- AGENTS.md works for Coding Agent (not Chat)

### Why "Soft" Enforcement is Acceptable

| Feature           | VS Code             | Claude Code                   |
| ----------------- | ------------------- | ----------------------------- |
| Tool restrictions | Tools actually blocked | Respected via instruction     |
| Handoffs          | UI buttons          | Manual command invocation     |
| Model selection   | Per-agent model     | N/A (user's subscription)     |

Claude Code respects "don't edit files" as instruction—the model follows directions even without enforcement. This is "soft" enforcement: it works because the model is cooperative, not because tools are blocked.

### Acceptable Losses by Platform

| Platform    | What's Lost                      | Why Acceptable                     |
| ----------- | -------------------------------- | ---------------------------------- |
| Claude Code | Tool enforcement, handoff UI     | Instructions work, manual commands |
| Cursor      | Agent modes, mode persistence    | Skills still provide specialization|
| IntelliJ    | Agents, skills, handoffs         | Core instructions still apply      |

### Install Script Behavior

```bash
./install.sh

# Creates:
# VS Code:     ~/.copilot/agents/*.agent.md
# Claude Code: ~/.claude/commands/*.md (stripped agents)
# Cursor:      ~/.cursor/skills/*/SKILL.md (symlinked)
# IntelliJ:    ~/.config/github-copilot/intellij/global-copilot-instructions.md
```

## Key Insights

The core value is methodology in each agent's instructions, not tool enforcement or handoff buttons.

Claude Code users get the workflow discipline. Acceptable losses:
- Tool enforcement → Claude respects instructions anyway
- Handoff buttons → User runs next command manually

The 80/20 insight: most value comes from the instructions themselves. Enforcement is nice-to-have, not essential.

## See Also

- [ide-compatibility.md](../../docs/research/ide-compatibility.md) — Detailed platform analysis
- [install.sh](../../install.sh) — Compatibility layer implementation
- [Agent Skills Standard](https://agentskills.io/) — Skills format specification
