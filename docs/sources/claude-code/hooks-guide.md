# Claude Code Hooks Guide

Source: https://code.claude.com/docs/en/hooks-guide (fetched 2026-02-17)

## Overview

Hooks let you run custom commands before or after Claude Code events. Configure in settings.json or plugin hooks.json.

## Lifecycle Events

| Event                | When                      | Can Block    |
| -------------------- | ------------------------- | ------------ |
| `SessionStart`       | Beginning of session      | No           |
| `SessionEnd`         | End of session            | No           |
| `UserPromptSubmit`   | User submits prompt       | No           |
| `PreToolUse`         | Before tool executes      | Yes (exit 2) |
| `PostToolUse`        | After tool succeeds       | No           |
| `PostToolUseFailure` | After tool fails          | No           |
| `PermissionRequest`  | Permission dialog shown   | No           |
| `Notification`       | Claude sends notification | No           |
| `Stop`               | Claude attempts to stop   | No           |
| `SubagentStart`      | Subagent starts           | No           |
| `SubagentStop`       | Subagent attempts to stop | No           |
| `TeammateIdle`       | Agent team teammate idle  | No           |
| `TaskCompleted`      | Task marked completed     | No           |
| `PreCompact`         | Before context compaction | No           |

## Hook Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/format.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Entry Structure

```json
{
  "matcher": "pattern",
  "hooks": [
    {
      "type": "command|prompt|agent",
      ...
    }
  ]
}
```

## Matchers

Match which tools/events trigger the hook:

| Pattern       | Matches            |
| ------------- | ------------------ |
| `Edit`        | Edit tool only     |
| `Write\|Edit` | Write OR Edit      |
| `Bash`        | Bash tool          |
| `*`           | All tools          |
| `startup`     | SessionStart event |

For file-based matching, use the tool's file path in the matcher.

## Hook Types

### Command Hook

Execute shell commands:

```json
{
  "type": "command",
  "command": "./scripts/lint.sh",
  "timeout": 30000
}
```

### Prompt Hook

Evaluate a prompt with LLM:

```json
{
  "type": "prompt",
  "prompt": "Review the changes for security issues: $ARGUMENTS"
}
```

`$ARGUMENTS` is replaced with context about the triggering event.

### Agent Hook

Run an agentic verifier with tools:

```json
{
  "type": "agent",
  "prompt": "Verify the edit maintains type safety",
  "tools": ["Read", "Grep", "Bash"]
}
```

## Blocking with PreToolUse

Exit code 2 blocks the tool:

```bash
#!/bin/bash
# Block edits to protected files
if [[ "$CLAUDE_TOOL_ARG_FILE_PATH" == *"protected"* ]]; then
  echo "Cannot edit protected files"
  exit 2  # Block the operation
fi
exit 0  # Allow the operation
```

Other exit codes:

- `0`: Success, continue
- `1`: Failure (logged but continues)
- `2`: Block the operation

## Environment Variables

Available in hook scripts:

| Variable             | Description                    |
| -------------------- | ------------------------------ |
| `CLAUDE_PROJECT_DIR` | Project root directory         |
| `CLAUDE_SESSION_ID`  | Current session ID             |
| `CLAUDE_TOOL_NAME`   | Tool being used                |
| `CLAUDE_TOOL_ARG_*`  | Tool arguments                 |
| `CLAUDE_PLUGIN_ROOT` | Plugin directory (for plugins) |

## Example: Auto-Format on Save

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write \"$CLAUDE_TOOL_ARG_FILE_PATH\""
          }
        ]
      }
    ]
  }
}
```

## Example: Security Check Before Edit

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/check-sensitive-files.sh"
          }
        ]
      }
    ]
  }
}
```

## Example: Persist Environment Variables

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'conda activate myenv' >> \"$CLAUDE_ENV_FILE\""
          }
        ]
      }
    ]
  }
}
```

## Hook Locations

| Location         | Scope        | Priority |
| ---------------- | ------------ | -------- |
| Managed settings | Organization | Highest  |
| User settings    | User         | Medium   |
| Project settings | Project      | Lower    |
| Plugin hooks     | Plugin       | Lowest   |

## Managed Hook Control

Admins can restrict hooks:

```json
{
  "allowManagedHooksOnly": true,
  "disableAllHooks": false
}
```

When `allowManagedHooksOnly` is true:

- Only managed and SDK hooks run
- User, project, and plugin hooks blocked
