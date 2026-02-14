# RDR-025: Copilot Memory (Agentic Memory)

| Field      | Value                                                                            |
| ---------- | -------------------------------------------------------------------------------- |
| **Source** | [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |
| **Date**   | 2026-01-26                                                                       |
| **Status** | Partially Adopted                                                                |

## Summary

GitHub's Copilot Memory is a platform-level feature that stores repository-scoped "memories" automatically as Copilot works. Memories are validated against current code, expire after 28 days, and are shared across Copilot features (coding agent, code review, CLI).

## Decision

**Adopted:**

- `## Learned Patterns` section in AGENTS.md for repository-level pattern memory
- Citation-based format (Location column) for validation reference
- Staleness awareness (Discovered date, 14-day warning for task files)
- Implement agent learns from user corrections during implementation
- Explore agent discovers patterns during research

**Not adopted:**

- Automatic memory creation (ours is explicit, user-confirmed)
- Auto-expiry (rely on human curation)
- Platform integration (we're IDE-focused, not GitHub-hosted features)

## Key Insight

Copilot Memory's design validates memories against current code before use. Our lighter-touch version: record Location as reference, note discrepancies when patterns seem stale, rely on periodic human review.

## See Also

- [memory-and-continuity.md](../synthesis/memory-and-continuity.md) — Our session continuity approach
- [RDR-009](archive/RDR-009-mcp-memory-rejected.md) — Why we rejected MCP memory servers
