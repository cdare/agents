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

## Frontmatter Reference (VS Code 1.109+)

| Attribute                  | Purpose                                  | Example                                    |
| -------------------------- | ---------------------------------------- | ------------------------------------------ |
| `agents: [...]`            | Restricts which subagents can be invoked | `["Explore", "Research"]`                  |
| `user-invokable: false`    | Hides agent from UI (internal only)      | For worker subagents                       |
| `disable-model-invocation` | Prevents auto-invocation by model        | For explicit-only agents                   |
| `model: [...]`             | Fallback models if first unavailable     | `["Claude Opus 4.5", "Claude Sonnet 4.5"]` |

## Updates

| Date          | Task | Summary                                                                                |
| ------------- | ---- | -------------------------------------------------------------------------------------- |
| February 2026 | 011  | Added Agent Capabilities table, First Action protocol, removed handoffs; 473→471 lines |

## Related

- [RDR-031: VS Code 1.109 Orchestration](../../docs/research/RDR-031-vscode-1109-orchestration.md)
- [prevailing-wisdom.md](../../docs/synthesis/prevailing-wisdom.md) — Updated with new frontmatter
