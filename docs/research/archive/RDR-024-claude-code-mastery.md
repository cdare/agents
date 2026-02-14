# RDR-024: Claude Code Mastery

| Field      | Value                                                 |
| ---------- | ----------------------------------------------------- |
| **Source** | https://github.com/TheDecipherist/claude-code-mastery |
| **Date**   | 2026-01-19                                            |
| **Status** | Partially Adopted                                     |

## Summary

Comprehensive Claude Code guide. Key insight: CLAUDE.md rules are suggestions; hooks provide deterministic enforcement.

## Decision

**Adopted:**

- Single-purpose chat principle (39% performance drop when mixing topics)—reinforces phase-based agents
- Hooks vs instructions distinction documented in prevailing-wisdom
- Context rot research supports our "lost in the middle" mitigations

**Rejected:**

- Global CLAUDE.md patterns (Claude Code-specific)
- Hook infrastructure (outside AGENTS scope; advisory, not enforcement)
- MCP server directory (tooling catalog, already in official docs)

## Key Insight

AGENTS provides advisory guidance that can be overridden (like CLAUDE.md). For deterministic enforcement, users need platform-level hooks—but most users don't need that level of control.

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Context management principles
- [RDR-017](RDR-017-agent-spec-compatibility.md) — Claude Code compatibility layer
