# Claude Code Plugins Reference

Source: https://code.claude.com/docs/en/plugins-reference (fetched 2026-02-17)

## Plugin Directory Structure

```
my-plugin/
├── .claude-plugin/           # Metadata directory
│   └── plugin.json           # Plugin manifest
├── commands/                 # Default command location
│   ├── status.md
│   └── logs.md
├── agents/                   # Default agent location
│   ├── security-reviewer.md
│   └── performance-tester.md
├── skills/                   # Skill directories
│   ├── code-reviewer/
│   │   └── SKILL.md
│   └── pdf-processor/
│       ├── SKILL.md
│       └── scripts/
├── hooks/                    # Hook configurations
│   └── hooks.json
├── .mcp.json                 # MCP server definitions
├── .lsp.json                 # LSP server configurations
└── scripts/                  # Hook and utility scripts
    └── format-code.sh
```

## Plugin Manifest (plugin.json)

```json
{
  "name": "plugin-name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./custom/commands/special.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "lspServers": "./.lsp.json"
}
```

### Required Fields

Only `name` is required if you include a manifest.

| Field  | Type   | Description                    |
| ------ | ------ | ------------------------------ |
| `name` | string | Unique identifier (kebab-case) |

### Metadata Fields

| Field         | Type   | Description        |
| ------------- | ------ | ------------------ |
| `version`     | string | Semantic version   |
| `description` | string | Brief explanation  |
| `author`      | object | Author info        |
| `homepage`    | string | Documentation URL  |
| `repository`  | string | Source code URL    |
| `license`     | string | License identifier |
| `keywords`    | array  | Discovery tags     |

### Component Path Fields

| Field        | Type                | Description                  |
| ------------ | ------------------- | ---------------------------- |
| `commands`   | string/array        | Additional command files     |
| `agents`     | string/array        | Additional agent files       |
| `skills`     | string/array        | Additional skill directories |
| `hooks`      | string/array/object | Hook config paths or inline  |
| `mcpServers` | string/array/object | MCP config paths or inline   |
| `lspServers` | string/array/object | LSP configurations           |

## Plugin Components

### Skills

Location: `skills/` directory
Format: Directories with `SKILL.md`

```
skills/
├── pdf-processor/
│   ├── SKILL.md
│   └── scripts/
└── code-reviewer/
    └── SKILL.md
```

### Agents

Location: `agents/` directory
Format: Markdown files with YAML frontmatter

```yaml
---
name: agent-name
description: What this agent does
---
Detailed system prompt...
```

### Hooks

Location: `hooks/hooks.json`
Format: JSON with event matchers

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

### MCP Servers

Location: `.mcp.json`
Format: Standard MCP configuration

```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"]
    }
  }
}
```

## Installation Scopes

| Scope   | Location                      | Shared |
| ------- | ----------------------------- | ------ |
| user    | `~/.claude/settings.json`     | No     |
| project | `.claude/settings.json`       | Yes    |
| local   | `.claude/settings.local.json` | No     |
| managed | `managed-settings.json`       | Yes    |

## CLI Commands

```bash
# Install plugin
claude plugin install <plugin> [--scope user|project|local]

# Uninstall plugin
claude plugin uninstall <plugin>

# Enable/disable plugin
claude plugin enable <plugin>
claude plugin disable <plugin>

# Update plugin
claude plugin update <plugin>
```

## Environment Variables

`${CLAUDE_PLUGIN_ROOT}` - Absolute path to plugin directory. Use in hooks, MCP servers, and scripts.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/process.sh"
          }
        ]
      }
    ]
  }
}
```

## Plugin Settings

```json
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "deployer@acme-tools": true
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

## Debugging

Use `claude --debug` to see:

- Which plugins are loading
- Manifest validation errors
- Command/agent/hook registration
- MCP server initialization

### Common Issues

| Symptom                | Cause                     | Solution                                   |
| ---------------------- | ------------------------- | ------------------------------------------ |
| Plugin not loading     | Invalid plugin.json       | Validate JSON syntax                       |
| Commands not appearing | Wrong directory structure | Components at root, not in .claude-plugin/ |
| Hooks not firing       | Script not executable     | `chmod +x script.sh`                       |
| Path errors            | Absolute paths used       | Use relative paths with `./`               |
