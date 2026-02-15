# Orchestration & Subagent Architecture

**Source:** Task 006 (February 2026)

## Decision

Introduce a conductor pattern with restricted subagent invocation to enable automated multi-phase task execution while maintaining user control.

## Why

- Manual orchestration of 3-phase tasks required 12+ separate sessions
- Subagent context isolation prevents context bloat from parallel research
- Scope enforcement via `agents` frontmatter prevents unintended agent invocations
- Structured pause points (`askQuestions`) give users control without manual intervention

## Problem Statement

The existing workflow required users to manually invoke agents for each step:

1. Explore → creates task + phases
2. Explore → creates phase plan (per phase)
3. Phase-review skill → review plan (per phase)
4. Implement → implement (per phase)
5. Review → verify (per phase)
6. Commit → commit (per phase)

This was tedious and error-prone, with no automated progression.

## Solution

### Before

```
User ──(manual)──> Explore ──(manual)──> Implement ──(manual)──> Review ──(manual)──> Commit
                      │
                      └── (no subagent support)
```

### After

```
Orchestrate (Conductor)
    │
    ├── Explore (subagent) ──> Research (subagent)
    │       └── agents: ["Explore", "Research"]
    │
    ├── Implement (subagent) ──> Worker (subagent)
    │       └── agents: ["Worker"]
    │
    ├── Review (subagent) ──> Worker (subagent)
    │       └── agents: ["Worker"]
    │
    └── Commit (subagent) ──> Research (subagent)
            └── agents: ["Research"]
```

## Implementation Phases

| Phase                     | What Changed                                                      |
| ------------------------- | ----------------------------------------------------------------- |
| 1. Agent Locations        | Migrated to `~/.copilot/agents`, added `chat.agentFilesLocations` |
| 2. Settings & Frontmatter | Added `agents` restrictions, `model` fallbacks to all agents      |
| 3. Skill YAML Fix         | Converted folded blocks to inline strings for VS Code parser      |
| 4. Worker Subagents       | Created Research (read-only) and Worker (full-access) agents      |
| 5. Subagent Invocation    | Added `agents` restrictions to Explore, Implement, Review, Commit |
| 6. Orchestrate Agent      | Created conductor with mandatory pause points                     |
| 8. Documentation          | RDR-031, prevailing-wisdom.md updates                             |

## Key Architectural Patterns

### 1. Conductor Agent Pattern

The Orchestrate agent delegates all work to specialized subagents:

```yaml
# orchestrate.agent.md frontmatter
agents: ["Explore", "Implement", "Review", "Commit"]
disable-model-invocation: true # Must be explicitly invoked
```

### 2. Worker Subagent Pattern

Internal agents hidden from users with `user-invokable: false`:

```yaml
# research.agent.md frontmatter
name: Research
user-invokable: false
tools: ["read/readFile", "search", "web", "todo"]
model: ["Claude Sonnet 4.5 (copilot)"]
```

### 3. Scope Enforcement via `agents` Restriction

Each agent declares which subagents it can invoke:

```yaml
# explore.agent.md
agents: ["Explore", "Research"]  # Can self-recurse and use Research

# implement.agent.md
agents: ["Worker"]  # Can only use Worker for isolated tasks
```

### 4. Mandatory Pause Points

Orchestrate uses `askQuestions` tool for structured user decisions:

```markdown
| Pause Point       | Trigger                      | User Action               |
| ----------------- | ---------------------------- | ------------------------- |
| Task Created      | After Explore creates phases | Approve task structure    |
| Phase Plan Ready  | After plan + review          | Approve plan, adopt fixes |
| Phase Implemented | After Implement + Review     | Approve changes, commit   |
```

### 5. Agent Capabilities Table (Task 011)

Explicit capability mapping prevents wrong agent selection:

```markdown
| Agent     | Access Level | Capabilities                         |
| --------- | ------------ | ------------------------------------ |
| Explore   | Read-only    | Search, read files, create plans     |
| Implement | Full         | File edits, terminal, run tests      |
| Review    | Verify       | Read, terminal for checks, run tests |
| Commit    | Git only     | Stage, commit, no other changes      |
```

Selection guidance: "Need terminal? → Implement/Review, NOT Explore"

## Current Structure

```
.github/agents/
├── orchestrate.agent.md  # Conductor - coordinates workflow
├── explore.agent.md      # READ-ONLY research and planning
├── implement.agent.md    # Code implementation
├── review.agent.md       # Code review and verification
├── commit.agent.md       # Git commit generation
├── research.agent.md     # Internal: context-isolated research (user-invokable: false)
└── worker.agent.md       # Internal: context-isolated execution (user-invokable: false)
```

## Evolution Insights

Key learnings from iterative refinements (Tasks 007-011):

### Checkpoint Enforcement

Initial PAUSE markers were buried as notes at the end of action sequences. The agent
read ahead and treated them as descriptive text, not blocking instructions.

**Solution:** Visual `### 🛑 CHECKPOINT` headers as distinct workflow steps. Checkpoints
fire **unconditionally**—even if user says "plan only" or "skip implementation",
the checkpoint still presents options.

