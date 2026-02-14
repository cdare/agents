# RDR-017: Agent Specification Compatibility

| Field      | Value                                                                  |
| ---------- | ---------------------------------------------------------------------- |
| **Source** | https://code.visualstudio.com/docs/copilot/customization/custom-agents |
| **Date**   | 2026-01-07                                                             |
| **Status** | Partially Adopted                                                      |

## Summary

VS Code agents use `.agent.md` with 12 frontmatter fields. Claude Code doesn't support agent files—uses slash commands instead. Implemented compatibility layer.

## Decision

**Adopted:**

- Generate Claude Code slash commands from agent bodies during `install.sh`
- Strip frontmatter, copy body to `~/.claude/commands/<agent>.md`
- Skip `handoff` agent (doesn't make sense standalone)

**Rejected:**

- Complex file-based handoff state management
- Tool restriction instructions (marginal value, adds noise)

## Key Insight

80/20 approach: the core value is methodology in each agent's instructions, not tool enforcement or handoff buttons. Claude Code users get the workflow discipline; acceptable losses are tool enforcement (Claude respects instructions anyway) and handoff buttons (run next command manually).

## Claude Code Limitations

| Feature           | VS Code | Claude Code  |
| ----------------- | ------- | ------------ |
| Agent modes       | ✅      | ❌           |
| Tool restrictions | ✅      | ❌           |
| Handoffs          | ✅      | ❌           |
| Skills            | ✅      | ✅ (symlink) |
