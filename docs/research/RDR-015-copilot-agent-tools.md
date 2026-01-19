# RDR-015: VS Code Copilot Agent Tools

| Field      | Value                                                                        |
| ---------- | ---------------------------------------------------------------------------- |
| **Source** | https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features |
| **Date**   | 2026-01-04                                                                   |
| **Status** | Partially Adopted                                                            |

## Summary

VS Code Copilot provides 30+ built-in tools for agents. This research evaluated tool selections for the AGENTS framework agents.

## Decision

**Adopted:**

- Add `usages` tool to Explore agent (Find References + Implementations + Definitions)
- Add `testFailure` to Review agent (complements `runTests`)
- Add `changes` to Review and Commit agents (structured source control view)

**Rejected:**

- Notebook tools (`#editNotebook`, `#runCell`)—specialized, not general-purpose
- VS Code management tools (`#extensions`, `#installExtension`)—IDE management
- Setup tools (`#new`, `#newWorkspace`)—project scaffolding, specialized
- Tool sets (`#edit`, `#search`)—explicit tool listing is more transparent

## Key Insight

The `#usages` tool is critical for code understanding—it combines three navigation capabilities essential for tracing code relationships. The AGENTS naming convention (`read/`, `edit/`, `execute/`) provides clear permission semantics.

## See Also

- [VS Code Copilot Features](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) — Official tool reference (authoritative, kept up-to-date)
