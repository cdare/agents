# 🔬 Deep Research

Research external frameworks and materials to evaluate potential improvements to this framework.

## Process

1. Read [README](./README.md), [prevailing wisdom](./docs/synthesis/prevailing-wisdom.md), and [framework comparison](./docs/synthesis/framework-comparison.md) IN FULL
2. Pick the next unchecked item from the Research List
3. Read it fully—follow links as needed to grasp its insights
4. Create an RDR (Research Decision Record) in `docs/research/` using the [template](./docs/research/TEMPLATE.md)
5. **If adopting findings, update relevant synthesis docs:**
   - Core principles → [prevailing-wisdom.md](./docs/synthesis/prevailing-wisdom.md)
   - Framework comparisons → [framework-comparison.md](./docs/synthesis/framework-comparison.md)
   - Memory/continuity patterns → [memory-and-continuity.md](./docs/synthesis/memory-and-continuity.md)
6. Mark the item as checked and link to the RDR

## Guidelines

- **One item per iteration** - Don't read ahead
- **Small tweaks preferred** - Avoid unnecessary complexity
- **Big changes need justification** - Explain why the benefit outweighs the cost
- **Document everything** - Even rejections are valuable for future reference

## Adding New Research Items

Add URLs to the list above. Format after research:

- [x] short-name → RDR-NNN

## Research List

- [x] [spec-driven-development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) → [RDR-001](docs/research/RDR-001-spec-driven.md)
- [x] [copilot-context-cortex](https://github.com/muaz742/copilot-context-cortex) → [RDR-002](docs/research/RDR-002-context-cortex.md)
- [x] [feature-dev-plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev) → [RDR-003](docs/research/RDR-003-feature-dev.md)
- [x] [superpowers](https://github.com/obra/superpowers) → [RDR-004](docs/research/RDR-004-superpowers.md)
- [x] [beads-memory](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) → [RDR-005](docs/research/RDR-005-beads.md)
- [x] [agentic-future](https://seconds0.substack.com/p/heres-whats-next-in-agentic-coding) → [RDR-006](docs/research/RDR-006-agentic-future.md)
- [x] [mitsuhiko-agent-stuff](https://github.com/mitsuhiko/agent-stuff/blob/main/skills/improve-skill/SKILL.md) → [RDR-007](docs/research/RDR-007-mitsuhiko-agent-stuff.md)
- [x] Building my own tools for memory (MCP servers) → [RDR-009](docs/research/RDR-009-mcp-memory-rejected.md) (Rejected)
- [x] Create guidelines for plan file artifacts → Resolved: Use Research → Handoff workflow (documented in [README](README.md#the-workflow))
- [x] Combine Research + Plan agents → Rejected: Separation enforces read-only research and different cognitive modes (see [prevailing-wisdom.md](docs/synthesis/prevailing-wisdom.md#principle-1-phased-workflows-with-explicit-boundaries))
- [x] Research whether Copilot subagents in VSCode fork the context, and start with a clean context. What of the main agent's context is being passed to those subagents? → [RDR-010](docs/research/RDR-010-subagents-context-fork.md) (Subagents fork context; adopted for parallel investigations in Research agent)
- [x] [planning-with-files](https://github.com/OthmanAdi/planning-with-files) → [RDR-012](docs/research/RDR-012-planning-with-files.md)
- [ ] [vscode-browser-testing](https://code.visualstudio.com/docs/copilot/overview) - Research VSCode/Copilot ability to utilize browsers for testing UI flows (Playwright integration, browser preview, etc.)
- [ ] [vscode-copilot-settings](https://code.visualstudio.com/docs/copilot/setup) - Research recommended VSCode settings/configurations for optimal Copilot agent performance
- [ ] [copilot-agent-tools](https://code.visualstudio.com/docs/copilot/copilot-extensibility-overview) - Research ALL tools available to agents in VSCode/Copilot and evaluate if current agent tool selections are optimal
- [ ] Research if there's a way to make the handoff agent deterministic. Right now there's usually a difference between what the research/explore/plan agents write in the chat window vs what the handoff produces
