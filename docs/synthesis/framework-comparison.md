# Framework Comparison Matrix

> **AGENTS**: AI-Guided Engineering — Navigate → Think → Ship

Detailed comparison of frameworks analyzed during research.

---

## Overview Comparison

| Aspect             | HumanLayer ACE                        | CursorRIPER                | 12-Factor Agents              | Superpowers                    | Beads                         | Manus/planning-with-files    | Ralph Wiggum                |
| ------------------ | ------------------------------------- | -------------------------- | ----------------------------- | ------------------------------ | ----------------------------- | ---------------------------- | --------------------------- |
| **Primary Focus**  | Context engineering for coding agents | Structured workflow modes  | Agent architecture principles | Skills-based TDD workflow      | Agent memory system           | Within-session goal tracking | Autonomous agent loops      |
| **Target IDE**     | IDE-agnostic (concepts)               | Cursor                     | IDE-agnostic (concepts)       | Claude Code                    | IDE-agnostic                  | Claude Code                  | Claude Code CLI             |
| **Workflow Model** | Research → Plan → Implement           | RIPER (5 modes)            | Flexible, principle-based     | Mandatory skill-driven         | Issue tracker metaphor        | 3-file pattern per task      | Bash loop, 1 task per iter  |
| **Key Innovation** | Frequent Intentional Compaction       | Permission matrix per mode | Control flow ownership        | TDD for skills, pressure tests | Structured queries over prose | Read-before-decide attention | Fresh context per iteration |
| **Human-in-Loop**  | At research/plan boundaries           | Mode transitions           | Tool-level interruption       | Skill enforcement              | N/A (memory, not workflow)    | N/A (within-session pattern) | Outside loop (observe/tune) |

---

## Workflow Modes Comparison

### ACE Framework

| Phase     | Purpose                        | Human Involvement               |
| --------- | ------------------------------ | ------------------------------- |
| Research  | Deep codebase understanding    | Review findings before planning |
| Plan      | Create implementation strategy | Approve plan before execution   |
| Implement | Execute planned changes        | Review completed work           |

### CursorRIPER Framework

| Mode     | Symbol | Purpose                | Permissions        |
| -------- | ------ | ---------------------- | ------------------ |
| Research | 🔍 R   | Information gathering  | Read only          |
| Innovate | 💡 I   | Brainstorm solutions   | Read only          |
| Plan     | 📝 P   | Create structured plan | Read + create docs |
| Execute  | ⚙️ E   | Implement changes      | Full access        |
| Review   | 🔎 RV  | Verify and validate    | Read + annotate    |

### 12-Factor (Implied Workflow)

| Principle                 | Workflow Impact                |
| ------------------------- | ------------------------------ |
| Own control flow          | Pause/resume at any point      |
| Launch/pause/resume       | Explicit state management      |
| Contact humans with tools | Interrupt for approval         |
| Small focused agents      | Break complex work into phases |

### Superpowers Framework

| Phase          | Purpose                     | Enforcement         |
| -------------- | --------------------------- | ------------------- |
| Brainstorming  | Design before code          | Mandatory via skill |
| Planning       | Structured implementation   | Mandatory via skill |
| Implementation | Execute with subagents      | Two-stage review    |
| Verification   | Confirm bugs actually fixed | Required evidence   |

**Key Difference from AGENTS**: Superpowers uses emphatic, mandatory language ("YOU MUST"); AGENTS uses advisory guidance.

### Beads Memory System

Not a workflow framework—a memory system using issue-tracker metaphor:

| Concept     | Description                                        |
| ----------- | -------------------------------------------------- |
| Issue Types | Epic → Story → Task → Defect with dependencies     |
| Storage     | `docs/issues/issues.jsonl` in git                  |
| Queries     | `bd ready --json` returns actionable items         |
| Key Insight | Structured data > prose plans for long-term memory |

**Status in AGENTS**: Future consideration for multi-week features.

### Manus/planning-with-files Pattern

Not a workflow framework—a within-session attention management pattern:

| Concept            | Description                                             |
| ------------------ | ------------------------------------------------------- |
| 3-File Pattern     | `task_plan.md`, `notes.md`, `[deliverable].md` per task |
| Read-Before-Decide | Re-read plan before major decisions                     |
| Attention Anchor   | Updating progress keeps goals in attention window       |
| Error Persistence  | Log failures in plan file for learning                  |
| Key Insight        | Periodic goal refresh combats "lost in the middle"      |

**Status in AGENTS**: Principle adopted (use todo list + re-read handoff), not the 3-file infrastructure.

---

## Context Management Comparison

| Aspect                  | ACE                   | RIPER              | 12-Factor                  |
| ----------------------- | --------------------- | ------------------ | -------------------------- |
| **Target Utilization**  | 40-60%                | Not specified      | Minimize bloat             |
| **Context Format**      | Custom (XML-like)     | Memory bank files  | Custom structured          |
| **Persistence**         | Per-phase files       | Memory bank system | Thread/state serialization |
| **Compaction Strategy** | Intentional summaries | Progress tracking  | Stateless reducer pattern  |

