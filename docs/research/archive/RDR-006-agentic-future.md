# Research Decision Record: What's Next in Agentic Coding

| Field        | Value                                                              |
| ------------ | ------------------------------------------------------------------ |
| **Source**   | https://seconds0.substack.com/p/heres-whats-next-in-agentic-coding |
| **Reviewed** | 2025-12-29                                                         |
| **Status**   | Informational                                                      |

## Summary

A forward-looking analysis of agentic coding trends by Seconds_0, predicting that "Plan Mode" will become dominant (flipping from 20:80 to 80:20 plan:execute ratio), context management will remain the core challenge, and multiagent orchestration will become standard. The article synthesizes patterns from current tools (Cursor, Windsurf, Claude Code) into predictions about where the field is heading.

## Key Concepts

| Concept                   | Description                                                                                |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| **Plan Mode Revolution**  | Future agents will spend 80% of time planning, 20% executing (inverse of today's pattern)  |
| **Context is Everything** | The fundamental challenge remains getting the right context to the agent at the right time |
| **Grep + Embeddings**     | Hybrid search (keyword + semantic) is emerging as the standard for codebase understanding  |
| **Docs by Default**       | Agents that read documentation first make better decisions; will become standard           |
| **Skills/Rules**          | Conditional instructions that activate based on context (our framework already has this)   |
| **Portable Configs**      | User preferences that travel between tools (like our `instructions/` directory)            |
| **Best of N**             | Generate N solutions, pick best—used for reflection and self-improvement                   |
| **Mix of Models**         | Different models for different tasks (fast for simple, powerful for complex)               |
| **Subagents**             | Spawning focused agents for specific tasks, isolating context and risk                     |
| **Quality Loop**          | Critic agents, self-review, memory externalization for continuous improvement              |

## Decision

**Status: Informational**

This is a trends/predictions article rather than a concrete framework to adopt. Useful for understanding where the field is heading and validating our current direction.

**Validates Our Approach:**

1. **Phase-based workflow** - Our Research → Plan → Implement aligns with "Plan Mode" emphasis
2. **Tool restrictions** - Our read-only Research/Plan agents align with "context isolation"
3. **Skills system** - Already have conditional activation based on prompts
4. **Instructions files** - Already have portable configs per file type
5. **Model selection** - Agents can specify preferred models (Opus for heavy, Sonnet for fast)

**Future Considerations:**

1. **Subagent spawning** - Not currently supported by our platform, but worth watching
2. **Critic agent** - Could add as a skill or integrate into Review agent
3. **Memory externalization** - See RDR-005 (Beads) for structured approach

**Not Applicable:**

- Best of N (requires orchestration layer we don't have)
- Mix of Models within single task (platform limitation)

## Comparison to Current Framework

| Prediction                 | Our Current State                    | Gap                    |
| -------------------------- | ------------------------------------ | ---------------------- |
| Plan Mode dominance        | ✅ Research + Plan agents            | None                   |
| Context management central | ✅ Handoff buttons preserve context  | Multi-session is a gap |
| Grep + embeddings          | ✅ Tools include both search types   | None                   |
| Skills/rules               | ✅ Skills + instructions             | None                   |
| Portable configs           | ✅ Instructions directory            | None                   |
| Subagents                  | ❌ Not supported                     | Platform limitation    |
| Quality loop/critic        | ⚠️ Review agent, no dedicated critic | Could add critic skill |
| Memory externalization     | ❌ No cross-session memory           | See RDR-005 (Beads)    |

## Key Quote

> "Context management is everything. The agent that understands your codebase best will be the most helpful."

This validates our emphasis on Research phase and comprehensive context gathering before planning.

## Related Research

- **RDR-005**: Beads Memory System - addresses the memory externalization gap
- **RDR-004**: Superpowers - another skills-based approach with similar patterns
