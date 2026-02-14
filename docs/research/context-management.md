# Context Management Patterns

| Field      | Value             |
| ---------- | ----------------- |
| **Date**   | 2026-02-14        |
| **Status** | Partially Adopted |

## Summary

Patterns for managing context: subagent isolation, attention anchoring, and memory. Three complementary approaches that address context limits during long sessions.

---

## Subagents and Context Forking (from RDR-010)

**Source:** [VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#context-isolated-subagents)

VS Code supports **handoffs** (preserve context) and **subagents** (fork to isolated context). Subagents return only final summaries, compacting context automatically.

### Key Distinction

| Pattern   | Use Case                | Context Behavior            |
| --------- | ----------------------- | --------------------------- |
| Handoffs  | Phase transitions       | Preserves context           |
| Subagents | Parallel investigations | Forks, returns summary only |

### What We Adopted

- Enabled `runSubagent` tool in Explore agent
- Use subagents for context-heavy explorations (file tracing, dependency analysis)
- Subagents auto-compact: main context receives summaries, not intermediate reads

### Rejected

- Subagents for phase transitions—handoffs preserve needed context
- Subagents for tasks requiring user interaction

### Key Insight

Subagents complement handoffs, don't replace them. Use handoffs for phase transitions (Explore→Implement); use subagents for parallel investigations within a phase.

---

## Planning with Files (from RDR-012)

**Source:** [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)

3-file approach for persistent working memory during long sessions. Agents re-read plan file before major decisions to combat goal drift.

### What We Adopted

| Pattern              | Implementation                                     |
| -------------------- | -------------------------------------------------- |
| Read-before-decide   | "Attention Management" section in Implement agent  |
| Todo list as anchor  | Frequent updates refresh goals in attention window |
| Goal drift awareness | Documented in prevailing-wisdom.md                 |

### Rejected

- Mandatory 3-file infrastructure (too much friction)
- New skill/agent for this (absorbed into existing guidance)

### Key Insight

Attention manipulation: re-reading plan before major decisions refreshes goals in the attention window, combating "lost in the middle" during long sessions (50+ tool calls).

---

## Copilot Memory (from RDR-025)

**Source:** [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

GitHub's Copilot Memory is a platform-level feature that stores repository-scoped "memories" automatically as Copilot works. Memories are validated against current code, expire after 28 days, and are shared across Copilot features.

### What We Adopted

| Feature                   | Our Implementation                             |
| ------------------------- | ---------------------------------------------- |
| Pattern memory            | `## Learned Patterns` section in AGENTS.md     |
| Validation reference      | Location column for citation                   |
| Staleness awareness       | Discovered date, 14-day warning for task files |
| Learning from corrections | Implement agent learns during implementation   |
| Pattern discovery         | Explore agent discovers during research        |

### Not Adopted

- Automatic memory creation (ours is explicit, user-confirmed)
- Auto-expiry (rely on human curation)
- Platform integration (we're IDE-focused, not GitHub-hosted features)

### Key Insight

Copilot Memory's design validates memories against current code before use. Our lighter-touch version: record Location as reference, note discrepancies when patterns seem stale, rely on periodic human review.

---

## See Also

- [memory-and-continuity.md](../synthesis/memory-and-continuity.md) — Session continuity approach
- [RDR-005-beads.md](RDR-005-beads.md) — Future JSONL memory alternative
- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Goal drift and context engineering
