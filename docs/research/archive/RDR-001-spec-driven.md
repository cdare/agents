# Research Decision Record: Spec-Driven Development

| Field        | Value                                                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| **Source**   | https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/ |
| **Reviewed** | 2024-12-28                                                                                                              |
| **Status**   | Rejected                                                                                                                |

## Summary

GitHub's spec-driven development toolkit uses structured specification files (`.specstory/`) to capture requirements and implementation plans. AI agents read specs to understand context and generate code accordingly.

## Key Concepts

| Concept            | Description                                                                    |
| ------------------ | ------------------------------------------------------------------------------ |
| Spec Files         | Markdown specs in `.specstory/` folder defining features before implementation |
| History Tracking   | Captures conversation history and decisions during development                 |
| AI-Readable Format | Structured format optimized for LLM consumption                                |

## Decision

**Adopted:** None

**Rationale:** The framework already has a Research→Plan→Implement workflow that captures similar intent. Adding a separate spec file format would duplicate the Plan agent's output and add file maintenance overhead. The structured handoff between agents already provides the spec-like context.

## Comparison to Current Framework

The Plan agent produces implementation plans that serve the same purpose as spec files. The Review agent validates against intent. Adding another layer would conflict with the existing phase-based approach.
