# RDR-013: VSCode Browser Testing

| Field      | Value                                               |
| ---------- | --------------------------------------------------- |
| **Source** | https://code.visualstudio.com/docs/copilot/overview |
| **Date**   | 2026-01-04                                          |
| **Status** | Future Consideration                                |

## Summary

Browser automation via Playwright MCP (`@playwright/mcp`). Uses accessibility tree (LLM-friendly, no vision needed).

## Decision

**Not Adopted (Yet):**

Browser testing is project-specific configuration, not a framework component. AGENTS provides the workflow; projects configure the tools.

**When to Use:**

Projects with web UIs can add Playwright MCP for autonomous UI verification:

```bash
code --add-mcp '{"name":"playwright","command":"npx","args":["@playwright/mcp@latest"]}'
```

## Key Insight

MCP servers are project configuration, not framework components. AGENTS' existing agents can use Playwright MCP when configured—no framework changes needed.

## See Also

- [Playwright MCP](https://github.com/playwright-community/mcp) — Official docs
- [RDR-014](RDR-014-vscode-copilot-settings.md) — MCP server configuration patterns
