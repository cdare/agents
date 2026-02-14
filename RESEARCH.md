# 🔬 Deep Research

**Mission:** Continuously improve the AGENTS framework by learning from external sources, adopting what works, and keeping our patterns current.

## ⚠️ One Item Per Session

**Process exactly ONE research item per session.** When that item is complete (RDR written, synthesis updated if adopting), stop. Do not pick up another item.

Why: Deep research > shallow coverage. Each item deserves full attention.

---

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

### 3. Discuss & Decide

Present findings to user before making any decision:

1. **Summary**: What the source contains and key insights
2. **Relevance**: How it relates to our current agents/skills/patterns
3. **Recommendation**: Adopt / Partially Adopt / Reject, with specific rationale
4. **If adopting**: What concrete changes would be made

**Wait for user agreement before proceeding.** The user may:

- Ask clarifying questions
- Suggest a different adoption approach
- Request deeper investigation of specific aspects
- Agree to proceed

Only after explicit agreement, move to step 4 (Document Decision).

### 4. Document Decision

Create RDR using [template](./docs/research/TEMPLATE.md) (~50 lines). Mark with ⭐ if high-impact.

### 5. Synthesize (if adopting)

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

---

**⚠️ Remember: Pick ONE unchecked item below. Complete it fully before stopping.**

## Research List

