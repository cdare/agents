# Research Decision Record: Copilot Context Cortex

| Field        | Value                                             |
| ------------ | ------------------------------------------------- |
| **Source**   | https://github.com/muaz742/copilot-context-cortex |
| **Reviewed** | 2024-12-28                                        |
| **Status**   | Rejected                                          |

## Summary

A "self-managing memory protocol" that uses a genesis prompt to create persistent context files in `.github/context/`. Focuses on session continuity and active learning through natural language "reflexes" (e.g., "Learn this" updates preferences).

## Key Concepts

| Concept                   | Description                                                                                        |
| ------------------------- | -------------------------------------------------------------------------------------------------- |
| Genesis Prompt            | Single prompt that auto-analyzes project and bootstraps memory structure                           |
| Four Pillars              | PROJECT_DNA.md (identity), WORKFLOW.md (rules), DECISION_LOG.md (ADRs), SESSION_JOURNAL.md (state) |
| Natural Language Reflexes | Trigger phrases like "Learn this" that auto-update context files                                   |
| Startup Routine           | Read SESSION_JOURNAL.md at session start to regain context                                         |

## Decision

**Adopted:** None (but inspired RDR format for research tracking)

**Rationale:** Different philosophy—Cortex focuses on persistent memory and learning over time; our framework focuses on structured workflow phases and explicit control. Active learning reflexes add hidden state changes that conflict with deterministic phase-based approach. Session continuity is better handled by VS Code's built-in chat history or explicit prompts.

## Comparison to Current Framework

- Research agent already captures project understanding (overlaps with PROJECT_DNA)
- Instructions files handle coding standards (overlaps with WORKFLOW)
- Phase-based outputs already flow context between agents
- Memory bank pattern was already documented in prevailing-wisdom.md but intentionally not adopted
