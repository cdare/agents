# IDE Compatibility Approach

**Source:** RDR-017, RDR-029 (via ide-compatibility.md), February 2026
**Amended:** February 20, 2026 — Template-based generation (task 017)

## Decision

Templates are the single source of truth. Both VS Code Copilot and Claude Code
get first-class generated output from `templates/`. Other IDEs (Cursor, IntelliJ)
get degraded but functional experiences via compatibility layers.

**Previous decision (Feb 2026):** VS Code was primary; CC got "soft enforcement"
via stripped slash commands. This was superseded when CC gained full subagent support
(tools, disallowedTools, model, skills, permissionMode).

## Why

- Both VS Code and Claude Code now support tool restrictions, model selection, and skills
- Templates ensure both platforms stay in sync — no manual duplication
- 80/20 approach still applies to Cursor/IntelliJ: instructions work everywhere, enforcement is platform-specific
- Better to support partially than not at all

## Problem Statement

The AGENTS framework depends on VS Code-specific capabilities:

| Capability           | VS Code Feature                 |
| -------------------- | ------------------------------- |
| Tool restrictions    | `tools:` frontmatter (enforced) |
| Agent discovery      | `chat.agentFilesLocations`      |
| Workflow transitions | Handoff buttons                 |
| Skills auto-activate | `chat.skillsFilesLocations`     |
| Per-agent models     | `model:` frontmatter            |

How do we support Cursor, Claude Code, and IntelliJ without these features?

## Solution

### Support Matrix

| IDE         | Agents | Skills | Instructions | Enforcement |
| ----------- | ------ | ------ | ------------ | ----------- |
| VS Code     | ✅     | ✅     | ✅           | Hard        |
| Claude Code | ✅     | ✅     | ✅           | Hard        |
| Cursor      | ❌     | ✅     | ❌           | None        |
| IntelliJ    | ❌     | ❌     | ✅ (global)  | None        |

### Compatibility Layers

**Claude Code:**

- `make cc` generates native CC subagents from `templates/agents/`
- CC subagents have full frontmatter: `tools`, `disallowedTools`, `model`, `skills`
- Skills generated from `templates/skills/` with CC-specific frontmatter (`allowed-tools`, `context`)
- Rules generated from `templates/instructions/` with `paths:` scoping
- `install.sh` symlinks generated `.claude/` files to `~/.claude/`
- Users invoke agents via subagent syntax in Claude Code

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

### Why Template-Based Generation

| Aspect           | Old (Feb 2026)                       | New (template-based)                 |
| ---------------- | ------------------------------------ | ------------------------------------ |
| Source of truth  | Copilot files (.github/)             | Templates (templates/)               |
| CC generation    | Strip frontmatter from Copilot       | Generate from templates              |
| CC enforcement   | Soft (instructions only)             | Hard (tools/disallowedTools)         |
| CC agent format  | Slash commands (~/.claude/commands/) | Native subagents (~/.claude/agents/) |
| Build system     | install.sh does everything           | make generates, install.sh symlinks  |

### Acceptable Losses by Platform

| Platform    | What's Lost           | Why Acceptable                        |
| ----------- | --------------------- | ------------------------------------- |
| Claude Code | Handoff UI buttons    | Instructions guide next steps         |
| Cursor      | Agent modes, persistence | Skills still provide specialization |
| IntelliJ    | Agents, skills, handoffs | Core instructions still apply       |

### Build and Install

```bash
make              # Generate .github/ and .claude/ from templates/
./install.sh      # Symlink to ~/.copilot/ and ~/.claude/

# Creates:
# VS Code:     ~/.copilot/agents/*.agent.md (symlinks)
# Claude Code: ~/.claude/agents/*.md (symlinks)
# Cursor:      (skills via ~/.copilot/skills/ symlinks)
# IntelliJ:    ~/.config/github-copilot/intellij/ (symlink)
```

## Key Insights

The core value is methodology in each agent's instructions. Template-based generation ensures both VS Code and Claude Code get first-class, in-sync implementations.

Clause Code users get the same tool restrictions and model selection as VS Code. Only remaining acceptable loss:

- Handoff buttons → Instructions guide next steps; user invokes next agent manually

The 80/20 insight still applies to Cursor/IntelliJ: most value comes from the instructions themselves. Enforcement is nice-to-have for those platforms, not essential.

## See Also

- [ide-compatibility.md](../synthesis/ide-compatibility.md) — Detailed platform analysis
- [install.sh](../../install.sh) — Compatibility layer implementation
- [Agent Skills Standard](https://agentskills.io/) — Skills format specification
