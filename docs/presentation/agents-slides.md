---
marp: true
theme: default
class: invert
paginate: true
footer: "AGENTS Framework | github.com/mcouthon/agents"
style: |
  section {
    font-size: 30px;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    letter-spacing: -0.02em;
  }
  h1 {
    font-size: 52px;
    font-weight: 800;
    color: #7ecfc0;
    letter-spacing: -0.03em;
  }
  h2 {
    font-size: 36px;
    font-weight: 700;
    color: #7ecfc0;
  }
  table {
    font-size: 22px;
    width: 100%;
  }
  th {
    background: #1a1a2e;
    color: #7ecfc0;
    font-weight: 700;
  }
  td {
    border-color: #333;
  }
  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2em;
  }
  .columns div {
    background: #1a1a2e;
    padding: 1.2em;
    border-radius: 12px;
    border-left: 4px solid #7ecfc0;
  }
  blockquote {
    border-left: 4px solid #7ecfc0;
    padding: 0.8em 1em;
    font-style: italic;
    font-size: 34px;
    background: #1a1a2e;
    border-radius: 8px;
  }
  strong {
    color: #7ecfc0;
  }
  code {
    background: #1a1a2e;
    border-radius: 4px;
    padding: 0.1em 0.3em;
    font-size: 0.9em;
  }
  pre {
    background: #1a1a2e;
    border-radius: 12px;
    padding: 1em;
  }
  a {
    color: #7ecfc0;
  }
  footer {
    color: #666;
    font-size: 14px;
  }
---

<!-- _footer: "" -->
<!-- _paginate: false -->

# AGENTS

**AI-Guided Engineering — Navigate → Think → Ship**

A minimal framework for AI-assisted coding with phase-based workflows, auto-activating skills, and enforced tool safety.

_Works with VS Code Copilot and Claude Code\*_

<!--
Welcome, introduce yourself briefly.
"AGENTS is a framework I built to make AI coding assistants more reliable."
"The name is a backronym: AI-Guided Engineering — Navigate, Think, Ship."
"Today I'll show you the core insight, how it works, and a live demo."
-->

---

# The Problem with AI Coding Agents

<div class="columns">
<div>

### 🧠 Context Bloat

Agents consume the entire context window with no management

### 🎯 Goal Drift

After 50+ tool calls, the original goal is forgotten

</div>
<div>

### ⚡ Jumping to Code

Implementing the wrong thing, fast

### 💾 No Memory

Every session starts completely from scratch

</div>
</div>

<!--
"These are problems I hit repeatedly with Copilot and Claude"
Context bloat: "Agent reads 50 files, then can't reason about them"
Goal drift: "Lost in the middle effect — starts strong, loses track"
Jumping to code: "Most costly mistake — implementing the wrong thing fast"
No memory: "Every session starts from scratch"
-->

---

# The Core Insight

> "The highest leverage point is at the end of research and the beginning of the plan. A human can skim 30 seconds and provide feedback that saves hours of incorrect implementation."

**Explore is read-only.** Review the plan. Then hand off to Implement.

<!--
"This is the central thesis of the framework"
"Bad plans become bad code — intervene early"
"Read-only constraint is enforced via tool restrictions, not just instructions"
"Human reviews the plan in 30 seconds, catches issues before implementation"
This quote is from the HumanLayer ACE framework research
-->

---

# The Agents

| Agent           | Purpose                       | Tool Access       |
| --------------- | ----------------------------- | ----------------- |
| **Orchestrate** | Automate multi-phase workflow | Read + Agent      |
| **Explore**     | Research + create plans       | Read + Task Write |
| **Implement**   | Execute planned changes       | Full access       |
| **Review**      | Verify implementation quality | Read + Test       |
| **Commit**      | Create semantic commits       | Git + Read        |

**Task Write**: Explore can only write to `.tasks/` directory — not your codebase.

**Internal agents** (not user-invokable): Research, Worker — used for context-isolated subtasks.

<!--
"5 user-facing agents, 2 internal"
Orchestrate: "The conductor — coordinates the others"
Explore: "The researcher — read-only, saves to .tasks/"
Implement: "The workhorse — full access, does the coding"
Review: "Quality gate — runs tests, checks for issues"
Commit: "Clean commits — semantic messages, atomic changes"
"Tool restrictions are enforced at platform level, not just advisory"
-->

---

# Orchestration Flow

<!-- _footer: "" -->

