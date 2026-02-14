# RDR-026: MetaPrompts

| Field      | Value                                    |
| ---------- | ---------------------------------------- |
| **Source** | https://github.com/JBurlison/MetaPrompts |
| **Date**   | 2026-01-26                               |
| **Status** | Rejected                                 |

## Summary

MetaPrompts provides a "meta agent" (`ai-builder`) that helps create/manage Copilot customization files. Includes skills for validation, overlap analysis, documentation generation, and a decision framework for choosing between agents/skills/prompts/instructions.

## Decision

**Rejected:** No changes made. Confirms our existing approach but doesn't add anything new.

- **Meta-agent for creating agents**: We have a mature agent structure; adding agent-creation complexity isn't needed. Agents are infrequent additions, handled via research workflow.
- **Validation/overlap-analysis skills**: Our agents are focused enough that overlap isn't a concern. `tests/validate-skills.sh` already exists.
- **Documentation generation skill**: Our README + synthesis docs approach is sufficient.
- **Core Rules template in every agent**: Overly verbose. Our agents are slim; global.instructions.md covers shared rules.
- **Decision Framework**: Already implicit in our structure (agents for workflow, skills for knowledge, instructions for file-pattern rules).

## Key Insight

Useful reference for frameworks offering multiple customization types:

- Single focused task → Prompt
- Multi-step with review → Agent workflow
- Apply automatically → Instructions
- Reusable knowledge → Skill
- Interactive conversation → Agent

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) - Our workflow patterns
- [RDR-017](RDR-017-agent-spec-compatibility.md) - Agent spec formats
