# Research Decision Record: MCP Memory Tools vs Handoff Pattern

| Field        | Value                                                            |
| ------------ | ---------------------------------------------------------------- |
| **Source**   | Internal evaluation: MCP Memory servers vs Handoff agent pattern |
| **Reviewed** | 2025-12-31                                                       |
| **Status**   | Rejected                                                         |

## Summary

Evaluated building custom MCP tools to enable memory (beads-style) for read-only Research/Plan agents. Three options considered: (1) use official @modelcontextprotocol/server-memory, (2) build custom MCP server, (3) extend existing Handoff pattern. Rejected adding MCP infrastructure in favor of existing Handoff agent solution.

## Key Concepts

| Concept              | Description                                                                                                               |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| MCP Memory Server    | Official server using knowledge graph (entities/relations/observations) with JSONL persistence                            |
| Handoff Agent        | Existing pattern where Research/Plan agents invoke Handoff agent (with editFiles) to persist context to .github/handoffs/ |
| Read-only constraint | Research/Plan agents intentionally restricted from writing files to maintain separation of concerns                       |

## Decision

**Adopted:** None - continue using Handoff agent pattern

**Rationale:** MCP servers would add significant complexity (Node process, mcp.json config, JSONL storage, maintenance burden) without proportional benefit. The Handoff agent already achieves cross-session persistence with minimal friction by writing timestamped markdown files. This aligns with the framework principle: simplicity over feature richness.

## Comparison to Current Framework

The Handoff pattern is already integrated and working. MCP tools would require:

- Installing/maintaining Node-based MCP server process
- Configuring mcp.json in VS Code settings
- Managing external storage format (JSONL)
- Learning new knowledge graph query patterns

Handoff provides similar value with simpler architecture: markdown files in .github/handoffs/, human-readable, version-controlled, no external dependencies.
