# RDR-031: VS Code 1.109 Orchestration Features

| Field      | Value                                        |
| ---------- | -------------------------------------------- |
| **Source** | https://code.visualstudio.com/updates/v1_109 |
| **Date**   | 2026-02-12                                   |
| **Status** | Adopted ⭐                                   |

## Summary

VS Code 1.109 added agent orchestration capabilities: custom agents as subagents, parallel execution, new frontmatter for scope control, and new tools (askQuestions, memory, searchSubagent).

## Decision

**Adopted:**

- Custom agent file locations (`chat.agentFilesLocations`) → `~/.copilot/agents/`
- `agents` frontmatter for scope control
- `user-invokable: false` for internal subagents
- `disable-model-invocation` for explicit-only agents
- Model fallback arrays
- Orchestrate agent (conductor pattern)
- Research + Worker internal subagents

**Partially Adopted:**

- `askQuestions` tool — used in Orchestrate for pause points
- Copilot memory — enabled but relies on AGENTS.md Learned Patterns

**Not Adopted:**

- Auto-invocation by model — prefer explicit subagent spawns

## Key Insight

Context isolation via subagents is the key capability. Parent agents stay focused while subagents handle deep exploration. The `agents` frontmatter enforces which subagents an agent can spawn, preventing scope creep.

## See Also

- [RDR-010](RDR-010-subagents-context-fork.md) — Subagent context isolation pattern
- [RDR-014](RDR-014-vscode-copilot-settings.md) — Previous settings research
- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Section 7: VSCode Copilot Customization
