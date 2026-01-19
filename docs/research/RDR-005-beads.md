# Research Decision Record: Beads Memory System

| Field        | Value                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------ |
| **Source**   | https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a |
| **Reviewed** | 2025-12-29                                                                                 |
| **Status**   | Future Consideration                                                                       |

## Summary

Beads is a coding agent memory system created by Steve Yegge after a 6-week experiment generating 350k+ LOC. It addresses the fundamental problem that coding agents have no persistent memory between sessions—they only know what they can find on disk at boot time. The system uses an issue-tracker metaphor with JSONL files stored in git, enabling structured queries instead of the "write-only memory" that markdown files become.

## Key Concepts

| Concept                       | Description                                                                                                  |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Write-Only Memory Problem** | Markdown plans become unqueryable over time—agents write them but can't search or structure-query them later |
| **605 Plans Problem**         | Real experiment produced 605 inscrutable markdown plans that agents couldn't navigate or understand          |
| **Issue Tracker Metaphor**    | Beads uses familiar issue/defect tracker concepts (Epic → Story → Task → Defect) with dependencies           |
| **JSONL in Git**              | Everything stored in `docs/issues/issues.jsonl`—git provides versioning, JSON enables structured queries     |
| **CLI Queries**               | `bd ready --json` returns actionable items; enables "agent asks what to do next" pattern                     |
| **First-Class Dependencies**  | Unlike prose plans, dependencies are explicit fields that can be queried and validated                       |
| **Resumability**              | Agent can pick up exactly where it left off via `bd ready` without re-reading thousands of lines of context  |

## Decision

**Status: Future Consideration**

Not adopted now, but documented for future implementation when context overflow becomes a blocking problem.

**What This Would Enable:**

1. True memory across sessions—agent knows what's done, what's blocked, what's next
2. Structured handoffs without file I/O permissions (issue tracker is separate from agent tools)
3. Progress tracking for multi-day features
4. Human-readable audit trail in git history

**Why Not Now:**

1. **Complexity** - Adds CLI tooling dependency, new file format, new workflow
2. **Permission Model Works** - Our read-only Research/Plan agents are a feature, not a bug
3. **Current Scope** - Framework works for single-session tasks; memory system is for multi-session
4. **Implementation Effort** - Beads is a full system; would need to build or adapt

**When to Revisit:**

- Multi-day features become common
- Session context overflow is blocking work
- Team workflows need progress visibility
- Pattern of "where was I?" questions at session start

## Key Insight: Why Markdown Files Fail

> "The problem we all face with coding agents is that they have no memory between sessions... Markdown files are write-only memory for agents."

The transient context file approach we attempted runs into exactly this problem:

1. **Query Problem** - Agent can't ask "what issues are blocking X?" of a markdown file
2. **Staleness** - Plans written at session start may not reflect current state
3. **Dependencies as Prose** - "After step 2" is unqueryable; `"depends": ["task-123"]` is queryable
4. **605 Files Problem** - At scale, markdown plans become noise

The Beads insight: Don't try to make markdown files smarter. Use a different data structure (issue tracker) with structured queries.

## Comparison to Current Framework

**What We Have:**

| Aspect          | Current Framework                         |
| --------------- | ----------------------------------------- |
| Memory          | None (each session starts fresh)          |
| Context Passing | Handoff buttons with conversation history |
| Plans           | Markdown in chat context                  |
| Dependencies    | Prose in plan documents                   |
| Progress        | Checkboxes in plan, ephemeral             |

**What Beads Adds:**

| Aspect          | With Beads                                  |
| --------------- | ------------------------------------------- |
| Memory          | `docs/issues/issues.jsonl` persists         |
| Context Passing | `bd ready` returns structured next steps    |
| Plans           | Issues with spec links                      |
| Dependencies    | First-class `depends` field                 |
| Progress        | Issue state (open/in_progress/done/blocked) |

## Implementation Notes for Future

If implementing Beads-style memory:

1. **Minimal Version**
   - Add `bd` CLI or equivalent
   - Store issues in `docs/issues/issues.jsonl`
   - Add "check issues" step to Research agent
   - Add "create issue" capability to Plan agent (via separate tool)

2. **Integration Points**
   - Research: `bd ready --json` to see pending work
   - Plan: Creates issues and specs
   - Implement: Updates issue status
   - Review: Closes issues on completion

3. **Permission Model**
   - Issue tracker is separate from code editing
   - All agents could have issue read/write without file edit access

## Related Research

- **[RDR-006](archive/RDR-006-agentic-future.md)**: "What's Next in Agentic Coding" - discusses context management evolution
- **Attempted Feature**: Transient MD context files - failed due to agent permission model

## References

- **Article**: [Introducing Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a)
- **Companion Article**: [Fixing Vibe Coding](https://steve-yegge.medium.com/fixing-vibe-coding-8414562a6238)
- **Context**: Written after 6-week experiment with Claude Code, 350k+ LOC across hundreds of files
