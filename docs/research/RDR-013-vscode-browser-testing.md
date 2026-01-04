# Research Decision Record: VSCode Browser Testing

| Field        | Value                                               |
| ------------ | --------------------------------------------------- |
| **Source**   | https://code.visualstudio.com/docs/copilot/overview |
| **Reviewed** | 2026-01-04                                          |
| **Status**   | Noted (Future Consideration)                        |

## Summary

VSCode Copilot supports browser automation via MCP servers, particularly the official **Microsoft Playwright MCP** (`@playwright/mcp`). This enables AI agents to navigate pages, interact with elements, take screenshots, and run test assertions—all integrated into the Copilot agent workflow. Browser testing is achievable now but not adopted into AGENTS core as it's project-specific configuration.

## Key Concepts

| Concept                 | Description                                                         |
| ----------------------- | ------------------------------------------------------------------- |
| **Playwright MCP**      | Official Microsoft MCP server for browser automation                |
| **Accessibility-First** | Uses accessibility tree (not pixels)—LLM-friendly, no vision needed |
| **Capability Flags**    | Opt-in features: `--caps=vision,testing,tracing,pdf`                |
| **Tool Approval**       | Browser actions require user confirmation (security)                |
| **128 Tool Limit**      | MCP tools count toward per-request limit                            |
| **Device Emulation**    | Test responsive layouts across 143+ device presets                  |

## Available Browser MCP Servers

| Server                                | Type       | Key Capabilities                                        |
| ------------------------------------- | ---------- | ------------------------------------------------------- |
| **@playwright/mcp** (Microsoft)       | Official   | Accessibility-first automation, screenshots, assertions |
| **@executeautomation/playwright-mcp** | Community  | Test code generation, 143 device presets                |
| **Browserbase**                       | Cloud      | Cloud-based browser sessions                            |
| **BrowserStack**                      | Platform   | Cross-browser testing, accessibility                    |
| **Storybook MCP**                     | Components | UI component testing automation                         |

## Decision

### Adopted

None for core AGENTS framework.

### Noted for Future Reference

1. **Capability exists** - Projects can use Playwright MCP for UI verification now
2. **Configuration pattern** - MCP server setup via `mcp.json` or CLI
3. **Autonomous verification** - Aligns with AGENTS' feedback loop principle in global.instructions.md

### Not Adopted

1. **Core integration** - Browser testing is project-specific, not framework-level
2. **New agent/skill** - Existing agents can use Playwright MCP when configured
3. **Synthesis updates** - No new principles discovered

### Rationale

Browser testing via Playwright MCP is a **capability unlock**, not a framework change. Projects needing UI verification can add the MCP server configuration. AGENTS' existing workflow supports this without modification—agents with access to Playwright MCP tools can already use them autonomously.

The key insight: **MCP servers are project configuration, not framework components.** AGENTS provides the workflow; projects configure the tools.

## Comparison to Current Framework

| Aspect              | Current AGENTS              | With Playwright MCP                           |
| ------------------- | --------------------------- | --------------------------------------------- |
| **UI Verification** | Manual or Playwright CLI    | Autonomous via agent tool calls               |
| **Feedback Loops**  | Log files, test output      | Screenshots, accessibility assertions         |
| **Review Agent**    | Code review, test execution | Plus visual regression, UI state verification |

## Usage When Needed

Projects with web UIs can add browser testing:

**Quick install:**

```bash
code --add-mcp '{"name":"playwright","command":"npx","args":["@playwright/mcp@latest"]}'
```

**Or configure `.vscode/mcp.json`:**

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--caps=testing"]
    }
  }
}
```

**Then agents can verify UI flows:**

- "Navigate to /login and verify the login form exists"
- "Take a screenshot of the dashboard after adding a new item"
- "Assert the error message appears when submitting an empty form"

## Related Decisions

- [RDR-009](RDR-009-mcp-memory-rejected.md) - MCP evaluation precedent
