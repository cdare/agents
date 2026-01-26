# 🔬 Deep Research

**Mission:** Continuously improve the AGENTS framework by learning from external sources, adopting what works, and keeping our patterns current.

This file is a prompt for research sessions. Use it to:

- **Discover** new agent frameworks, prompt patterns, and IDE features
- **Evaluate** whether they improve our workflow, agents, or skills
- **Adopt** useful patterns into synthesis docs and framework components
- **Maintain** existing patterns as capabilities evolve

## Finding Previous Research

See [CATALOG.md](docs/research/CATALOG.md) for quick reference by topic and status.

## Philosophy

**Synthesis docs are authoritative.** RDRs document _why_ we made a decision; synthesis docs document _what_ we do now.

| I want to...                | Update...                     |
| --------------------------- | ----------------------------- |
| Record research + decision  | RDR (`docs/research/`)        |
| Document a pattern/practice | Synthesis (`docs/synthesis/`) |
| Add a new principle         | `prevailing-wisdom.md`        |
| Compare frameworks          | `framework-comparison.md`     |
| Describe continuity pattern | `memory-and-continuity.md`    |

**RDRs should be slim** (~50 lines). If you're writing paragraphs of explanation, that belongs in synthesis.

**One item per iteration.** Small tweaks preferred. Big changes need justification.

### What "Adoption" Means

Adoption requires a **concrete change** to the framework:

