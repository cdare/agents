# Research Decision Record: Claude Code Mastery

| Field        | Value                                                 |
| ------------ | ----------------------------------------------------- |
| **Source**   | https://github.com/TheDecipherist/claude-code-mastery |
| **Reviewed** | 2026-01-19                                            |
| **Status**   | Partially Adopted                                     |

## Summary

A comprehensive Claude Code guide covering CLAUDE.md configuration, hooks for deterministic enforcement, MCP servers, skills, LSP integration, and the critical importance of single-purpose chats. Key insight: CLAUDE.md rules are suggestions that can be overridden, while hooks provide deterministic enforcement that always executes.

## Key Concepts

| Concept                     | Description                                                                                         |
| --------------------------- | --------------------------------------------------------------------------------------------------- |
| **CLAUDE.md Hierarchy**     | Enterprise → Global User → Project → Local layering; global file applies to all projects            |
| **Hooks vs CLAUDE.md**      | CLAUDE.md = suggestions (can be ignored); Hooks = enforcement (always execute via exit codes)       |
| **Single-Purpose Chats**    | 39% performance drop when mixing topics; "One Task, One Chat" rule; use `/clear` between tasks      |
| **Context Rot**             | Recall decreases as context grows; 2% early misalignment → 40% failure rate                         |
| **Hook Exit Codes**         | 0=allow, 1=error (shown to user), 2=block operation + feed stderr to Claude                         |
| **Defense in Depth**        | Layer 1: behavioral rules (CLAUDE.md), Layer 2: access control (settings.json), Layer 3: git safety |
| **Progressive Disclosure**  | Skills load only name/description at startup; full content loaded when triggered                    |
| **Compounding Engineering** | Mistakes become documentation → CLAUDE.md becomes institutional knowledge                           |
| **LSP Integration**         | 900x faster code navigation; semantic understanding vs text-based search                            |
| **MCP Tradeoffs**           | MCP consumes tokens; for one-off queries, CLI tools are more efficient                              |

## Decision

**Partially Adopted:**

1. **Single-Purpose Chat principle** → Already aligned with AGENTS' phase-based workflow and subagent fan-out for context management. Reinforces our existing "40-60% context capacity" guideline.

2. **Hooks vs Instructions distinction** → Valuable insight for documentation. AGENTS' instructions are advisory (like CLAUDE.md); users wanting deterministic enforcement should use hooks separately. No framework changes needed, but added to prevailing-wisdom.

3. **Context rot research** → Supports our existing "lost in the middle" mitigations (periodic re-read of plan, todo updates as attention anchors).

**Not Adopted:**

1. **Global CLAUDE.md security patterns** → Claude Code-specific; AGENTS is IDE-agnostic. Users can implement their own global CLAUDE.md using these patterns.

2. **Hook infrastructure** → Outside AGENTS' scope (advisory patterns, not enforcement mechanisms). Hooks are Claude Code platform feature, not cross-IDE portable.

3. **MCP server directory** → Tooling catalog, not framework patterns. Already documented in official Claude Code docs.

4. **LSP** → Claude Code platform feature; not relevant to prompt/instruction design.

**Rationale:**

Claude Code Mastery is excellent **platform documentation** but largely orthogonal to AGENTS. The key concepts align with what we already know (phase-based workflows, context management, human-in-the-loop) but expressed through Claude Code's specific mechanisms (hooks, MCP, LSP).

The **single-purpose chat** principle (39% degradation from topic mixing) is the most transferable insight—it reinforces our phase-based approach where each agent has a focused purpose.

The **hooks vs suggestions** distinction is valuable context for users: AGENTS provides advisory guidance that can be overridden; for deterministic enforcement, users need platform-level hooks.

## Comparison to Current Framework

| Aspect                 | Claude Code Mastery                    | AGENTS                                  |
| ---------------------- | -------------------------------------- | --------------------------------------- |
| **Enforcement Model**  | Hooks (deterministic, platform-level)  | Advisory guidance (agent instructions)  |
| **Context Management** | `/clear` command, single-purpose chats | Phase-based agents, subagent fan-out    |
| **Configuration**      | CLAUDE.md hierarchy, settings.json     | Agent files, skills, instructions       |
| **Platform**           | Claude Code only                       | VS Code Copilot + Claude Code           |
| **Tool Integration**   | MCP servers                            | IDE-native tools (restricted per agent) |

**Key alignment:** Both frameworks converge on:

- Focused, single-purpose interactions (phase-based vs single-purpose chats)
- Context window discipline (40-60% capacity, context rot awareness)
- Layered configuration (global → project → local)
- Skills for progressive disclosure

**Key divergence:** AGENTS focuses on portable advisory patterns; Claude Code Mastery focuses on Claude Code-specific enforcement mechanisms.