### Memory/State Approaches

**ACE: Phase-Based Files**

```
research_output.md → Plan input
plan.md → Implementation input
implementation_summary.md → Review input
```

**RIPER: Memory Bank System**

```
projectbrief.md      # Core requirements (rarely changes)
systemPatterns.md    # Established patterns
techContext.md       # Tech stack details
activeContext.md     # Current focus (frequently updated)
progress.md          # Task status tracking
```

**12-Factor: Unified State**

```python
thread = {
    "events": [...],  # All tool calls, results, decisions
    "status": "...",  # Current execution state
}
# Business state + execution state unified
```

---

## Tool Philosophy Comparison

| Aspect                   | ACE                     | RIPER             | 12-Factor                               |
| ------------------------ | ----------------------- | ----------------- | --------------------------------------- |
| **Tool Restrictions**    | Implied by phase        | Explicit per mode | None enforced                           |
| **Tool Call Philosophy** | Standard function calls | Permission-gated  | "Structured output, not function calls" |
| **Execution Control**    | Framework-managed       | Mode-managed      | Developer-owned                         |

### 12-Factor Tool Call Pattern

```python
# Tool call is just structured output
next_step = llm.determine_next_step(context)

# You control what happens
if next_step.function == 'high_stakes_action':
    approval = await human_review(next_step)
    if not approval:
        return

result = execute(next_step)  # Your code, your rules
```

---

## Protection/Safety Comparison

| Aspect              | ACE                 | RIPER                     | 12-Factor                     |
| ------------------- | ------------------- | ------------------------- | ----------------------------- |
| **Code Protection** | Not explicit        | Explicit levels (P/G/D/T) | Via human approval            |
| **Guardrails**      | Human review points | Permission matrix         | Own your control flow         |
| **Error Handling**  | Not specified       | Not specified             | Compact errors, limit retries |

### RIPER Protection Levels (Not Adopted)

RIPER uses comment-based protection markers. **AGENTS does not adopt this**—see [RDR-011](../research/archive/RDR-011-protection-markers-removed.md) for rationale (no actual usage, advisory-only, better alternatives via git/PRs).

| Level     | Marker | Meaning                                |
| --------- | ------ | -------------------------------------- |
| PROTECTED | `[P]`  | Never modify without explicit approval |
| GUARDED   | `[G]`  | Requires careful review before changes |
| DEBUG     | `[D]`  | Temporary, remove before merge         |
| TEST      | `[T]`  | Test code, modify freely               |

---

## Human Interaction Comparison

| Aspect                  | ACE                        | RIPER                   | 12-Factor               |
| ----------------------- | -------------------------- | ----------------------- | ----------------------- |
| **Primary Checkpoint**  | After research, after plan | Mode transitions        | Any tool call           |
| **Approval Mechanism**  | Human reviews summaries    | Human selects next mode | Tool-level interruption |
| **Communication Style** | Markdown summaries         | Mode-specific outputs   | Structured requests     |

### Best Practice Synthesis

1. **Always** get human approval after research findings
2. **Always** get human approval before executing a plan
3. **Optionally** require approval for high-stakes tool calls
4. **Never** require approval for read-only operations

---

## Strengths & Weaknesses

### HumanLayer ACE

| Strengths                                    | Weaknesses                              |
| -------------------------------------------- | --------------------------------------- |
| ✅ Excellent context management guidance     | ❌ Less specific implementation details |
| ✅ Clear human checkpoint philosophy         | ❌ Cursor-focused examples              |
| ✅ "Frequent Intentional Compaction" concept | ❌ No tool restriction patterns         |
| ✅ High-leverage human review points         |                                         |

### CursorRIPER

| Strengths                          | Weaknesses                            |
| ---------------------------------- | ------------------------------------- |
| ✅ Explicit permission matrix      | ❌ Cursor-specific (needs adaptation) |
| ✅ Memory bank persistence pattern | ❌ Complex mode system                |
| ⚪ Code protection markers         | ❌ Heavy upfront setup                |
| ✅ Clear mode transitions          |                                       |

> ⚪ = Evaluated but not adopted (see RDR-011)

### 12-Factor Agents

| Strengths                            | Weaknesses                          |
| ------------------------------------ | ----------------------------------- |
| ✅ Framework-agnostic principles     | ❌ More abstract, less prescriptive |
| ✅ Control flow ownership philosophy | ❌ Requires more custom code        |
| ✅ Flexible tool call handling       | ❌ No built-in workflow structure   |
| ✅ Small focused agent guidance      |                                     |

### Superpowers

