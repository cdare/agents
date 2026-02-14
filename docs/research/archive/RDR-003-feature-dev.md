# RDR-003: Anthropic Feature-Dev Plugin

| Field      | Value                                                                               |
| ---------- | ----------------------------------------------------------------------------------- |
| **Source** | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev |
| **Date**   | 2024-12-28                                                                          |
| **Status** | Partially Adopted                                                                   |

## Summary

Official Anthropic plugin with 7-phase workflow, parallel sub-agents, and confidence-filtered reviews.

## Decision

**Adopted:**

- Clarifying questions emphasis in Explore agent
- Multiple architecture options with recommendation
- Confidence-based review filtering (high-confidence issues only)

**Rejected:**

- Parallel sub-agents (not supported in VS Code Copilot)
- `/command` syntax (Claude Code-specific)
- Full 7-phase workflow (existing workflow covers intent)

## Key Insight

Confidence-based filtering reduces review noise. Only report high-confidence issues; low-confidence issues create distraction without proportional value.