### LLM Instruction Patterns

Discovered that LLMs follow instructions more reliably when:

| Pattern                     | Example                                 |
| --------------------------- | --------------------------------------- |
| Commands before actions     | STOP block precedes action steps        |
| Visual markers stand out    | Emoji headers, horizontal rules         |
| Consequences are explicit   | "Violating this defeats the purpose..." |
| Structure enforces behavior | Separate sections that can't be skipped |

### Mode Simplification

Ambiguous examples ("plan all phases", "just create", "review only") caused
inconsistent behavior. Replaced with two explicit modes:

- **Full Execution:** Plan → Implement → Commit per phase
- **Plan Only:** Create task.md with phases, stop after planning

Mode is set once per task and recorded in frontmatter.

### First Action Protocol

Agent skipped task creation when given direct questions. Added explicit decision tree:

1. Check `.tasks/` for existing task matching context
2. If found → Resume existing task
3. If not found → Create new task (Step 1)

This ensures state persistence across sessions.

### Drift Prevention (Task 013)

The agent consistently "drifted" — losing track of execution position after clarifying questions,
detours, or subagent results. Root cause: advisory tracking sections weren't enforced.

**Solutions implemented:**

| Mechanism             | Implementation                                                         |
| --------------------- | ---------------------------------------------------------------------- |
| Tool restriction      | Removed `search` tool — prevents self-research tangents                |
| Conductor constraints | Explicit prohibitions: "NEVER research", "NEVER edit files directly"   |
| Position Lock         | Exactly ONE `[in-progress]` todo item = current instruction            |
| Embedded reminders    | `> Before invoking: Verify this matches your [in-progress] todo item.` |
| Detour recovery       | Protocol to return to workflow after handling interruptions            |

### First Action Protocol Enforcement (Task 014)

The agent skipped the First Action Protocol (checking `.tasks/` before any work) when requests
felt urgent. Root cause: the FAP section was buried at line 51, after the agent had already
formed an execution plan from the user's message.

**Solutions implemented:**

| Mechanism                 | Implementation                                                                           |
| ------------------------- | ---------------------------------------------------------------------------------------- |
| Entry Gate at primacy     | New section immediately after frontmatter — first thing LLM sees                         |
| Tool-coupled first action | "Your FIRST tool call MUST be `list_dir` on `.tasks/`" — forces mechanical compliance    |
| Anti-bypass language      | "Even to: urgent bugs, production issues, 'quick' questions" — addresses rationalization |

**Entry Gate pattern:**

```markdown
## ⚠️ Entry Gate

**BEFORE responding to ANY user message:**

1. Read `.tasks/` directory
2. Resolve task state (existing task or new)
3. ONLY THEN proceed with workflow
```

This applies the Checkpoint Enforcement insight (visual markers, commands before actions) to
the entry point of the workflow. Tool-coupling mirrors how checkpoints force `askQuestions`
calls — now extended to the very first action.

**Position Lock format:**

```
→ 2a.1. Phase 1: Create Plan    [in-progress]  ← CURRENT INSTRUCTION
  2a.2. Phase 1: Review Plan    [not-started]
```

Before ANY action, agent must verify the in-progress item matches the intended action.
This transforms the todo list from advisory to enforcement mechanism.

## Frontmatter Reference (VS Code 1.109+)

| Attribute                  | Purpose                                  | Example                                    |
| -------------------------- | ---------------------------------------- | ------------------------------------------ |
| `agents: [...]`            | Restricts which subagents can be invoked | `["Explore", "Research"]`                  |
| `user-invokable: false`    | Hides agent from UI (internal only)      | For worker subagents                       |
| `disable-model-invocation` | Prevents auto-invocation by model        | For explicit-only agents                   |
| `model: [...]`             | Fallback models if first unavailable     | `["Claude Opus 4.5", "Claude Sonnet 4.5"]` |

## Updates

| Date          | Task | Summary                                                                                                         |
| ------------- | ---- | --------------------------------------------------------------------------------------------------------------- |
| February 2026 | 007  | Added 🛑 CHECKPOINT headers, strengthened enforcement; pause compliance fixed                                   |
| February 2026 | 008  | Validated patterns against Atlas/Orchestra; confirmed context conservation approach                             |
| February 2026 | 009  | Made checkpoints unconditional; review returns findings (doesn't modify plans)                                  |
| February 2026 | 010  | Simplified to two modes; 544→450 lines; made task state mandatory                                               |
| February 2026 | 011  | Added Agent Capabilities table, First Action protocol, removed handoffs; 473→471 lines                          |
| February 2026 | 013  | Drift prevention: Position Lock, removed `search` tool, detour recovery; 479→420 lines                          |
| February 2026 | 014  | FAP enforcement: Entry Gate at primacy position, tool-coupled first action, anti-bypass language; 427→438 lines |

## Related

- [RDR-031: VS Code 1.109 Orchestration](../../docs/research/RDR-031-vscode-1109-orchestration.md)
- [prevailing-wisdom.md](../../docs/synthesis/prevailing-wisdom.md) — Updated with new frontmatter
