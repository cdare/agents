# Research Decision Record: VS Code Copilot Agent Tools

| Field        | Value                                                                        |
| ------------ | ---------------------------------------------------------------------------- |
| **Source**   | https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features |
| **Reviewed** | 2026-01-04                                                                   |
| **Status**   | Partially Adopted                                                            |

## Summary

VS Code Copilot provides 30+ built-in tools for agents, organized into categories: file read/edit, search, terminal, testing, source control, notebooks, and VS Code management. This research evaluated whether the current AGENTS framework tool selections are optimal.

## Key Concepts

| Concept            | Description                                                              |
| ------------------ | ------------------------------------------------------------------------ |
| Tool Sets          | Grouped tools (`#edit`, `#search`, `#runCommands`) for convenience       |
| Built-in Tools     | Native VS Code tools available without extensions or MCP servers         |
| Tool Approval      | Security mechanism requiring user approval for destructive tools         |
| `#usages`          | Combined Find All References + Find Implementation + Go to Definition    |
| `#changes`         | Structured source control changes, alternative to git CLI                |
| Custom Tool Naming | AGENTS uses `read/`, `edit/`, `execute/` prefixes for permission clarity |

## Complete Built-in Tools Reference

| Tool                      | Category       | Description                              |
| ------------------------- | -------------- | ---------------------------------------- |
| `#changes`                | Source Control | List of source control changes           |
| `#codebase`               | Search         | Perform code search in workspace         |
| `#createAndRunTask`       | Tasks          | Create and run a new task                |
| `#createDirectory`        | File Edit      | Create a new directory                   |
| `#createFile`             | File Edit      | Create a new file                        |
| `#edit`                   | Tool Set       | Enable modifications in workspace        |
| `#editFiles`              | File Edit      | Apply edits to files                     |
| `#editNotebook`           | Notebook       | Make edits to a notebook                 |
| `#extensions`             | VS Code        | Search for and ask about extensions      |
| `#fetch`                  | Web            | Fetch content from a web page            |
| `#fileSearch`             | Search         | Search for files by glob patterns        |
| `#getNotebookSummary`     | Notebook       | Get notebook cells and details           |
| `#getProjectSetupInfo`    | Setup          | Instructions for scaffolding projects    |
| `#getTaskOutput`          | Tasks          | Get output from running a task           |
| `#getTerminalOutput`      | Terminal       | Get terminal command output              |
| `#githubRepo`             | Web/GitHub     | Code search in a GitHub repo             |
| `#installExtension`       | VS Code        | Install a VS Code extension              |
| `#listDirectory`          | File Read      | List files in a directory                |
| `#new`                    | Setup          | Scaffold a new VS Code workspace         |
| `#newJupyterNotebook`     | Notebook       | Scaffold a new Jupyter notebook          |
| `#newWorkspace`           | Setup          | Create a new workspace                   |
| `#openSimpleBrowser`      | Browser        | Preview locally-deployed web app         |
| `#problems`               | Diagnostics    | Add workspace problems as context        |
| `#readFile`               | File Read      | Read file content                        |
| `#readNotebookCellOutput` | Notebook       | Read notebook cell output                |
| `#runCell`                | Notebook       | Run a notebook cell                      |
| `#runCommands`            | Tool Set       | Enable terminal commands                 |
| `#runInTerminal`          | Terminal       | Run shell command in terminal            |
| `#runNotebooks`           | Tool Set       | Enable running notebook cells            |
| `#runSubagent`            | Agent          | Run task in isolated subagent context    |
| `#runTask`                | Tasks          | Run an existing task                     |
| `#runTasks`               | Tool Set       | Enable running tasks                     |
| `#runTests`               | Testing        | Run unit tests                           |
| `#runVscodeCommand`       | VS Code        | Run a VS Code command                    |
| `#search`                 | Tool Set       | Enable searching for files               |
| `#searchResults`          | Search         | Get search results from Search view      |
| `#selection`              | Context        | Get current editor selection             |
| `#terminalLastCommand`    | Terminal       | Get last terminal command and output     |
| `#terminalSelection`      | Terminal       | Get current terminal selection           |
| `#testFailure`            | Testing        | Get unit test failure information        |
| `#textSearch`             | Search         | Find text in files                       |
| `#todos`                  | Progress       | Track implementation with a todo list    |
| `#usages`                 | Analysis       | References, implementations, definitions |
| `#VSCodeAPI`              | VS Code        | Ask about VS Code extension development  |

## Decision

**Adopted:**

1. Add `usages` tool to Research, Explore, and Plan agents - critical for tracing code relationships
2. Add `execute/testFailure` to Review agent - complements existing `runTests` capability
3. Add `changes` to Review and Commit agents - structured view of changes without git CLI

**Rationale:**

The `#usages` tool is a significant gap. It combines three code navigation capabilities (references, implementations, definitions) that are essential for understanding codebases. Research agents frequently need to trace how code is connected.

The `#changes` tool provides structured access to source control changes. Review and Commit agents currently rely on terminal git commands, but a dedicated tool provides better integration and reduces friction.

**Not Adopted:**

- Notebook tools (`#editNotebook`, `#runCell`, etc.) - specialized, not general-purpose
- VS Code management tools (`#extensions`, `#installExtension`) - IDE management, not coding
- Setup tools (`#new`, `#newWorkspace`) - project scaffolding, specialized use case
- Tool sets (`#edit`, `#search`) - current explicit tool listing is more transparent

## Comparison to Current Framework

| Agent     | Current Tools                                                            | Recommended Additions            |
| --------- | ------------------------------------------------------------------------ | -------------------------------- |
| Research  | `read/problems`, `read/readFile`, `search`, `web`, `todo`, `runSubagent` | `usages`                         |
| Explore   | `read/problems`, `read/readFile`, `search`, `web`, `todo`, `runSubagent` | `usages`                         |
| Plan      | `read/problems`, `read/readFile`, `search`, `web`, `todo`, `runSubagent` | `usages`                         |
| Implement | Full access (correct as-is)                                              | None                             |
| Review    | `execute/runTests`, `execute/getTerminalOutput`, `read/*`, `search`      | `execute/testFailure`, `changes` |
| Commit    | `execute/runInTerminal`, `execute/getTerminalOutput`, `read/*`           | `changes`                        |
| Handoff   | `read/readFile`, `edit/*`, `search`, `todo`                              | None                             |

The framework's custom naming convention (`read/`, `edit/`, `execute/`) provides clear permission semantics that align with the phase-based workflow philosophy. This is a good pattern to maintain.
