# AGENTS

> **A**I-**G**uided **E**ngineering — **N**avigate → **T**hink → **S**hip

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![GitHub Discussions](https://img.shields.io/github/discussions/mcouthon/agents)](https://github.com/mcouthon/agents/discussions)

A minimal framework for AI-assisted coding with phase-based workflows, auto-activating skills, and enforced tool safety. Works with **VS Code Copilot** and **Claude Code**.

---

## What You Get

| Component        | Count | What It Does                                                                |
| ---------------- | ----- | --------------------------------------------------------------------------- |
| **Agents**       | 7     | Phase-based workflow with orchestration (4 core + Orchestrate + 2 internal) |
| **Skills**       | 11    | Auto-activate based on your prompts (debug, mentor, architecture, etc.)     |
| **Instructions** | 5     | File-type coding standards that load automatically                          |

```bash
git clone https://github.com/mcouthon/agents.git
cd agents
./install.sh    # Works out of the box — generated files are committed to git
```

> **Modifying templates?** Run `make` first to regenerate output files, then `./install.sh`.

That's it. Use `/agent` or the Chat menu to select agents, or just talk naturally and let skills auto-activate.

---

## The Core Insight

> "The highest leverage point is at the end of research and the beginning of the plan. A human can skim 30 seconds and provide feedback that saves hours of incorrect implementation."

This framework is built around that insight. The **Explore** agent is read-only—it can't accidentally edit your code. You review its research and plan, then hand off to **Implement** when you're ready.

---

## The Workflow

**Manual workflow** (use agents directly):

```
Explore ──→ Implement ──→ Review ──→ Commit
               │            │
               │            └──→ Fix Issues ──→ (back to Implement)
               │
               └──→ Commit (skip review for small changes)
```

**Orchestrated workflow** (use `@Orchestrate`):

```
┌─────────────────────────────────────────────────────────────┐
│            ORCHESTRATE (conductor agent)                    │
│  Task → For each phase: Plan → Review → Implement → Commit  │
└───────────┬───────────────────────────────────────────┬─────┘
            ↓                                           ↓
        Explore ──→ Implement ──→ Review ──→ Commit
```

Orchestrate automates multi-phase workflows with pause points for user approval.

| Agent           | Purpose                       | Tool Access       | Key Handoffs               |
| --------------- | ----------------------------- | ----------------- | -------------------------- |
| **Orchestrate** | Automate multi-phase workflow | Read + Agent      | (coordinates other agents) |
| **Explore**     | Research + create plans       | Read + Task Write | Implement                  |
| **Implement**   | Execute planned changes       | Full access       | Review, Commit             |
| **Review**      | Verify implementation quality | Read + Test       | Commit Changes, Fix Issues |
| **Commit**      | Create semantic commits       | Git + Read        | Push                       |

**Internal agents (not user-invokable):** Research (read + web), Worker (full access) — used by other agents for context-isolated subtasks.

**Task Write**: Explore can only write to `.tasks/` directory—not your codebase.

**Automatic state persistence**: Explore saves research to `.tasks/[NNN]-[task-name]/` so you can resume across sessions. Tasks are numbered sequentially (001, 002, etc.) for chronological ordering.

**In-context actions**: Each agent has handoff buttons for common next steps that keep your chat history and context intact. To switch agents, just @ mention them (e.g., `@Implement` when ready to start coding).

### Handoff Buttons (In-Context Actions)

Each agent has buttons that trigger common next steps **without leaving your current chat context**:

| Agent           | Button            | Purpose                                   |
| --------------- | ----------------- | ----------------------------------------- |
| **Orchestrate** | Continue          | Proceed to next workflow step             |
|                 | Skip Phase        | Skip current phase, move to next          |
|                 | Implement Now     | Jump directly to implementation           |
| **Explore**     | Implement         | Hand off to Implement agent               |
|                 | Plan Next Phase   | Detailed plan for next unplanned phase    |
|                 | Re-explore        | Investigate further                       |
|                 | Show Plan         | Display phase status from task.md         |
|                 | Save              | Persist research to `.tasks/`             |
| **Implement**   | Review            | Hand off to Review agent                  |
|                 | Commit            | Hand off to Commit agent                  |
|                 | Check for Errors  | Run linting and type checks               |
|                 | Run Tests         | Execute the test suite                    |
| **Review**      | Commit Changes    | Hand off to Commit agent                  |
|                 | Fix Issues        | Hand off to Implement to address problems |
|                 | Re-review         | Check again after fixes are applied       |
|                 | Check Tests       | Run tests and verify they pass            |
| **Commit**      | Review Commits    | Show commits with git log                 |
|                 | Amend Last Commit | Amend the last commit with staged changes |
|                 | Push              | Push commits to remote                    |

**Key benefit**: These buttons keep your context and chat history. No reset, no re-explaining.

---

## Skills (Auto-Activate)

Skills activate automatically based on what you say:

| You Say                     | Skill Activated   |
| --------------------------- | ----------------- |
| "This test is failing"      | `debug`           |
| "Find code smells"          | `tech-debt`       |
| "Clean up dead code"        | `tech-debt`       |
| "Document the architecture" | `architecture`    |
| "Teach me how this works"   | `mentor`          |
| "Challenge my approach"     | `critic`          |
| "Create a Makefile"         | `makefile`        |
| "Build a dashboard UI"      | `design`          |
| "Security review this PR"   | `security-review` |

No manual switching required—just ask naturally.

---

## What AGENTS Is / Isn't

| AGENTS Is                       | AGENTS Isn't                 |
| ------------------------------- | ---------------------------- |
| Advisory guidance               | Mandatory enforcement        |
| Phase-based workflow            | Magic one-shot agent         |
| Minimal and composable          | Batteries-included framework |
| IDE-agnostic patterns           | Cursor/Claude-specific       |
| Human-in-the-loop at key points | Fully autonomous             |

---

## Installation Details

Generated files are committed to git, so `./install.sh` works immediately after clone.

**For contributors modifying templates:**

```bash
make            # Regenerate generated/ from templates/
./install.sh    # Symlink generated files to home directories
```

After `./install.sh`:

| Component               | Installed To                                           |
| ----------------------- | ------------------------------------------------------ |
| Agents (VS Code)        | `~/.copilot/agents/`                                   |
| Instructions (VS Code)  | `~/.copilot/instructions/`                             |
| Instructions (IntelliJ) | `~/.config/github-copilot/intellij/`                   |
| Skills                  | `~/.copilot/skills/` (with `~/.claude/skills` symlink) |
| Agents (Claude Code)    | `~/.claude/agents/`                                    |
| Task state gitignore    | Added to global gitignore (`.tasks/`)                  |

**IntelliJ users:** Only global instructions are installed. Agents and skills require VS Code's agent discovery mechanism and tool restrictions, which IntelliJ doesn't support.

The installer also configures VS Code settings (`chat.agentFilesLocations`, `chat.instructionsFilesLocations`) to discover agents and instructions from these locations.

---

## Claude Code Usage

Agents are available as native subagents in Claude Code:

| Agent       | Purpose                 |
| ----------- | ----------------------- |
| `Explore`   | Research and plan       |
| `Implement` | Execute the plan        |
| `Review`    | Verify changes          |
| `Commit`    | Create semantic commits |

**Example workflow:**

```
$ claude
> use Explore to add user authentication

[Claude researches, produces plan]

> use Implement

[Claude implements based on conversation context]

> use Review

[Claude reviews changes]

> use Commit

[Claude creates commits]
```

**Note:** Claude Code supports tool restrictions, model selection, and skills. The only VS Code feature not available in Claude Code is handoff buttons — use the next agent manually when ready.

---

## Customization

### Adding an Agent

Create `templates/agents/my-agent.template.md` (see [templates/README.md](templates/README.md) for format), then:

```bash
make            # Regenerate generated/ from templates/
./install.sh    # Install locally
```

### Adding a Skill

Create `templates/skills/my-skill/SKILL.template.md` (see [templates/README.md](templates/README.md) for format), then:

```bash
make && ./install.sh
```

### Validating Skills (TDD for Documentation)

1. **RED** - Run task WITHOUT the skill, note failures
2. **GREEN** - Add skill, verify improvement
3. **REFACTOR** - If agent rationalizes around it, strengthen guidance

> If you didn't see it fail without the skill, you don't know if the skill helps.

Run `make && ./install.sh` after adding agents or skills.

---

## Task Continuity

Explore persists state to `.tasks/[NNN]-[task-name]/`:

```
.tasks/001-add-auth/
  task.md                      # Research + phases + main plan
  plan/
    phase-1-config.md          # Detailed plan for phase 1 (optional)
    phase-2-user-model.md      # Detailed plan for phase 2 (optional)
```

### Phase-Based Workflow

1. **Initial research** → `task.md` with research findings + phase table
2. **Plan Next Phase** (optional) → detailed plan for complex phases → `plan/phase-N-[name].md`
3. **Implement** → picks smallest planned unit (phase plan if exists, else task.md)
4. Mark phase ✅ Done, repeat

| Agent         | Reads                   | Updates                              |
| ------------- | ----------------------- | ------------------------------------ |
| **Explore**   | `task.md`, `plan/*.md`  | `task.md`, `plan/*.md`, phase status |
| **Implement** | Phase plan or `task.md` | Phase status (⬜→📋→🔄→✅)           |
| **Review**    | All plan + implement    | —                                    |

**To continue a task**: Just say "Continue working on [task-name]"

---

## Agents vs Skills

| Use Case                          | Use       |
| --------------------------------- | --------- |
| Need enforced tool restrictions   | **Agent** |
| Need handoffs between phases      | **Agent** |
| Want auto-activation from prompts | **Skill** |
| Role-based workflow phases        | **Agent** |
| Specialized methodologies         | **Skill** |

---

## File Structure

```
templates/                # SOURCE OF TRUTH — edit these
├── agents/               #   7 agent templates
├── skills/               #   11 skill templates
└── instructions/         #   5 instruction templates

generated/                # GENERATED — do not edit
├── copilot/              #   Copilot output
│   ├── agents/           #     Agent files
│   ├── skills/           #     Skill files
│   └── instructions/     #     Instruction files
└── claude/               #   Claude Code output
    ├── agents/           #     CC subagent files
    ├── skills/           #     CC skill files
    └── rules/            #     CC rule files

scripts/
├── generate.js           # Bidirectional template generator
└── configure-vscode-settings.js

Makefile                  # Build targets: make [copilot|cc|all|validate]
install.sh                # Symlinks generated files to ~/.copilot/ and ~/.claude/

docs/
├── synthesis/        # Core principles and framework analysis
└── research/         # Research Decision Records (RDRs)
```

---

## Troubleshooting

**Skills not auto-activating?**

1. Run `make && ./install.sh` to ensure generated files and symlinks exist
2. Check `~/.copilot/skills/` for your skills
3. Be more explicit: "Use debug mode to investigate..."

**Generated files out of date?**

```bash
make validate   # Check if generated files match templates
make            # Regenerate if needed
```

**Need to uninstall?**

```bash
./install.sh uninstall
```

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Quick ways to contribute:**

- 🐛 [Report a bug](https://github.com/mcouthon/agents/issues/new?template=bug_report.md)
- 💡 [Request a feature](https://github.com/mcouthon/agents/issues/new?template=feature_request.md)
- 🎯 [Share your skill](https://github.com/mcouthon/agents/issues/new?template=share_skill.md)
- 🤖 [Share your agent](https://github.com/mcouthon/agents/issues/new?template=share_agent.md)

---

## Further Reading

| Topic                       | Document                                                              |
| --------------------------- | --------------------------------------------------------------------- |
| Core principles             | [prevailing-wisdom.md](./docs/synthesis/prevailing-wisdom.md)         |
| Framework analysis          | [framework-comparison.md](./docs/synthesis/framework-comparison.md)   |
| Memory & session continuity | [memory-and-continuity.md](./docs/synthesis/memory-and-continuity.md) |
| Research decisions          | [docs/research/](./docs/research/)                                    |
| 12-Factor Agents            | [docs/sources/12-factor-agents/](./docs/sources/12-factor-agents/)    |

---

## Why This Exists

Synthesized from multiple frameworks into something minimal and useful:

- [12 Factor Agents](./docs/sources/12-factor-agents/) — Control flow ownership
- [HumanLayer ACE](./docs/sources/humanlayer/) — Context engineering, human leverage points
- [CursorRIPER](./docs/sources/cursorriper/) — Permission boundaries
- [Superpowers](https://github.com/obra/superpowers) — Skill quality, TDD for documentation
- [Awesome Copilot](./docs/sources/awesome-copilot/) — Agent and instruction patterns

> **Model recommendation:** Claude Opus 4.5 for heavy lifting. When Sonnet struggles, Opus delivers.