<pre style="font-size: 18px; line-height: 1.5; color: #7ecfc0;">
  ┌─────────────────────────────────────────────────────────┐
  │              🎭  O R C H E S T R A T E                       │
  │         Task  →  Phase 1  →  Phase 2  →  …                   │
  └──────────────────────┬──────────────────────────────────┘
                         │
     ┌───────────┐  ✋  ┌───────────┐  ✋  ┌────────┐
     │ 📖 Explore ├────▶│⚡Implement├────▶│🔍Review├──▶ 📝 Commit
     │ read-only │     │full access│     │run tests│
     └───────────┘     └───────────┘     └────────┘
</pre>

✋ = **Human checkpoint** — plan review, phase-review, implementation approval

<!--
"Orchestrate is the conductor — it doesn't do work, just coordinates"
"Notice the human review checkpoints — this is the leverage point"
"For each phase: Explore researches, human reviews, Implement executes"
"You can also use agents manually without Orchestrate"
"The key is: agent proposes, human disposes"
-->

---

# Skills — Just Ask Naturally

| You Say                     | Skill Activated   |
| --------------------------- | ----------------- |
| "This test is failing"      | `debug`           |
| "Find code smells"          | `tech-debt`       |
| "Document the architecture" | `architecture`    |
| "Teach me how this works"   | `mentor`          |
| "Challenge my approach"     | `critic`          |
| "Security review this PR"   | `security-review` |

**No manual switching** — 11 skills activate based on natural language triggers.

Skills provide specialized workflows: hypothesis-driven debugging, Socratic teaching, adversarial probing.

<!--
"Skills are different from agents — they auto-activate based on what you say"
"No need to remember commands or switch modes"
"debug: systematic hypothesis testing, not random changes"
"mentor: teaches through questions, not answers"
"critic: challenges assumptions, finds edge cases"
"11 skills total — debug, tech-debt, architecture, mentor, critic, security-review, design, makefile, deep-research, phase-review, consolidate-task"
-->

---

# .tasks/ — Your AI's Memory

```
.tasks/
    001-add-auth/
        task.md            # Research + phases + plan
        plan/
            phase-1.md     # Detailed phase plan
            phase-2.md
    002-refactor-api/
        task.md
```

**Resume any session** — "Continue working on add-auth"
**Plain markdown** — human-readable, version-controlled

<!--
"This solves the memory problem"
"Everything Explore learns is saved to .tasks/"
"Numbered for chronological ordering"
"Plain markdown — you can read it, version it, share it"
"To resume: just mention the task name"
"Added to global gitignore — won't pollute your repo"
-->

---

# What Makes AGENTS Different

| AGENTS Is                       | AGENTS Isn't                 |
| ------------------------------- | ---------------------------- |
| Advisory guidance               | Mandatory enforcement        |
| Phase-based workflow            | Magic one-shot agent         |
| Minimal and composable          | Batteries-included framework |
| IDE-agnostic patterns           | Cursor/Claude-specific       |
| Human-in-the-loop at key points | Fully autonomous             |

> Synthesized from: 12-Factor Agents · HumanLayer ACE · CursorRIPER · Superpowers · Anthropic Feature-Dev

<!--
"Advisory: LLMs are probabilistic, instructions are guidance not guarantees"
"Phase-based: research → plan → implement → review — not magic"
"Minimal: ~500 lines of markdown, no runtime dependencies"
"IDE-agnostic: works with VS Code Copilot and Claude Code"
"Human-in-the-loop: you review plans, not just final code"
"Built on research from 5+ frameworks — took the best patterns"
-->

---

<!-- _footer: "" -->

# <!-- fit --> 🎬 DEMO

<!--
"Now let's see it in action"
"I'll give a real task to @Orchestrate and we'll watch the full flow"
"Watch for: read-only Explore, .tasks/ persistence, human checkpoints, handoff buttons"
-->

---

<!-- _footer: "" -->
<!-- _paginate: false -->

# Getting Started

```bash
git clone https://github.com/mcouthon/agents.git
cd agents
./install.sh
```

## github.com/mcouthon/agents

Star it ⭐ · Try it · Break it · Improve it

**Questions?**

<!--
"Three commands and you're set up."
"Works with VS Code Copilot — just use @agent syntax."
"Works with Claude Code — use @agent-Explore etc."
"The install script sets up symlinks, won't pollute your config."
"If you want to uninstall: ./install.sh uninstall"
"I'm happy to answer questions."
-->