| Status                | Meaning                                                      |
| --------------------- | ------------------------------------------------------------ |
| **Adopted**           | Created/modified agents, skills, synthesis docs, or workflow |
| **Partially Adopted** | Some ideas incorporated, others rejected                     |
| **Rejected**          | Evaluated but no changes made (out of scope, doesn't fit)    |
| **Future**            | Good idea, but blocked or deferred                           |

"Validates our approach" or "confirms we're on track" = **Rejected** (informational). If nothing changed, nothing was adopted.

## Process

### 1. Find Research Candidates

**From backlog:** Pick next unchecked item from Research List below. Items can be:

- **External links** - repos, articles, docs to review
- **Internal tasks** - ideas to explore, improvements to investigate

Process both types the same way: research, evaluate, document decision.

**From discovery sources:** When backlog is empty or you want fresh ideas:

| Source           | How to Search                                                                | Examples                                                                                                                                       |
| ---------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| GitHub           | Search `copilot instructions` or `agent prompts`, check trending             | [awesome-copilot](https://github.com/LouisShark/awesome-copilot), [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) |
| Yegge's blog     | Check [steve-yegge.medium.com](https://steve-yegge.medium.com)               | Beads memory system, Six Tips for Agents                                                                                                       |
| VS Code releases | Check [code.visualstudio.com/updates](https://code.visualstudio.com/updates) | Skills API (1.108), new Copilot tools                                                                                                          |
| Anthropic/OpenAI | Check engineering blogs and plugin repos                                     | [ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum), feature-dev                                          |
| Upstream repos   | Revisit repos we adopted from                                                | 12-Factor Agents, HumanLayer ACE                                                                                                               |

**Manual additions welcome.** Add URLs to Research List as you discover them.

### 2. Research & Evaluate

1. Read [README](./README.md) and relevant [synthesis docs](./docs/synthesis/) for context
2. Read the source fully, follow links
3. Ask: Does this improve our agents, skills, or patterns?

### 3. Document Decision

Create RDR using [template](./docs/research/TEMPLATE.md) (~50 lines). Mark with ⭐ if high-impact.

### 4. Synthesize (if adopting)

Update the relevant synthesis doc—RDRs record decisions, synthesis docs record patterns.

| Adoption Type   | Update                                                      |
| --------------- | ----------------------------------------------------------- |
| New principle   | [prevailing-wisdom.md](docs/synthesis/prevailing-wisdom.md) |
| New skill       | Create in `.github/skills/`, update README counts           |
| Agent change    | Update agent in `.github/agents/`                           |
| Workflow change | Update README workflow section                              |

## Maintenance Triggers

Signals that synthesis docs may need revisiting:

| Trigger                                      | Action                                           |
| -------------------------------------------- | ------------------------------------------------ |
| New model capabilities (tools, context size) | Review affected patterns in prevailing-wisdom.md |
| Pattern frequently overridden in practice    | Consider if guidance needs updating              |
| Upstream framework has major update          | Check if our adoption is stale                   |
| 6+ months since synthesis doc update         | Skim for staleness                               |

## Research List

- [x] [spec-driven-development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) → [RDR-001](docs/research/archive/RDR-001-spec-driven.md)
- [x] [copilot-context-cortex](https://github.com/muaz742/copilot-context-cortex) → [RDR-002](docs/research/archive/RDR-002-context-cortex.md)
- [x] [feature-dev-plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev) → [RDR-003](docs/research/RDR-003-feature-dev.md)
- [x] [superpowers](https://github.com/obra/superpowers) → [RDR-004](docs/research/RDR-004-superpowers.md)
- [x] [beads-memory](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) → [RDR-005](docs/research/RDR-005-beads.md)
- [x] [agentic-future](https://seconds0.substack.com/p/heres-whats-next-in-agentic-coding) → [RDR-006](docs/research/archive/RDR-006-agentic-future.md)
- [x] [mitsuhiko-agent-stuff](https://github.com/mitsuhiko/agent-stuff/blob/main/skills/improve-skill/SKILL.md) → [RDR-007](docs/research/archive/RDR-007-mitsuhiko-agent-stuff.md)
- [x] Building my own tools for memory (MCP servers) → [RDR-009](docs/research/archive/RDR-009-mcp-memory-rejected.md) (Rejected)
- [x] Create guidelines for plan file artifacts → Resolved: Use Research → Handoff workflow (documented in [README](README.md#the-workflow))
- [x] Combine Research + Plan agents → [RDR-016](docs/research/RDR-016-agent-consolidation.md) ⭐ (Adopted: consolidated into Explore agent, reversing previous rejection)
- [x] Research whether Copilot subagents in VSCode fork the context, and start with a clean context. What of the main agent's context is being passed to those subagents? → [RDR-010](docs/research/RDR-010-subagents-context-fork.md) (Subagents fork context; adopted for parallel investigations in Research agent)
- [x] [planning-with-files](https://github.com/OthmanAdi/planning-with-files) → [RDR-012](docs/research/RDR-012-planning-with-files.md) ⭐
- [x] [vscode-browser-testing](https://code.visualstudio.com/docs/copilot/overview) → [RDR-013](docs/research/RDR-013-vscode-browser-testing.md)
- [x] [vscode-copilot-settings](https://code.visualstudio.com/docs/copilot/setup) → [RDR-014](docs/research/RDR-014-vscode-copilot-settings.md)
- [x] [copilot-agent-tools](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) → [RDR-015](docs/research/RDR-015-copilot-agent-tools.md) (Partially Adopted: added `usages` to Research/Explore/Plan, `changes` and `testFailure` to Review/Commit)
- [x] Verify which parts of the agents specification follow are well defined (eg https://code.visualstudio.com/docs/copilot/customization/custom-agents), and whether they are compatible with Claude Code OOTB (including tool/model specifications) → [RDR-017](docs/research/RDR-017-agent-spec-compatibility.md)
- [x] Improve testing of agents, including making sure the install.sh script works, and that we're properly testing Claude Code related configurations
- [x] Find opportunities to trim down agents (mainly explore and implement)
- [x] [vscode-1.108-skills](https://code.visualstudio.com/updates/v1_108) → [RDR-014](docs/research/RDR-014-vscode-copilot-settings.md) (Adopted: updated install.sh to use ~/.copilot/skills, added 1.108 findings to RDR-014)
- [x] Review current skills → [RDR-019](docs/research/RDR-019-skill-review.md) (Partially Adopted: merge janitor into tech-debt, polish architecture)
- [x] Create a skill for creating makefiles → [makefile skill](.github/skills/makefile/SKILL.md)
- [x] Add design skill → [RDR-020](docs/research/RDR-020-design-skill.md) (Adopted: created [design skill](.github/skills/design/SKILL.md))
- [x] [agno-framework](https://www.agno.com/) → [RDR-021](docs/research/archive/RDR-021-agno.md) (Rejected: Python runtime framework, not IDE-based AI instructions)
- [x] [six-tips-agents](https://steve-yegge.medium.com/six-new-tips-for-better-coding-with-agents-d4e9c86e42a9) → [RDR-022](docs/research/RDR-022-six-tips-agents.md) ⭐ (Partially Adopted: 40% code health rule, Rule of Five multi-pass review)
- [x] [ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) → [RDR-023](docs/research/RDR-023-ralph-wiggum.md) ⭐ (Partially Adopted: reinforces subagent fan-out, disposable plans, backpressure principle; rejects autonomous bash loop)
- [x] [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) → [RDR-024](docs/research/RDR-024-claude-code-mastery.md) (Partially Adopted: reinforces single-purpose chat principle, hooks vs instructions distinction; Claude Code-specific features out of scope)
- [x] [copilot-memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) → [RDR-025](docs/research/RDR-025-copilot-memory.md) ⭐ (Partially Adopted: Learned Patterns in AGENTS.md, staleness warnings, pattern learning in Implement/Explore agents)
- [x] [MetaPrompts](https://github.com/JBurlison/MetaPrompts) → [RDR-026](docs/research/RDR-026-metaprompts.md) (Rejected: meta-agent for creating agents; confirms our approach but no changes needed)
- [x] Utilizing skills in agents to empower existing agents with extra firepower for targeted tasks → [RDR-027](docs/research/RDR-027-skill-subagents.md) ⭐ (Adopted: skill-powered subagents pattern in prevailing-wisdom.md)
- [ ] supplement existing design skill: https://github.com/Dammyjay93/interface-design
- [ ] add support to Cursor, as it now supports skills as well https://cursor.com/changelog/2-4
- [ ] https://github.com/pcvelz/superpowers
- [ ] see which skills here might be worth adopting (or augmenting existing ones) https://skills.sh/
- [ ] Rename explore back to research to avoid conflicts with CC?
