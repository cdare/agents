# RDR-014: VSCode Copilot Settings

| Field      | Value                                            |
| ---------- | ------------------------------------------------ |
| **Source** | https://code.visualstudio.com/docs/copilot/setup |
| **Date**   | 2026-01-04 (Updated 2026-01-09)                  |
| **Status** | Partially Adopted                                |

## Summary

VSCode Copilot has ~50+ configurable settings. Key finding: VSCode natively supports AGENTS.md and has adopted the agentskills.io standard for skills. **For 1.109+ orchestration features, see [RDR-031](RDR-031-vscode-1109-orchestration.md).**

## Decision

**Adopted:**

- Document recommended settings (below)
- Enable `chat.useNestedAgentsMdFiles` for monorepos
- Note agentskills.io alignment validates our skill format

**No changes needed:** AGENTS is already aligned with VSCode's native architecture.

## Recommended Settings

```json
{
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 50,
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true,
  "chat.useAgentSkills": true,
  "github.copilot.chat.summarizeAgentConversationHistory.enabled": true,
  "github.copilot.chat.agent.autoFix": true,
  "chat.tools.terminal.enableAutoApprove": true,
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace"
}
```

## Key Insight

Skills use 3-level progressive loading: Discovery (~100 tokens) → Instructions (<5000 tokens) → Resources (as needed). Personal skills location changed to `~/.copilot/skills` in v1.108.

## See Also

- [VS Code Copilot Setup](https://code.visualstudio.com/docs/copilot/setup) — Official settings reference
- [agentskills.io](https://agentskills.io/) — Open standard for agent skills
