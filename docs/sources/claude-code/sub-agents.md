# Claude Code Subagents

Source: https://code.claude.com/docs/en/sub-agents (fetched 2026-02-17)

## Overview

Claude Code supports custom AI subagents stored as Markdown files with YAML frontmatter:

- **User subagents:** `~/.claude/agents/` - Available across all your projects
- **Project subagents:** `.claude/agents/` - Specific to your project, shareable with team

## Subagent File Format

```yaml
---
name: agent-name
description: What this agent does and when Claude should invoke it
tools: [Read, Edit, Bash, Grep, Glob]
disallowedTools: [WebFetch]
model: sonnet
permissionMode: default
maxTurns: 10
skills: [skill-name-1, skill-name-2]
mcpServers: [server-name]
hooks:
  PreToolUse:
    - matcher: "Edit"
      hooks:
        - type: command
          command: "./validate.sh"
memory: user
---
Detailed system prompt for the agent describing its role, expertise, and behavior.
```

## Frontmatter Fields

| Field             | Type   | Description                                                   | Example                                         |
| ----------------- | ------ | ------------------------------------------------------------- | ----------------------------------------------- |
| `name`            | string | Unique identifier                                             | `code-reviewer`                                 |
| `description`     | string | When Claude should invoke this agent                          | `Expert code reviewer. Use after code changes.` |
| `tools`           | array  | Allowlist of tools (if specified, ONLY these tools available) | `[Read, Edit, Bash]`                            |
| `disallowedTools` | array  | Denylist of tools (removed from model context)                | `[WebFetch, WebSearch]`                         |
| `model`           | string | Model alias: `sonnet`, `opus`, `haiku`, or `inherit`          | `sonnet`                                        |
| `permissionMode`  | string | How permissions are handled (see below)                       | `plan`                                          |
| `maxTurns`        | number | Maximum agentic turns before stopping                         | `10`                                            |
| `skills`          | array  | Skills to preload into context                                | `[debug, architecture]`                         |
| `mcpServers`      | array  | MCP servers for this subagent                                 | `[memory, github]`                              |
| `hooks`           | object | Lifecycle hooks specific to this subagent                     | (see hooks docs)                                |
| `memory`          | string | Memory scope: `user`, `project`, or `local`                   | `project`                                       |

## Permission Modes

| Mode                | Description                                        |
| ------------------- | -------------------------------------------------- |
| `default`           | Standard permission prompting                      |
| `acceptEdits`       | Auto-accept file edits, prompt for bash            |
| `plan`              | Read-only exploration mode - no file modifications |
| `delegate`          | Agent can spawn teammates (agent teams)            |
| `dontAsk`           | Accept most operations without prompting           |
| `bypassPermissions` | Accept all operations (requires flag)              |

## Tool Names

Available tool names for `tools` and `disallowedTools`:

| Tool               | Description                             |
| ------------------ | --------------------------------------- |
| `Read`             | Read file contents                      |
| `Write`            | Create or overwrite files               |
| `Edit`             | Make targeted edits to files            |
| `Bash`             | Execute shell commands                  |
| `Grep`             | Search for patterns in file contents    |
| `Glob`             | Find files by pattern matching          |
| `WebFetch`         | Fetch content from URLs                 |
| `WebSearch`        | Perform web searches                    |
| `Task`             | Spawn subagents                         |
| `Task(agent-name)` | Restrict which subagents can be spawned |
| `AskUserQuestion`  | Ask multiple-choice questions           |
| `Skill`            | Execute a skill                         |
| `TaskCreate`       | Create task in task list                |
| `TaskList`         | List all tasks                          |
| `TaskGet`          | Get task details                        |
| `TaskUpdate`       | Update task status                      |
| `LSP`              | Code intelligence via language servers  |
| `NotebookEdit`     | Modify Jupyter notebooks                |

## Critical Constraint

> **Subagents cannot spawn other subagents.**

This means:

- User → Subagent A → Subagent B: ✅ Works (2 levels)
- User → Subagent A → Subagent B → Subagent C: ❌ Fails (3 levels)

## Invoking Subagents

Subagents can be invoked:

- Manually: `@agent-name` in chat
- Automatically: Claude invokes based on task context and description
- Via CLI: `claude --agent my-custom-agent`
- Via CLI definition: `claude --agents '{"reviewer": {"description": "...", "prompt": "..."}}'`

## Example: Code Reviewer

```yaml
---
name: code-reviewer
description: Expert code reviewer. Use proactively after code changes.
tools: [Read, Grep, Glob, Bash]
disallowedTools: [Edit, Write]
model: sonnet
---

You are a senior code reviewer. Focus on:
- Code quality and readability
- Security vulnerabilities
- Performance issues
- Best practices

Review the changes and provide actionable feedback.
```

## Example: Read-Only Explorer

```yaml
---
name: explorer
description: Research and planning agent. Cannot modify code.
tools: [Read, Grep, Glob, WebFetch, WebSearch]
disallowedTools: [Edit, Write, Bash]
model: opus
permissionMode: plan
---
You are a research agent. Investigate the codebase thoroughly.
Document findings but do not make changes.
```
