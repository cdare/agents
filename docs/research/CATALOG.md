# RDR Catalog

Quick reference for Research Decision Records.

> **Synthesis docs are authoritative** — RDRs document decisions, synthesis docs document the resulting patterns. When in doubt, consult [prevailing-wisdom.md](../synthesis/prevailing-wisdom.md).

## Consolidated Files

Themed consolidations of multiple RDRs. Original RDRs preserved in [archive/](archive/).

| File                                           | Source RDRs        | Theme                      |
| ---------------------------------------------- | ------------------ | -------------------------- |
| [vscode-platform.md](vscode-platform.md)       | 014, 015, 031      | VS Code features           |
| [external-patterns.md](external-patterns.md)   | 003, 022, 023, 024 | Industry best practices    |
| [context-management.md](context-management.md) | 010, 012, 025      | Context and memory         |
| [skills-methodology.md](skills-methodology.md) | 004, 019, 027, 028 | Skill creation and testing |
| [ide-compatibility.md](ide-compatibility.md)   | 017, 029           | Multi-IDE support          |

## Standalone Files

| File                                                                   | Status            | Summary                    |
| ---------------------------------------------------------------------- | ----------------- | -------------------------- |
| [RDR-005-beads.md](RDR-005-beads.md)                                   | Future            | Beads JSONL memory         |
| [RDR-013-vscode-browser-testing.md](RDR-013-vscode-browser-testing.md) | Future            | Playwright browser testing |
| [RDR-020-design-skill.md](RDR-020-design-skill.md)                     | Adopted           | Design skill creation      |
| [RDR-030-vercel-agents-md-evals.md](RDR-030-vercel-agents-md-evals.md) | Partially Adopted | Vercel eval study          |
| [RDR-032-atlas-orchestra.md](RDR-032-atlas-orchestra.md)               | Partially Adopted | Orchestra patterns         |

**Note:** RDR-016 and RDR-018 superseded by ADRs. See [docs/architecture/](../architecture/) for ADR-002 (task persistence) and ADR-003 (agent consolidation).

## Quick Reference

| I want to understand...     | Start with                                                     |
| --------------------------- | -------------------------------------------------------------- |
| VS Code settings & tools    | [vscode-platform.md](vscode-platform.md)                       |
| External framework patterns | [external-patterns.md](external-patterns.md)                   |
| Context/memory/subagents    | [context-management.md](context-management.md)                 |
| Skill creation & testing    | [skills-methodology.md](skills-methodology.md)                 |
| Multi-IDE compatibility     | [ide-compatibility.md](ide-compatibility.md)                   |
| Why 4 agents not 6          | [ADR-003](../architecture/ADR-003-agent-consolidation.md)      |
| Task persistence approach   | [ADR-002](../architecture/ADR-002-task-centric-persistence.md) |
| Skill-powered subagents     | [ADR-004](../architecture/ADR-004-skill-powered-subagents.md)  |
| IDE support strategy        | [ADR-005](../architecture/ADR-005-ide-compatibility.md)        |
| Skill creation example      | RDR-020 (design skill)                                         |

## Archive

Originals of consolidated RDRs, plus rejected/superseded research. See [archive/](archive/) for full documents.

| RDR | Title                        | Why Archived                         |
| --- | ---------------------------- | ------------------------------------ |
| 001 | Spec-Driven                  | Rejected: spec files not used        |
| 002 | Context Cortex               | Rejected: memory bank not used       |
| 003 | Feature-Dev                  | Consolidated → external-patterns.md  |
| 004 | Superpowers                  | Consolidated → skills-methodology.md |
| 006 | Agentic Future               | Informational only                   |
| 007 | mitsuhiko agent-stuff        | Superseded by RDR-018                |
| 008 | Handoff Workspace Constraint | Superseded by RDR-018                |
| 009 | MCP Memory                   | Rejected: too complex                |
| 010 | Subagents Context Fork       | Consolidated → context-management.md |
| 011 | Protection Markers           | Feature removed                      |
| 012 | Planning with Files          | Consolidated → context-management.md |
| 014 | VSCode Copilot Settings      | Consolidated → vscode-platform.md    |
| 015 | Copilot Agent Tools          | Consolidated → vscode-platform.md    |
| 016 | Agent Consolidation          | Superseded by ADR-003                |
| 017 | Agent Spec Compatibility     | Consolidated → ide-compatibility.md  |
| 018 | Task-Centric Persistence     | Superseded by ADR-002                |
| 019 | Skill Review                 | Consolidated → skills-methodology.md |
| 021 | Agno                         | Rejected: out of scope               |
| 022 | Six Tips for Agents          | Consolidated → external-patterns.md  |
| 023 | Ralph Wiggum                 | Consolidated → external-patterns.md  |
| 024 | Claude Code Mastery          | Consolidated → external-patterns.md  |
| 025 | Copilot Memory               | Consolidated → context-management.md |
| 026 | MetaPrompts                  | Rejected: confirms existing approach |
| 027 | Skill Subagents              | Consolidated → skills-methodology.md |
| 028 | Skills.sh                    | Consolidated → skills-methodology.md |
| 029 | Alternative IDE Support      | Consolidated → ide-compatibility.md  |
| 031 | 1.109 Orchestration          | Consolidated → vscode-platform.md    |
