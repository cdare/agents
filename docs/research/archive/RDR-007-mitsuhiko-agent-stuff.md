# Research Decision Record: mitsuhiko/agent-stuff

| Field        | Value                                                                            |
| ------------ | -------------------------------------------------------------------------------- |
| **Source**   | https://github.com/mitsuhiko/agent-stuff/blob/main/skills/improve-skill/SKILL.md |
| **Reviewed** | 2025-12-30                                                                       |
| **Status**   | Partially Adopted                                                                |

## Summary

A repository by Armin Ronacher (mitsuhiko) containing commands and skills for coding agents (Claude Code, Pi, Codex). The key innovation is session continuity via `/handoff` and `/pickup` commands that persist context to files, plus a meta-skill (`improve-skill`) that analyzes session transcripts to improve skills over time.

## Key Concepts

| Concept                        | Description                                                               |
| ------------------------------ | ------------------------------------------------------------------------- |
| **Session-as-Data**            | Session transcripts (JSONL) are first-class data for parsing and analysis |
| **Handoff/Pickup Commands**    | `/handoff "purpose"` writes context to file; `/pickup slug` resumes       |
| **Structured Handoff Format**  | Primary Request, Key Concepts, Files/Code, Problem Solving, Pending Tasks |
| **Fresh Session for Analysis** | Improvement prompts go to NEW sessions for token efficiency               |
| **Skill Self-Improvement**     | Analyze transcripts for confusion patterns → improve skill                |
| **Confusion Pattern Mining**   | Look for retries, errors, workarounds to find improvement opportunities   |

## Decision

### Adopted

1. **Handoff Agent** - Created dedicated agent to persist Research/Plan context to files
2. **Persistent Handoff Location** - Files stored in `.github/handoffs/` (inside repo, globally gitignored) - see [RDR-008](RDR-008-handoff-workspace-constraint.md)
3. **Dual-Source Adaptation** - Handoff agent handles both Research and Plan outputs
4. **Optional Integration** - Added as handoff option, doesn't change existing workflows

### Not Adopted

1. **Session Transcript Parsing** - VS Code Copilot doesn't expose session files like Claude Code
2. **`improve-skill` Meta-Skill** - Requires transcript access we don't have
3. **Slash Commands** - Copilot uses prompt files/agents, not `/command` syntax

### Rationale

The handoff pattern solves multi-session continuity without the complexity of Beads (RDR-005). Key insight: persist context at natural workflow boundaries (end of Research, end of Plan) rather than trying to build full issue-tracker infrastructure.

Platform limitation: VS Code Copilot doesn't expose session transcripts, so the `improve-skill` feedback loop isn't implementable. The handoff concept translates well; the transcript mining does not.

## Comparison to Beads (RDR-005)

| Aspect         | Beads                           | mitsuhiko Handoffs              | Our Implementation               |
| -------------- | ------------------------------- | ------------------------------- | -------------------------------- |
| Problem solved | Multi-session memory & tracking | Single session → next session   | Single session → next session    |
| Data structure | Issue tracker with JSONL        | Prose markdown handoff docs     | Prose markdown handoff docs      |
| Queryability   | Structured: `bd ready --json`   | Unstructured: agent reads prose | Unstructured: agent reads prose  |
| Dependencies   | First-class `depends` field     | Implicit in prose               | Implicit in prose                |
| Complexity     | High (CLI, schema, issue model) | Low (markdown with sections)    | Low (markdown with sections)     |
| Implementation | Build or adopt `bd` CLI         | Two command files               | One agent file + handoff buttons |

**Verdict**: Handoffs are complementary to Beads, not competing. Use handoffs for day-to-day continuity; consider Beads when multi-week tracking becomes necessary.

## Implementation Details

### Created

- `.github/agents/handoff.agent.md` - Dedicated agent with `editFiles` permission
- Handoff buttons added to Research and Plan agents
- Implement agent updated to read from handoff files

### Handoff Location

`.github/handoffs/YYYY-MM-DD-slug.md`

Inside repository but globally gitignored to prevent accidental commits. See [RDR-008](RDR-008-handoff-workspace-constraint.md) for rationale.

### Workflow

```
Research ──┬──→ Plan ──┬──→ Implement → Review → Commit
           │           │
           └──→ Handoff Agent (writes to .github/handoffs/)
                       └──→ Handoff Agent

New session: Implement (reads handoff file)
```

## Future Considerations

1. **Pickup Command** - Could add prompt file to list/select handoffs
2. **Handoff Cleanup** - Periodic cleanup of old handoff files
3. **Beads Integration** - If multi-week features become common, revisit RDR-005
4. **Skill Improvement** - If Copilot exposes session data, revisit improve-skill pattern

## Related Research

- **RDR-005**: Beads Memory System - heavier solution for persistent memory
- **RDR-006**: Agentic Future - validates plan-first emphasis and context management focus
