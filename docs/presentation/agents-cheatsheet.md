# AGENTS Quick Reference

**AI-Guided Engineering — Navigate → Think → Ship**

github.com/mcouthon/agents

---

## The Agents

| Agent       | What It Does                  | Tool Access       |
| ----------- | ----------------------------- | ----------------- |
| Orchestrate | Coordinates multi-phase tasks | Read + Agent      |
| Explore     | Research + create plans       | Read + Task Write |
| Implement   | Execute planned changes       | Full access       |
| Review      | Verify quality, run tests     | Read + Test       |
| Commit      | Create semantic commits       | Git + Read        |
| Research    | Context-isolated reading      | Read + Web        |
| Worker      | Context-isolated changes      | Full access       |

**Note**: Research and Worker are internal (not user-invokable).

---

## The Workflow

```
Explore → [Human Review] → Implement → Review → Commit
```

**Orchestrated flow:**

```
Orchestrate: Task → Phase 1 → Phase 2 → ...
Each phase: Explore (read-only) → ✋ → Implement (full) → Review → Commit
```

---

## Skills (Auto-Activate)

| Trigger Phrase                  | Skill              |
| ------------------------------- | ------------------ |
| "This is broken", "debug"       | `debug`            |
| "Find code smells", "tech debt" | `tech-debt`        |
| "Document the architecture"     | `architecture`     |
| "Teach me", "guide me"          | `mentor`           |
| "Challenge this", "find flaws"  | `critic`           |
| "Security review", "audit"      | `security-review`  |
| "Build a dashboard UI"          | `design`           |
| "Create a Makefile"             | `makefile`         |
| "Exhaustive investigation"      | `deep-research`    |
| "Review phase plan"             | `phase-review`     |
| "Summarize completed task"      | `consolidate-task` |

**Auto-activation**: No manual switching—just ask naturally.

---

## .tasks/ Structure

```
.tasks/
  [NNN]-[task-slug]/
    task.md            # Research + phases + plan
    plan/
      phase-1-....md   # Detailed phase plans
      phase-2-....md
```

**Resume**: "Continue working on [task-name]"

---

## Installation

```bash
git clone https://github.com/mcouthon/agents.git
cd agents
./install.sh
```

**Uninstall**: `./install.sh uninstall`

---

## Key Commands

| IDE             | Invoke Agent                               |
| --------------- | ------------------------------------------ |
| VS Code Copilot | `@Orchestrate`, `@Explore`, etc.           |
| Claude Code     | `@agent-Explore`, `@agent-Implement`, etc. |

**Common workflows:**

- New task: `@Explore [describe task]`
- Multi-phase: `@Orchestrate [describe task]`
- Resume: `@Explore Continue working on [task-name]`

---

## Links

- **GitHub**: github.com/mcouthon/agents
- **Documentation**: `docs/synthesis/prevailing-wisdom.md`
- **Discussions**: GitHub Discussions for questions
