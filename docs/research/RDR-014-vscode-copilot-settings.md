# Research Decision Record: VSCode Copilot Settings

| Field        | Value                                            |
| ------------ | ------------------------------------------------ |
| **Source**   | https://code.visualstudio.com/docs/copilot/setup |
| **Reviewed** | 2026-01-04 (Updated 2026-01-09 for v1.108)       |
| **Status**   | Partially Adopted                                |

## Summary

Comprehensive review of VSCode Copilot settings for optimal agent performance. The documentation reveals ~50+ configurable settings across agent behavior, terminal auto-approval, context management, and custom instructions. Key finding: VSCode natively supports AGENTS.md files and has adopted the agentskills.io standard for skills.

## Key Concepts

| Concept                       | Description                                              |
| ----------------------------- | -------------------------------------------------------- |
| `chat.agent.maxRequests`      | Default 25 tool calls; can increase for complex tasks    |
| `chat.useAgentsMdFile`        | Native support for AGENTS.md (enabled by default)        |
| `chat.useAgentSkills`         | Experimental support for skills in SKILL.md format       |
| Terminal auto-approval        | Configurable allowlist/blocklist for command safety      |
| Conversation summarization    | Auto-compacts context when window is full                |
| `chat.useNestedAgentsMdFiles` | Support AGENTS.md in workspace subfolders (experimental) |

## Decision

**Adopted:**

- Document recommended VSCode settings in README or a new doc
- Recommend enabling `chat.useNestedAgentsMdFiles` for monorepos
- Note agentskills.io alignment validates AGENTS skill format

**Not Adopted:**

- No changes to skill format (already aligned with standard)
- No changes to agent definitions (already compatible)

**Rationale:** AGENTS is already aligned with VSCode Copilot's native capabilities. The main value is documenting optimal settings for users to maximize effectiveness. The agentskills.io standard adoption by VSCode validates our skill format design.

## Recommended Settings

For optimal AGENTS framework performance in VSCode:

```json
{
  // Agent mode
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 50, // Increase from default 25 for complex tasks

  // AGENTS.md integration
  "chat.useAgentsMdFile": true, // Default: true
  "chat.useNestedAgentsMdFiles": true, // Recommended for monorepos

  // Skills support (experimental, enable if using skills)
  "chat.useAgentSkills": true, // Default: false

  // Context management
  "github.copilot.chat.summarizeAgentConversationHistory.enabled": true,
  "github.copilot.chat.edits.suggestRelatedFilesFromGitHistory": true,

  // Terminal safety (align with AGENTS permission philosophy)
  "chat.tools.terminal.enableAutoApprove": true,
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",

  // Auto-fix issues in generated code
  "github.copilot.chat.agent.autoFix": true
}
```

### Additional Useful Settings

```json
{
  // Custom instructions location (default)
  "chat.instructionsFilesLocations": {
    ".github/instructions": true
  },

  // Prompt files location (default)
  "chat.promptFilesLocations": {
    ".github/prompts": true
  },

  // Code generation instructions
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}
```

## Comparison to Current Framework

- **AGENTS.md**: VSCode natively reads this file (setting enabled by default) ✅
- **Skills**: The agentskills.io standard matches AGENTS' SKILL.md format ✅
- **Agents**: Custom agent definitions in `.github/agents/` are fully supported ✅
- **Instructions**: VSCode looks in `.github/instructions/` by default ✅

**Conclusion:** AGENTS is fully compatible with VSCode Copilot's native architecture. The framework's design choices (file locations, SKILL.md format, AGENTS.md convention) align perfectly with VSCode's built-in capabilities.

## Agentskills.io Standard

The research uncovered that VSCode has adopted the [agentskills.io](https://agentskills.io/) open standard for agent skills, originally developed by Anthropic. This standard is now supported by:

- VS Code
- GitHub Copilot
- Claude Code
- Cursor
- OpenCode
- Amp
- Letta
- Goose

AGENTS' skill format (`.github/skills/*/SKILL.md`) matches this standard, validating the framework's approach. The standard enables skills to be portable across different AI agent tools.

## Implementation Note

The recommended settings should be documented in one of:

1. A new "Recommended Settings" section in README.md
2. A new `.vscode/settings.json.example` file in the repo
3. A dedicated docs/vscode-settings.md document

This will help users optimize their VSCode configuration for AGENTS usage.

## VSCode 1.108 Update (January 2026)

### Agent Skills Now Official

The `chat.useAgentSkills` setting is now officially documented as experimental. Skills use 3-level progressive loading:

1. **Discovery** (~100 tokens): Only `name` and `description` from YAML frontmatter
2. **Instructions** (<5000 tokens): Full SKILL.md body when skill activates
3. **Resources** (as needed): Scripts/examples only when referenced

### Updated Personal Skills Locations

VSCode 1.108 reveals the complete skill discovery order:

| Location            | Type     | Notes                        |
| ------------------- | -------- | ---------------------------- |
| `.github/skills`    | Project  | Primary workspace location   |
| `~/.copilot/skills` | Personal | **New primary** for personal |
| `.claude/skills`    | Project  | Legacy, backward compatible  |
| `~/.claude/skills`  | Personal | Legacy, backward compatible  |

**Action taken**: Updated `install.sh` to use `~/.copilot/skills` as primary personal skills location (was `~/.github/skills`).

### Skills vs Agents (Clarification)

Skills and agents are orthogonal—skills load into any active agent context:

| Concept   | Selection | Purpose                              |
| --------- | --------- | ------------------------------------ |
| **Agent** | Explicit  | Defines tools, permissions, workflow |
| **Skill** | Automatic | Adds domain knowledge to context     |

No slash commands for skills—activation is automatic via description matching.

### Terminal Auto-Approve Updates

New default safe commands when `chat.tools.terminal.enableAutoApprove` is enabled:

- `git ls-files`, `git --no-pager <safe_subcommand>`
- `rg` (excluding `--pre` and `--hostname-bin`)
- `sed` (with restrictions)
- Workspace npm scripts via `npm`, `pnpm`, `yarn` (new: `chat.tools.terminal.autoApproveWorkspaceNpmScripts`)
