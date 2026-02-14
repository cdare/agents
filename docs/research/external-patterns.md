# External Agent Patterns

| Field      | Value             |
| ---------- | ----------------- |
| **Date**   | 2026-02-14        |
| **Status** | Partially Adopted |

## Summary

Patterns extracted from external agent frameworks and guides. Four sources reviewed: Anthropic's feature-dev plugin, Steve Yegge's agent tips, Ralph Wiggum autonomous agent, and Claude Code Mastery guide.

---

## Anthropic Feature-Dev (from RDR-003)

**Source:** [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev)

Official Anthropic plugin with 7-phase workflow, parallel sub-agents, and confidence-filtered reviews.

### Adopted

- **Clarifying questions emphasis** in Explore agent
- **Multiple architecture options** with recommendation
- **Confidence-based review filtering** (high-confidence issues only)

### Rejected

- Parallel sub-agents (not supported in VS Code Copilot at time of research)
- `/command` syntax (Claude Code-specific)
- Full 7-phase workflow (existing workflow covers intent)

### Key Insight

Confidence-based filtering reduces review noise. Only report high-confidence issues; low-confidence issues create distraction without proportional value.

---

## Six Tips for Agents (from RDR-022)

**Source:** [Steve Yegge](https://steve-yegge.medium.com/six-new-tips-for-better-coding-with-agents-d4e9c86e42a9)

Steve Yegge's six patterns: throwaway software, agent UX, code health 30-40%, model timing, "Rule of Five" reviews, and agent swarming.

### Adopted

| Pattern            | Application                                                   |
| ------------------ | ------------------------------------------------------------- |
| Code Health 30-40% | Spend 30-40% of time on reviews, smell detection, refactoring |
| Rule of Five       | Review work 4-5 times before trusting; convergence ~pass 5    |

### Rejected

- Agent swarming (requires orchestration infrastructure outside AGENTS scope)
- Agent UX design (AGENTS defines instructions, not tools)
- Model timing (too situational)

### Key Insight

Without 30-40% code health investment, vibe-coded bases accumulate invisible debt. Iterative review (4-5 passes) is when agent output becomes trustworthy.

---

## Ralph Wiggum (from RDR-023)

**Source:** [anthropics/claude-code plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)

Autonomous development via bash loops (`while true; do cat PROMPT.md | claude; done`). Fresh context per iteration, disk-based state, one task per loop.

### Adopted

| Pattern                    | Application                                        |
| -------------------------- | -------------------------------------------------- |
| Subagent fan-out           | Context preservation (reinforces subagent pattern) |
| Disposable plans           | Regenerate when trajectory goes wrong              |
| Backpressure via tests     | Tests/lints as gates                               |
| 40-60% context utilization | "Smart zone" for attention                         |

### Rejected

- External bash orchestration (AGENTS is interactive, human-in-loop)
- Skip permissions (AGENTS uses per-agent tool restrictions)
- Completion promise pattern (AGENTS uses handoff buttons)

### Key Insight

Ralph maximizes autonomous throughput; AGENTS maximizes collaboration quality. Ralph's context management insights (subagents as memory extension, disposable plans) are valuable without adopting its autonomous architecture.

---

## Claude Code Mastery (from RDR-024)

**Source:** [TheDecipherist/claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery)

Comprehensive Claude Code guide covering CLAUDE.md patterns, hooks, and context management.

### Adopted

| Pattern               | Application                                               |
| --------------------- | --------------------------------------------------------- |
| Single-purpose chat   | 39% performance drop when mixing topics—reinforces phases |
| Hooks vs instructions | Documented distinction in prevailing-wisdom               |
| Context rot research  | Supports "lost in the middle" mitigations                 |

### Rejected

- Global CLAUDE.md patterns (Claude Code-specific)
- Hook infrastructure (outside AGENTS scope; advisory, not enforcement)
- MCP server directory (tooling catalog, already in official docs)

### Key Insight

AGENTS provides advisory guidance that can be overridden (like CLAUDE.md). For deterministic enforcement, users need platform-level hooks—but most users don't need that level of control.

---

## See Also

- [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md) — Where adopted patterns live
- [context-management.md](context-management.md) — Subagent and context patterns
