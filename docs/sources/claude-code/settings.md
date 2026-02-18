# Claude Code Settings

Source: https://code.claude.com/docs/en/settings (fetched 2026-02-17)

## Configuration Scopes

| Scope   | Location                                   | Shared               | Precedence |
| ------- | ------------------------------------------ | -------------------- | ---------- |
| Managed | `/Library/Application Support/ClaudeCode/` | Yes (deployed by IT) | Highest    |
| User    | `~/.claude/settings.json`                  | No                   | 3rd        |
| Project | `.claude/settings.json`                    | Yes (via VCS)        | 4th        |
| Local   | `.claude/settings.local.json`              | No (gitignored)      | 5th        |

Higher precedence overrides lower.

## Settings Files

### settings.json Structure

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "Read(./secrets/**)"]
  },
  "model": "claude-sonnet-4-5-20250929",
  "env": {
    "FOO": "bar"
  },
  "hooks": {}
}
```

### Key Settings

| Setting           | Description                  | Example                        |
| ----------------- | ---------------------------- | ------------------------------ |
| `model`           | Default model                | `"claude-sonnet-4-5-20250929"` |
| `availableModels` | Restrict model selection     | `["sonnet", "haiku"]`          |
| `permissions`     | Permission rules (see below) | `{}`                           |
| `hooks`           | Lifecycle hooks              | `{}`                           |
| `env`             | Environment variables        | `{"KEY": "value"}`             |
| `plansDirectory`  | Where plan files are stored  | `"./plans"`                    |
| `language`        | Response language            | `"japanese"`                   |

## Permission Rules

Format: `Tool` or `Tool(specifier)`

### Permission Arrays

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Read"],
    "ask": ["Bash(git push *)"],
    "deny": ["WebFetch", "Read(./.env)"]
  }
}
```

- `deny` rules evaluated first
- Then `ask` rules
- Then `allow` rules
- First match wins

### Tool-Specific Patterns

| Tool       | Pattern        | Example                        |
| ---------- | -------------- | ------------------------------ |
| `Bash`     | Command prefix | `Bash(npm run *)`              |
| `Read`     | File path      | `Read(./.env)`                 |
| `Edit`     | File path      | `Edit(./config/*)`             |
| `Write`    | File path      | `Write(./output/**)`           |
| `WebFetch` | Domain         | `WebFetch(domain:example.com)` |
| `Task`     | Agent name     | `Task(code-reviewer)`          |

### Wildcards

- `*` matches anything in current segment
- `**` matches across directory boundaries
- Space before `*` is important: `Bash(git diff *)` vs `Bash(git diff*)`

## Tools Available to Claude

| Tool              | Description               | Requires Permission |
| ----------------- | ------------------------- | ------------------- |
| `Read`            | Read file contents        | No                  |
| `Write`           | Create or overwrite files | Yes                 |
| `Edit`            | Make targeted file edits  | Yes                 |
| `Bash`            | Execute shell commands    | Yes                 |
| `Grep`            | Search patterns in files  | No                  |
| `Glob`            | Find files by pattern     | No                  |
| `WebFetch`        | Fetch URL content         | Yes                 |
| `WebSearch`       | Perform web searches      | Yes                 |
| `Task`            | Spawn subagents           | No                  |
| `AskUserQuestion` | Ask user questions        | No                  |
| `Skill`           | Execute a skill           | Yes                 |
| `TaskCreate`      | Create task               | No                  |
| `TaskList`        | List tasks                | No                  |
| `TaskGet`         | Get task details          | No                  |
| `TaskUpdate`      | Update task               | No                  |
| `LSP`             | Code intelligence         | No                  |
| `NotebookEdit`    | Edit Jupyter notebooks    | Yes                 |
| `ExitPlanMode`    | Prompt to exit plan mode  | Yes                 |

## Subagent Configuration

Subagents stored in:

- User: `~/.claude/agents/`
- Project: `.claude/agents/`

See sub-agents.md for format.

## Plugin Configuration

```json
{
  "enabledPlugins": {
    "formatter@team-tools": true,
    "deployment-tools@team-tools": true
  },
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    }
  }
}
```

## Environment Variables

Key environment variables:

| Variable                               | Description            |
| -------------------------------------- | ---------------------- |
| `ANTHROPIC_API_KEY`                    | API key for SDK usage  |
| `ANTHROPIC_MODEL`                      | Override default model |
| `CLAUDE_CODE_USE_BEDROCK`              | Use AWS Bedrock        |
| `CLAUDE_CODE_USE_VERTEX`               | Use Google Vertex      |
| `CLAUDE_CODE_SUBAGENT_MODEL`           | Model for subagents    |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY`      | Disable auto memory    |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enable agent teams     |
| `MAX_THINKING_TOKENS`                  | Thinking token budget  |

## Sandbox Settings

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"],
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "allowLocalBinding": true
    }
  }
}
```

## Attribution Settings

```json
{
  "attribution": {
    "commit": "🤖 Generated with Claude Code\n\nCo-Authored-By: Claude <noreply@anthropic.com>",
    "pr": "🤖 Generated with Claude Code"
  }
}
```
