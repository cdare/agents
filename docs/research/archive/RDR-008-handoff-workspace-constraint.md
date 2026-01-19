# Research Decision Record: Handoff Agent Workspace Constraint

| Field        | Value                                                                     |
| ------------ | ------------------------------------------------------------------------- |
| **Source**   | Internal investigation (VS Code Copilot editFiles tool, global gitignore) |
| **Reviewed** | 2025-12-31                                                                |
| **Status**   | Adopted                                                                   |

## Summary

The Handoff agent was designed to write session context to `~/.copilot/handoffs/` (outside the workspace), but VS Code Copilot's `editFiles` tool is workspace-scoped and cannot write to paths outside workspace folders—even with permission dialogs. The solution: write to `.github/handoffs/` inside the workspace and configure global gitignore to prevent accidental commits.

## Key Concepts

| Concept                | Description                                                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| Workspace-scoped tools | VS Code Copilot's `editFiles` can only modify files within open workspace folders                |
| Global gitignore       | User-level gitignore at `~/.config/git/ignore` or custom path via `core.excludesFile`            |
| Permission dialog      | "Allow edits to sensitive files" only applies to files **within workspace**, not arbitrary paths |
| Multi-folder workspace | Can add `~/.copilot` as workspace folder, but rejected due to UX complexity                      |

## Decision

**Adopted:**

1. Changed handoff output from `~/.copilot/handoffs/` to `.github/handoffs/`
2. Modified `install.sh` to add `.github/handoffs/` to global gitignore
3. Updated both Handoff and Implement agents to use new location
4. Removed `~/.copilot/handoffs/` directory creation from install script

**Rationale:**

- **Workspace constraint is fundamental**: No workaround exists for `editFiles` outside workspace
- **.github/ is established convention**: Agents already live in `.github/agents/`
- **Global gitignore solves accidental commits**: Default ignored, but selectively shareable with `git add -f`
- **Rejected alternatives**:
  - Multi-folder workspace: Too complex, requires manual setup per repo
  - `.vscode/`: Inconsistent gitignore patterns across teams
  - `runInTerminal`: Requires terminal tools enabled, less reliable

## Comparison to Current Framework

### HumanLayer/ACE Pattern

HumanLayer uses `thoughts/` directory **inside the repo** with this structure:

- `thoughts/shared/research/` - Team-shareable research
- `thoughts/local/` - Personal notes (gitignored)

Our approach is similar but optimized for personal session context:

- `.github/handoffs/` - Personal by default (global gitignore)
- Can be selectively shared when needed

### Before vs After

| Aspect      | Before                       | After                       |
| ----------- | ---------------------------- | --------------------------- |
| Location    | `~/.copilot/handoffs/`       | `.github/handoffs/`         |
| Visibility  | Outside repo                 | Inside repo                 |
| Git status  | N/A                          | Ignored by global gitignore |
| Sharing     | Copy/paste only              | `git add -f` to commit      |
| Tool access | ❌ Fails (outside workspace) | ✅ Works (inside workspace) |

## Implementation Notes

### Global Gitignore Configuration

```bash
# Get configured path or set default
gitignore_global=$(git config --global core.excludesFile)
if [[ -z "$gitignore_global" ]]; then
    gitignore_global="$HOME/.config/git/ignore"
    git config --global core.excludesFile "$gitignore_global"
fi

# Add pattern
echo "# Copilot handoffs (personal session context)" >> "$gitignore_global"
echo ".github/handoffs/" >> "$gitignore_global"
```

### Selective Sharing

To commit a specific handoff:

```bash
git add -f .github/handoffs/2025-12-31-important-plan.md
git commit -m "Add implementation plan for feature X"
```

## References

- [VS Code Multi-root Workspaces](https://code.visualstudio.com/docs/editor/workspaces/multi-root-workspaces)
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [GitHub gitignore best practices](https://github.com/github/gitignore/blob/main/Global/VisualStudioCode.gitignore)
- [HumanLayer ACE Framework](https://hlyr.dev/he-gh) - Inspiration for in-repo session persistence
