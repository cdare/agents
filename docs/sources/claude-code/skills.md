# Claude Code Skills

Source: https://code.claude.com/docs/en/skills (fetched 2026-02-17)

## Overview

Skills are reusable prompts that extend Claude Code's capabilities. They can be:

- Invoked by users with `/skill-name`
- Auto-invoked by Claude based on task context
- Preloaded into subagents via `skills:` frontmatter

## Skill File Format

Skills are directories with a `SKILL.md` file:

```
~/.claude/skills/
├── debug/
│   └── SKILL.md
├── architecture/
│   ├── SKILL.md
│   └── reference.md (optional)
└── code-review/
    ├── SKILL.md
    └── scripts/
        └── lint.sh
```

## SKILL.md Format

```yaml
---
name: skill-name
description: When to use this skill and what it does
disable-model-invocation: false
user-invocable: true
allowed-tools: [Read, Grep, Glob]
model: sonnet
context: fork
agent: custom-agent
hooks:
  PreToolUse:
    - matcher: "Edit"
      hooks:
        - type: command
          command: "./validate.sh"
---
# Skill Name

Detailed instructions for the skill...
```

## Frontmatter Fields

| Field                      | Type    | Description                            | Default        |
| -------------------------- | ------- | -------------------------------------- | -------------- |
| `name`                     | string  | Skill identifier                       | Directory name |
| `description`              | string  | When Claude should use this skill      | Required       |
| `disable-model-invocation` | boolean | Prevent Claude from auto-invoking      | `false`        |
| `user-invocable`           | boolean | Allow user to invoke directly          | `true`         |
| `allowed-tools`            | array   | Restrict tools when skill is active    | All tools      |
| `model`                    | string  | Override model for skill execution     | Inherit        |
| `context`                  | string  | `fork` runs skill in isolated subagent | Main context   |
| `agent`                    | string  | Run in specific subagent type          | Default        |
| `hooks`                    | object  | Lifecycle hooks for this skill         | None           |

## Context: Fork

When `context: fork` is set:

- Skill runs in an isolated subagent context
- Has its own conversation history
- Tool restrictions apply only within the fork
- Returns summary to parent context

Useful for read-only analysis that shouldn't pollute main context.

## Dynamic Arguments

Skills can accept arguments using `$ARGUMENTS` placeholder:

```markdown
---
name: analyze
description: Analyze code with custom focus
---

# Analyze Code

Analyze the following with focus on: $ARGUMENTS

[rest of skill instructions]
```

Usage: `/analyze security vulnerabilities`

## Command Injection

Skills can inject dynamic content with `` `!command` ``:

```markdown
---
name: review-pr
description: Review current PR
---

# PR Review

Current changes:
`!git diff main`

Review these changes for issues.
```

## Skill Locations

| Location            | Scope   | Shared          |
| ------------------- | ------- | --------------- |
| `~/.claude/skills/` | User    | No              |
| `.claude/skills/`   | Project | Yes (via VCS)   |
| Plugin skills       | Plugin  | Via marketplace |

## Example: Debug Skill

```yaml
---
name: debug
description: Systematic debugging with hypothesis-driven investigation
allowed-tools: [Read, Bash, Edit, Write, Grep, Glob]
---

# Debug Mode

## Core Approach
> "Don't guess. Form hypotheses. Test them."

## Process
1. Reproduce the issue
2. Form hypothesis
3. Add logging/debugging
4. Test hypothesis
5. Fix or revise hypothesis
```

## Example: Architecture Skill (Read-Only)

```yaml
---
name: architecture
description: Document system structure and component relationships
allowed-tools: [Read, Grep, Glob]
context: fork
---

# Architecture Mode

Focus on interfaces, data flow, and integration points.
Never include implementation details.

## Output
- System boundaries
- Data flow diagrams
- Integration points
- Key design decisions
```

## Preloading Skills in Subagents

Subagents can preload skills:

```yaml
---
name: code-reviewer
description: Review code with multiple analysis modes
skills: [security-review, architecture, debug]
---
```

The skill instructions are loaded into the subagent's context at startup.
