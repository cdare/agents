# Memory and Session Continuity

> How AGENTS handles the fundamental problem that AI coding agents forget everything between sessions.

---

## The Problem

AI coding agents have no persistent memory between sessions. Each new conversation starts fresh—the agent only knows what it can find on disk at boot time.

### The "Write-Only Memory" Problem

> "Markdown files are write-only memory for agents." — Steve Yegge (Beads)

Plans and research documents written during a session become difficult to use later:

| Problem                   | Why It Matters                                                        |
| ------------------------- | --------------------------------------------------------------------- |
| **Query Problem**         | Agent can't ask "what issues are blocking X?" of a markdown file      |
| **Staleness**             | Plans written at session start may not reflect current state          |
| **Dependencies as Prose** | "After step 2" is unqueryable; `"depends": ["task-123"]` is queryable |
| **Scale Problem**         | At 100+ plan files, agents can't navigate or prioritize               |

The insight: prose plans work for single sessions but break down over time.

---

## Approaches Evaluated

### 1. Memory Bank Pattern (RIPER / Context Cortex)

**What it is:** Persistent context files maintained across sessions:

```
projectbrief.md      # Core requirements
systemPatterns.md    # Established patterns
techContext.md       # Tech stack details
activeContext.md     # Current focus
progress.md          # Task status
```

**Status:** Rejected

**Rationale:** Different philosophy—Memory Bank focuses on persistent learning and active context; AGENTS focuses on structured workflow phases and explicit control. Session continuity is better handled by explicit handoffs at workflow boundaries than implicit memory updates.

**Reference:** [RDR-002](../research/RDR-002-context-cortex.md)

---

### 2. MCP Memory Servers

**What it is:** Model Context Protocol servers that provide memory tools to agents. The official `@modelcontextprotocol/server-memory` uses a knowledge graph with entities, relations, and observations stored in JSONL.

**Status:** Rejected

**Rationale:** Adds significant complexity (Node process, mcp.json config, JSONL storage, maintenance burden) without proportional benefit. The Handoff agent achieves similar cross-session persistence with simpler architecture: markdown files, human-readable, version-controlled, no external dependencies.

**Reference:** [RDR-009](../research/RDR-009-mcp-memory-rejected.md)

---

### 3. Issue Tracker Memory (Beads)

**What it is:** A memory system using an issue-tracker metaphor with JSONL files stored in git. Issues have types (Epic → Story → Task → Defect), first-class dependencies, and structured queries via CLI (`bd ready --json`).

**Key Insight:** Don't try to make markdown files smarter. Use a different data structure (issue tracker) with structured queries.

**Status:** Future Consideration

**When to Revisit:**

- Multi-day/multi-week features become common
- Session context overflow is blocking work
- Team workflows need progress visibility
- Pattern of "where was I?" questions at session start

**Rationale:** Not adopted now because it adds CLI tooling dependency, new file format, and workflow changes. Current single-session focus doesn't require this infrastructure. But it's the right solution when scale demands it.

**Reference:** [RDR-005](../research/RDR-005-beads.md)

---

### 4. Handoff Pattern (Adopted)

**What it is:** Persist context at natural workflow boundaries (end of Research, end of Plan) to timestamped markdown files. A dedicated Handoff agent with file-write permissions transforms conversation context into structured documents.

**How it works:**

```
Research ──┬──→ Plan ──┬──→ Implement → Review → Commit
           │           │
           └──→ Handoff Agent (writes to .github/handoffs/)
                       └──→ Handoff Agent

New session: Implement agent reads handoff file
```

**File location:** `.github/handoffs/YYYY-MM-DD-HHMMSS-slug.md`

Inside repository but globally gitignored to prevent accidental commits. Can be selectively shared with `git add -f`.

**Status:** Adopted

**Rationale:**

- Solves multi-session continuity without infrastructure complexity
- Works within VS Code Copilot's workspace-scoped file permissions
- Natural fit with phase-based workflow (persist at phase boundaries)
- Human-readable files that can be reviewed and edited
- No external dependencies

**References:** [RDR-007](../research/RDR-007-mitsuhiko-agent-stuff.md), [RDR-008](../research/RDR-008-handoff-workspace-constraint.md)

---

## Decision Matrix

| Situation                           | Recommended Approach    |
| ----------------------------------- | ----------------------- |
| Single session, single task         | No persistence needed   |
| Continue tomorrow on same feature   | Use Handoff agent       |
| Multi-week epic with many tasks     | Consider Beads (future) |
| Team needs visibility into progress | Consider Beads (future) |
| Need to query "what's blocking X?"  | Consider Beads (future) |

---

## Current Solution Summary

AGENTS uses the **Handoff Pattern** for session continuity:

1. **Research** or **Plan** agent completes work
2. User clicks "Save Research" or "Save Plan" handoff button
3. **Handoff** agent writes structured markdown to `.github/handoffs/`
4. New session: **Implement** agent reads the handoff file

For implementation details, see the [Handoff agent](../../.github/agents/handoff.agent.md).

---

## Key Quotes

> "The problem we all face with coding agents is that they have no memory between sessions." — Steve Yegge

> "Markdown files are write-only memory for agents." — Steve Yegge

> "Handoffs are complementary to Beads, not competing. Use handoffs for day-to-day continuity; consider Beads when multi-week tracking becomes necessary." — RDR-007

---

## Related Documents

- [Prevailing Wisdom](./prevailing-wisdom.md) — Core framework principles
- [Framework Comparison](./framework-comparison.md) — How source frameworks handle context
- [Handoff Agent](../../.github/agents/handoff.agent.md) — Implementation details