| Strengths                         | Weaknesses                        |
| --------------------------------- | --------------------------------- |
| ✅ TDD methodology for skills     | ❌ Claude Code-specific           |
| ✅ Rich skill descriptions        | ❌ Emphatic/mandatory tone        |
| ✅ Progressive disclosure pattern | ❌ Heavy command system           |
| ✅ Subagent-driven development    | ❌ Requires specific tool support |

### Beads

| Strengths                           | Weaknesses                          |
| ----------------------------------- | ----------------------------------- |
| ✅ Solves write-only memory problem | ❌ Adds CLI tooling dependency      |
| ✅ Structured queries over prose    | ❌ New file format and workflow     |
| ✅ Git-native persistence           | ❌ Implementation effort required   |
| ✅ First-class dependencies         | ❌ Overkill for single-session work |

### Manus/planning-with-files

| Strengths                             | Weaknesses                             |
| ------------------------------------- | -------------------------------------- |
| ✅ Solves goal drift in long sessions | ❌ Claude Code-specific                |
| ✅ Simple 3-file pattern              | ❌ Adds file overhead per task         |
| ✅ Read-before-decide is universal    | ❌ Mandatory file creation is friction |
| ✅ Based on proven $2B acquisition    | ❌ Overlaps with existing handoffs     |

### Ralph Wiggum

| Strengths                               | Weaknesses                                |
| --------------------------------------- | ----------------------------------------- |
| ✅ Fresh context per task avoids bloat  | ❌ Requires CLI orchestration (bash)      |
| ✅ Subagent fan-out preserves context   | ❌ Skip permissions = security risk       |
| ✅ Disposable plans embrace iteration   | ❌ Minimal human oversight during run     |
| ✅ Backpressure via tests is elegant    | ❌ Not suited for exploratory/design work |
| ✅ Proven for greenfield overnight runs | ❌ Conflicts with IDE-based workflows     |

---

## Synthesis: Best of Each

### Adopt from ACE

- Frequent Intentional Compaction mindset
- 40-60% context utilization target
- Human review at research/plan boundaries
- Phase-based workflow structure

### Adopt from RIPER

- Explicit tool restrictions per mode
- Memory bank concept (adapted for Copilot)
- Clear mode transition points

### Adopt from 12-Factor

- Own your prompts (no black boxes)
- Own your context window (custom formats)
- Small, focused agents (3-20 steps)
- Compact errors into context (limit retries)

### Adopt from Superpowers

- TDD methodology for validating skills (pressure scenarios)
- Rich descriptions for skill auto-discovery
- Progressive disclosure pattern (<500 lines main file)
- Skill namespace concept (personal overrides framework)

### Adopt from Beads (Future Consideration)

- Issue tracker metaphor for multi-week features
- Structured queries over prose plans
- First-class `depends` field for explicit dependencies
- `bd ready` pattern for "what's next?"

### Adopt from Manus/planning-with-files

- Read-before-decide principle for long sessions
- Todo list as attention anchor (frequent updates refresh goals)
- Periodic re-read of plan/handoff files (~15 tool calls)
- Error persistence in progress tracking

### Adopt from Ralph Wiggum

- Subagent fan-out for context preservation (main agent as scheduler)
- Disposable plans—regenerate when trajectory goes wrong
- Backpressure via tests/lints as gates that reject invalid work
- Operational docs separate from progress (AGENTS.md vs IMPLEMENTATION_PLAN.md)
- 40-60% context utilization target (reinforces ACE guidance)

---

## Conflicts & Resolutions

### Conflict 1: Mode Complexity

- **RIPER**: 5 distinct modes with complex transitions
- **ACE**: 3 simpler phases
- **Resolution**: Use 4 core modes (Research/Plan/Execute/Review) with specialized agents for specific tasks

### Conflict 2: Context Persistence

- **RIPER**: Permanent memory bank files
- **12-Factor**: Unified state per thread
- **Beads**: Issue tracker with structured queries
- **Resolution**: Use task-centric persistence (`.tasks/` directories) for session continuity (simpler than memory bank or Beads); revisit Beads when multi-week features become common. See [Memory and Session Continuity](./memory-and-continuity.md).

### Conflict 3: Tool Control

- **RIPER**: Framework controls via permission matrix
- **12-Factor**: Developer controls via code
- **Resolution**: Use Copilot's tool restrictions in agent modes (framework control) but maintain awareness that we're choosing this

### Conflict 4: Human Interaction Frequency

- **ACE**: Strategic checkpoints only
- **12-Factor**: Potentially any tool call
- **Resolution**: Strategic checkpoints (ACE style) for workflow phases; optional per-tool approval for high-stakes operations only

### Conflict 5: Autonomous vs Interactive

- **Ralph**: External bash loop, skip permissions, human observes from outside
- **AGENTS**: Human-in-loop at phase transitions, tool restrictions per mode
- **Resolution**: AGENTS prioritizes collaboration quality over throughput. Ralph's principles (subagent fan-out, disposable plans, backpressure) are adopted without adopting autonomous bash orchestration.
