# 🔬 Deep Research

Research external frameworks and materials to evaluate potential improvements to this framework.

## Process

1. Read [README](./README.md), [prevailing wisdom](./docs/synthesis/prevailing-wisdom.md), and [framework comparison](./docs/synthesis/framework-comparison.md) IN FULL
2. Pick the next unchecked item from the Research List
3. Read it fully—follow links as needed to grasp its insights
4. Create an RDR (Research Decision Record) in `docs/research/` using the [template](./docs/research/TEMPLATE.md)
5. Mark the item as checked and link to the RDR

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
- [ ] Building my own tools, to enable memory (eg beads) in Research/Plan agents, without letting them write to any files in the repo. Meaning, I want to keep their read-only nature, but want to have the option to step outside a given context window. See previous RDRs: RDR-005 and RDR-006
- [ ] Consider combining research and plan agents. Weigh the pros and cons of doing so. At the moment, the research agent is doing the majority of the heavy lifting, and I'm not seeing too much additional value of the separate plan stage. If there's value in keeping them separate, consider what would make the plan agent more valuable.
- [ ] Create guidelines for which agent(s) to use when I want the artifact to be a plan file. I like the research agent, but it doesn't have permissions to create files, which is problematic. Using the Implement agent loses some of the deep research capabilities in the Research agent.
- [ ] Research whether Copilot subagents in VSCode fork the context, and start with a clean context. What of the main agent's context is being passed to those subagents? If the memory/context is forked, then this means we can easily utilize subagents for steps like Plan
