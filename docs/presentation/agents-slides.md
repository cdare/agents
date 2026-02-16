---
marp: true
theme: default
class: invert
paginate: true
footer: "AGENTS Framework | github.com/mcouthon/agents"
style: |
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Space+Grotesk:wght@500;700&family=JetBrains+Mono:wght@400;500&display=swap');

  :root {
    --coral: #FFB5A7;
    --lavender: #CDB4DB;
    --mint: #A8E6CF;
    --butter: #FFF3B0;
    --sky: #A7C7E7;
    --rose: #F8C8DC;
    --card-bg: #1e1e32;
    --deep-bg: #16162a;
  }

  section {
    font-size: 28px;
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
    letter-spacing: -0.01em;
    line-height: 1.6;
  }

  h1 {
    font-size: 54px;
    font-weight: 700;
    font-family: 'Space Grotesk', sans-serif;
    color: var(--coral);
    letter-spacing: -0.03em;
    text-shadow: 0 0 40px rgba(255, 181, 167, 0.3);
  }

  h2 {
    font-size: 38px;
    font-weight: 500;
    font-family: 'Space Grotesk', sans-serif;
    color: var(--lavender);
  }

  h3 {
    color: var(--butter);
    font-family: 'Space Grotesk', sans-serif;
    font-weight: 500;
  }

  table {
    font-size: 21px;
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    border-radius: 12px;
    overflow: hidden;
  }

  th {
    background: linear-gradient(135deg, var(--deep-bg), var(--card-bg));
    color: var(--sky);
    font-weight: 600;
    padding: 0.8em 1em;
  }

  td {
    border-color: #2a2a4a;
    padding: 0.6em 1em;
  }

  tr:nth-child(even) {
    background: rgba(30, 30, 50, 0.5);
  }

  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5em;
  }

  .columns > div:first-child {
    background: linear-gradient(135deg, var(--card-bg), rgba(255, 181, 167, 0.08));
    padding: 1.2em;
    border-radius: 16px;
    border-left: 4px solid var(--coral);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }

  .columns > div:last-child {
    background: linear-gradient(135deg, var(--card-bg), rgba(167, 199, 231, 0.08));
    padding: 1.2em;
    border-radius: 16px;
    border-left: 4px solid var(--sky);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }

  blockquote {
    border-left: 4px solid var(--rose);
    padding: 0.8em 1.2em;
    font-style: italic;
    font-size: 32px;
    background: linear-gradient(135deg, var(--card-bg), rgba(248, 200, 220, 0.1));
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  }

  strong {
    color: var(--mint);
    font-weight: 600;
  }

  code {
    font-family: 'JetBrains Mono', monospace;
    background: var(--card-bg);
    border-radius: 6px;
    padding: 0.15em 0.4em;
    font-size: 0.85em;
    color: var(--butter);
  }

  pre {
    font-family: 'JetBrains Mono', monospace;
    background: linear-gradient(135deg, var(--deep-bg), var(--card-bg));
    border-radius: 16px;
    padding: 1.2em;
    border: 1px solid #2a2a4a;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }

  pre code {
    background: transparent;
    padding: 0;
  }

  a {
    color: var(--sky);
    text-decoration: underline;
    text-decoration-color: rgba(167, 199, 231, 0.4);
    text-underline-offset: 3px;
  }

  a:hover {
    color: var(--lavender);
  }

  em {
    color: var(--rose);
    font-style: italic;
  }

  footer {
    color: #555;
    font-size: 13px;
    font-family: 'Inter', sans-serif;
  }

  /* Flow diagram styles */
  .flow-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1em;
    margin: 1em 0;
  }

  .orchestrate-box {
    background: linear-gradient(135deg, var(--card-bg), rgba(205, 180, 219, 0.15));
    border: 2px solid var(--lavender);
    border-radius: 16px;
    padding: 1em 2em;
    text-align: center;
    width: 80%;
    box-shadow: 0 4px 20px rgba(205, 180, 219, 0.2);
  }

  .orchestrate-title {
    font-family: 'Space Grotesk', sans-serif;
    font-size: 24px;
    color: var(--lavender);
    margin-bottom: 0.3em;
  }

  .orchestrate-phases {
    color: #aaa;
    font-size: 18px;
  }

  .flow-arrow {
    color: var(--lavender);
    font-size: 24px;
  }

  .agent-flow {
    display: flex;
    align-items: center;
    gap: 0.8em;
    flex-wrap: wrap;
    justify-content: center;
  }

  .agent-box {
    background: var(--card-bg);
    border-radius: 12px;
    padding: 0.8em 1em;
    text-align: center;
    min-width: 100px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  }

  .agent-box.explore {
    border: 2px solid var(--coral);
  }

  .agent-box.implement {
    border: 2px solid var(--mint);
  }

  .agent-box.review {
    border: 2px solid var(--sky);
  }

  .agent-box.commit {
    border: 2px solid var(--butter);
  }

  .agent-name {
    font-family: 'Space Grotesk', sans-serif;
    font-size: 16px;
    margin-bottom: 0.2em;
  }

  .agent-box.explore .agent-name { color: var(--coral); }
  .agent-box.implement .agent-name { color: var(--mint); }
  .agent-box.review .agent-name { color: var(--sky); }
  .agent-box.commit .agent-name { color: var(--butter); }

  .agent-desc {
    font-size: 12px;
    color: #888;
  }

  .checkpoint {
    font-size: 20px;
  }

  .arrow {
    color: #666;
    font-size: 18px;
  }

  .legend {
    margin-top: 1em;
    font-size: 18px;
    color: #aaa;
  }

  .legend span {
    color: var(--rose);
    font-weight: 600;
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

<div class="flow-container">
  <div class="orchestrate-box">
    <div class="orchestrate-title">🎭 ORCHESTRATE</div>
    <div class="orchestrate-phases">Task → Phase 1 → Phase 2 → …</div>
  </div>
  <div class="flow-arrow">↓</div>
  <div class="agent-flow">
    <div class="agent-box explore">
      <div class="agent-name">📖 Explore</div>
      <div class="agent-desc">read-only</div>
    </div>
    <span class="checkpoint">✋</span>
    <span class="arrow">→</span>
    <div class="agent-box implement">
      <div class="agent-name">⚡ Implement</div>
      <div class="agent-desc">full access</div>
    </div>
    <span class="checkpoint">✋</span>
    <span class="arrow">→</span>
    <div class="agent-box review">
      <div class="agent-name">🔍 Review</div>
      <div class="agent-desc">run tests</div>
    </div>
    <span class="arrow">→</span>
    <div class="agent-box commit">
      <div class="agent-name">📝 Commit</div>
      <div class="agent-desc">git only</div>
    </div>
  </div>
  <div class="legend">✋ = <span>Human checkpoint</span> — plan review, phase-review, implementation approval</div>
</div>

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
