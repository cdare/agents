# Research Decision Record: Subagents and Context Forking

| Field        | Value                                                                                                            |
| ------------ | ---------------------------------------------------------------------------------------------------------------- |
| **Source**   | [VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#context-isolated-subagents) |
| **Reviewed** | 2026-01-01                                                                                                       |
| **Status**   | Partially Adopted                                                                                                |

## Summary

VS Code Copilot supports two distinct mechanisms for agent transitions: **handoffs** (which preserve full conversation context) and **subagents** (which fork into isolated context windows). This research clarifies when each mechanism is appropriate and how they can complement the existing AGENTS workflow.

## Key Concepts

| Concept                  | Description                                                                      |
| ------------------------ | -------------------------------------------------------------------------------- |
| **Handoff**              | Agent transition within same session; full conversation history preserved        |
| **Subagent**             | Isolated, autonomous agent with fresh context window; only final result returned |
| **Context Fork**         | Subagents start with clean context; do not inherit main session history          |
| **Result-Only Return**   | Subagent returns only final summary, not intermediate work                       |
| **Autonomous Execution** | Subagents run without user interaction until task complete                       |

## Context Inheritance Behavior

### Handoffs (Context Preserved)

```
Research Agent (session history A)
    │
    └──▶ [User clicks "Create Plan" handoff]
         │
         ▼
Plan Agent (receives FULL session history A + handoff prompt)
```

**Current AGENTS usage**: All phase transitions (Research→Plan→Implement→Review)

### Subagents (Context Forked)

```
Research Agent (session history A)
    │
    └──▶ [AI invokes #runSubagent]
         │
         ▼
    ┌────────────────────────────┐
    │ Subagent (FRESH context)   │
    │ - No session history A     │
    │ - Only task prompt         │
    │ - Autonomous execution     │
    └────────────────────────────┘
         │
         └──▶ Returns: ONLY final result
              │
              ▼
Research Agent (session history A + subagent result)
```

## Decision

**Adopted for Research Agent:**

- Document subagent usage for parallel investigations
- Use subagents for context-heavy explorations (file tracing, dependency analysis)
- Enable `runSubagent` tool in Research agent
- Provide guidelines for when to use subagents vs direct research

**Not Adopted for:**

- Phase transitions (Plan, Implement, Review) - handoffs work better
- Tasks requiring user interaction
- Tasks needing full session context

**Rationale:**

Subagents complement handoffs, not replace them. Key benefits:

1. **Context Compaction**: Main context receives only summaries, not all intermediate file reads
2. **Parallel Investigation**: Multiple research threads can run independently
3. **Focused Results**: Each investigation returns distilled findings
4. **Aligns with "Frequent Intentional Compaction"** from ACE framework

Handoffs remain superior for:

- Phase transitions requiring full context (Plan needs Research findings)
- Human review points
- Sequential workflows

## Use Cases in AGENTS Framework

| Use Case                | Phase    | Benefit                                                 |
| ----------------------- | -------- | ------------------------------------------------------- |
| Parallel research areas | Research | Explore auth + tests + API in parallel                  |
| Deep dependency tracing | Research | Follow complex chains without bloating main context     |
| Focused review checks   | Review   | Security, performance, test coverage as isolated checks |
| Dead code analysis      | Janitor  | Trace usage across large codebase                       |

## Implementation Notes

**Research Agent Updates:**

- Add `runSubagent` to tools list
- Document when to use subagents (Step 3.5: Parallel Investigations)
- Provide examples of subagent prompts
- Clarify subagent returns summary only, not full exploration

**Not Changed:**

- Handoff-based workflow remains primary pattern
- Phase transitions still use handoffs
- Handoff file pattern for cross-session continuity unchanged

## Comparison to Current Framework

This extends the current framework without replacing any patterns:

| Pattern               | Before               | After                           |
| --------------------- | -------------------- | ------------------------------- |
| Phase transitions     | Handoffs             | Handoffs (unchanged)            |
| Within-phase research | Direct investigation | Direct OR subagent (new option) |
| Context management    | Manual summarization | Subagents auto-compact          |

## Related Decisions

- [RDR-007](./archive/RDR-007-mitsuhiko-agent-stuff.md) - Handoff pattern adoption (archived)
- [RDR-008](./archive/RDR-008-handoff-workspace-constraint.md) - Workspace handoff files (archived)
- [Prevailing Wisdom](../synthesis/prevailing-wisdom.md) - "Frequent Intentional Compaction"

## Open Questions

1. **Prompt engineering**: What's the optimal way to structure subagent prompts for best results?
2. **Performance**: Does parallel subagent execution actually run in parallel, or sequentially?
3. **Custom agents in subagents**: How stable is the experimental `chat.customAgentInSubagent.enabled` feature?
4. **Error handling**: How do subagent errors surface to the main agent?

## References

- [VS Code Chat Sessions - Context-isolated subagents](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#context-isolated-subagents)
- [VS Code Custom Agents - Handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#handoffs)