- [x] [spec-driven-development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) → [RDR-001](docs/research/archive/RDR-001-spec-driven.md)
- [x] [copilot-context-cortex](https://github.com/muaz742/copilot-context-cortex) → [RDR-002](docs/research/archive/RDR-002-context-cortex.md)
- [x] [feature-dev-plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev) → [RDR-003](docs/research/archive/RDR-003-feature-dev.md) (consolidated → [external-patterns.md](docs/research/external-patterns.md))
- [x] [superpowers](https://github.com/obra/superpowers) → [RDR-004](docs/research/archive/RDR-004-superpowers.md) (consolidated → [skills-methodology.md](docs/research/skills-methodology.md))
- [x] [beads-memory](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) → [RDR-005](docs/research/RDR-005-beads.md)
- [x] [agentic-future](https://seconds0.substack.com/p/heres-whats-next-in-agentic-coding) → [RDR-006](docs/research/archive/RDR-006-agentic-future.md)
- [x] [mitsuhiko-agent-stuff](https://github.com/mitsuhiko/agent-stuff/blob/main/skills/improve-skill/SKILL.md) → [RDR-007](docs/research/archive/RDR-007-mitsuhiko-agent-stuff.md)
- [x] Building my own tools for memory (MCP servers) → [RDR-009](docs/research/archive/RDR-009-mcp-memory-rejected.md) (Rejected)
- [x] Create guidelines for plan file artifacts → Resolved: Use Research → Handoff workflow (documented in [README](README.md#the-workflow))
- [x] Combine Research + Plan agents → [RDR-016](docs/research/archive/RDR-016-agent-consolidation.md) ⭐ (Adopted: consolidated into Explore agent, reversing previous rejection)
- [x] Research whether Copilot subagents in VSCode fork the context, and start with a clean context. What of the main agent's context is being passed to those subagents? → [RDR-010](docs/research/archive/RDR-010-subagents-context-fork.md) (consolidated → [context-management.md](docs/research/context-management.md))
- [x] [planning-with-files](https://github.com/OthmanAdi/planning-with-files) → [RDR-012](docs/research/archive/RDR-012-planning-with-files.md) ⭐ (consolidated → [context-management.md](docs/research/context-management.md))
- [x] [vscode-browser-testing](https://code.visualstudio.com/docs/copilot/overview) → [RDR-013](docs/research/RDR-013-vscode-browser-testing.md)
- [x] [vscode-copilot-settings](https://code.visualstudio.com/docs/copilot/setup) → [RDR-014](docs/research/archive/RDR-014-vscode-copilot-settings.md) (consolidated → [vscode-platform.md](docs/research/vscode-platform.md))
- [x] [copilot-agent-tools](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) → [RDR-015](docs/research/archive/RDR-015-copilot-agent-tools.md) (consolidated → [vscode-platform.md](docs/research/vscode-platform.md))
- [x] Verify which parts of the agents specification follow are well defined (eg https://code.visualstudio.com/docs/copilot/customization/custom-agents), and whether they are compatible with Claude Code OOTB (including tool/model specifications) → [RDR-017](docs/research/archive/RDR-017-agent-spec-compatibility.md) (consolidated → [ide-compatibility.md](docs/research/ide-compatibility.md))
- [x] Improve testing of agents, including making sure the install.sh script works, and that we're properly testing Claude Code related configurations
- [x] Find opportunities to trim down agents (mainly explore and implement)
- [x] [vscode-1.108-skills](https://code.visualstudio.com/updates/v1_108) → [RDR-014](docs/research/archive/RDR-014-vscode-copilot-settings.md) (consolidated → [vscode-platform.md](docs/research/vscode-platform.md))
- [x] Review current skills → [RDR-019](docs/research/archive/RDR-019-skill-review.md) (consolidated → [skills-methodology.md](docs/research/skills-methodology.md))
- [x] Create a skill for creating makefiles → [makefile skill](.github/skills/makefile/SKILL.md)
- [x] Add design skill → [RDR-020](docs/research/RDR-020-design-skill.md) (Adopted: created [design skill](.github/skills/design/SKILL.md))
- [x] [agno-framework](https://www.agno.com/) → [RDR-021](docs/research/archive/RDR-021-agno.md) (Rejected: Python runtime framework, not IDE-based AI instructions)
- [x] [six-tips-agents](https://steve-yegge.medium.com/six-new-tips-for-better-coding-with-agents-d4e9c86e42a9) → [RDR-022](docs/research/archive/RDR-022-six-tips-agents.md) ⭐ (consolidated → [external-patterns.md](docs/research/external-patterns.md))
- [x] [ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) → [RDR-023](docs/research/archive/RDR-023-ralph-wiggum.md) ⭐ (consolidated → [external-patterns.md](docs/research/external-patterns.md))
- [x] [claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) → [RDR-024](docs/research/archive/RDR-024-claude-code-mastery.md) (consolidated → [external-patterns.md](docs/research/external-patterns.md))
- [x] [copilot-memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) → [RDR-025](docs/research/archive/RDR-025-copilot-memory.md) ⭐ (consolidated → [context-management.md](docs/research/context-management.md))
- [x] [MetaPrompts](https://github.com/JBurlison/MetaPrompts) → [RDR-026](docs/research/archive/RDR-026-metaprompts.md) (Rejected: confirms existing approach)
- [x] Utilizing skills in agents to empower existing agents with extra firepower for targeted tasks → [RDR-027](docs/research/archive/RDR-027-skill-subagents.md) ⭐ (consolidated → [skills-methodology.md](docs/research/skills-methodology.md))
- [x] [skills.sh](https://skills.sh/) ecosystem review → [RDR-028](docs/research/archive/RDR-028-skills-sh.md) (consolidated → [skills-methodology.md](docs/research/skills-methodology.md))
- [x] [cursor-2.4](https://cursor.com/changelog/2-4) → [RDR-029](docs/research/archive/RDR-029-alternative-ide-support.md) (consolidated → [ide-compatibility.md](docs/research/ide-compatibility.md))
- [x] [vercel-agents-md-evals](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) → [RDR-030](docs/research/RDR-030-vercel-agents-md-evals.md) (Partially Adopted: retrieval-over-recall principle, horizontal vs vertical context distinction)
- [x] New changes in VSCode copilot https://code.visualstudio.com/updates/v1_109 → [RDR-031](docs/research/archive/RDR-031-vscode-1109-orchestration.md) (consolidated → [vscode-platform.md](docs/research/vscode-platform.md))
- [x] https://github.com/bigguy345/Github-Copilot-Atlas → [RDR-032](docs/research/RDR-032-atlas-orchestra.md) (Partially Adopted: context conservation guidance, TDD enforcement)
- [x] https://github.com/ShepAlderson/copilot-orchestra → [RDR-032](docs/research/RDR-032-atlas-orchestra.md) (Partially Adopted: combined with Atlas research)
- [ ] https://github.blog/changelog/2026-01-15-agentic-memory-for-github-copilot-is-in-public-preview/
- [ ] https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents
- [ ] consider whether we need to supplement the existing design skill: https://github.com/Dammyjay93/interface-design or https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- [] https://allenai.org/blog/open-coding-agents
- [ ] https://github.com/pcvelz/superpowers
- [ ] Rename explore back to research to avoid conflicts with CC?
- https://www.reddit.com/r/GithubCopilot/s/qxQCZ0cP4S
