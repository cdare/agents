# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- RDR-026: MetaPrompts research (Rejected: meta-agent for creating agents; confirms our approach)
- AGENTS.md: `## Learned Patterns` section for repository-level pattern memory
- Implement agent: "Learning from Corrections" (Step 5) - persists user-taught patterns to AGENTS.md
- Explore agent: "Repository Patterns" (Step 5.5) - discovers and suggests patterns during research
- Explore agent: Staleness warning for task files >14 days old
- memory-and-continuity.md: Learned Patterns section documenting the new feature
- RDR-025: Copilot Memory research with partial adoption

### Changed

- Task folder naming: `.tasks/[slug]/` → `.tasks/[NNN]-[slug]/` (e.g., `001-add-auth`)
  - Sequential numbering for chronological ordering
  - Updated in explore, implement, review agents and documentation
- prevailing-wisdom.md: Removed Section 7 "Code Protection" (feature was removed per RDR-011)
- framework-comparison.md: Marked RIPER protection levels as "not adopted" with RDR-011 reference
- framework-comparison.md: Updated "Handoff pattern" → "task-centric persistence" for consistency
- memory-and-continuity.md: Replaced "Handoff agent" reference with "task-centric persistence"

### Fixed

- test-install.sh: skill symlink path check now matches install.sh (`~/.copilot/skills/` instead of `~/.github/skills/`)
- test.yml: explicit zsh invocation for shell compatibility on GHA macOS runners

### Added

- design skill: UI/UX design principles for dashboards, admin interfaces, SaaS products (4px grid, depth strategy, typography hierarchy)
- makefile skill: AI-guided Makefile creation with process lifecycle management patterns (PID tracking, logging, status monitoring)
- Implement agent: "Save Progress" handoff for session continuity
- Implement agent: "Saving Progress Mid-Implementation" section for state preservation
- Implement agent: "Repo-Specific Instructions" step to check AGENTS.md for post-implementation requirements
- AGENTS.md: Post-Implementation section with CHANGELOG, docs, and versioning requirements

### Changed

- Skill count increased from 5 to 6
- Explore agent: consolidated from 541 to 322 lines (40% reduction)
  - Merged intro sections, moved Guidelines up, simplified process steps (9→6)
  - Removed handoff-format templates (now using task.md format)
- Explore agent: task.md template reorganized - phases table now at top for quick reference
- Implement agent: consolidated from 402 to 326 lines (19% reduction)
  - Integrated orphaned sections (Attention Management, Resuming Work) into workflow
  - Merged Quality Checklist + Testing Requirements with Guidelines
- Implement agent: strengthened UI verification guidance - emphasize Playwright tests over manual verification
- tech-debt skill: absorbed janitor skill content (deletion philosophy, safe deletion patterns, cleaning checklist)
- architecture skill: strengthened constraints with anti-patterns table and "Never Include" examples
- Skill count reduced from 6 to 5 (janitor merged into tech-debt)
- AGENTS.md: updated repository structure table (agents/skills count corrections)
- copilot-instructions.md: simplified to reference AGENTS.md for cross-agent instructions

### Removed

- All handoff file references (`.github/handoffs/` patterns) from both agents
- janitor skill: functionality merged into tech-debt (80% overlap)
- Terminal instructions: removed outdated line-count restrictions (VSCode 1.108 has better terminal handling)

## [0.10.0] - 2026-01-09

### Added

- Task-centric persistence: "Continue working on [task-name]" reads prior context
- Descriptive filenames for research (e.g., `error_handling.md`, `auth_flow.md`)
- Phase-based workflow with status tracking (⬜ Not Started, 📋 Planned, 🔄 In Progress, ✅ Done)
- Optional detailed phase plans in `.tasks/[task]/plan/phase-N-[name].md`
- Task metadata in `.tasks/[task]/task.md`
- Explore agent: scoped write access to `.tasks/` directory only
- Explore agent: "Plan Next Phase" handoff for detailed planning
- Implement agent: phase detection logic (picks smallest planned unit)
- RDR-017: Task-centric persistence decisions

### Changed

- Agent count reduced from 5 to 4 (Handoff agent removed)
- Agent state now saved to `.tasks/[task-name]/` instead of `.github/handoffs/`
- Explore agent asks for task name at start and saves research with descriptive filenames
- Explore agent merges overview into task.md (single source of truth)
- Implement agent reads task context from `.tasks/` directory, lists available tasks
- Implement agent model changed to Claude Opus 4.5 for better quality
- Review agent reads task context before reviewing (now read-only, no persistence)
- Install script manages `.tasks/` gitignore pattern instead of `.github/handoffs/`

### Removed

- Handoff agent: functionality now handled by Explore agent with scoped write access
- Review agent write access: now strictly read-only with test execution capability

## [0.9.1] - 2026-01-08

### Fixed

- Claude Code slash command references in documentation (corrected `/project:*` to `/*`)
- Install script messages now show correct command format (`@agent-Explore`, `@agent-Implement`, etc.)

## [0.9.0] - 2026-01-07

### Added

- RDR-017: Agent specification compatibility research for VS Code and Claude Code
- Claude Code agent invocation (`@agent-Explore`, `@agent-Implement`, `@agent-Review`, `@agent-Commit`)
- Capabilities sections in all agents describing tool access levels
- Claude Code usage documentation in README

### Changed

- Agents now use platform-agnostic language ("When starting this phase" vs "When this agent is activated")
- Install script generates Claude Code commands from agent bodies by stripping YAML frontmatter
- Handoff references updated to generic "Proceed to..." language instead of button-specific text
- Explore agent model field corrected to "Claude Opus 4.5"

## [0.8.0] - 2026-01-04

### Added

- RDR-016: Agent consolidation decision record

### Changed

- Consolidated Research + Plan agents into Explore agent (now 5 agents instead of 6)
- Explore agent enhanced with all features from Research and Plan
- Handoff agent simplified to copy Explore output verbatim (deterministic handoffs)
- Review agent: Re-Plan → Re-Explore handoff

### Removed

- `research.agent.md` - functionality merged into Explore
- `plan.agent.md` - functionality merged into Explore

## [0.7.2] - 2026-01-04

### Added

- Research tasks for VSCode browser testing, Copilot settings, and agent tools

### Changed

- Commit agent: explicit handoff file exclusion, never use force flags, require confirmation before deleting handoffs
- Handoff agent: added Explore source type, explicit filename formatting rules
- Implement agent: preserve handoff files until review passes (previously deleted after implementation)

## [0.7.1] - 2026-01-03

### Added

- RDR-012: Manus planning-with-files pattern research
- Attention Management section in Implement agent (goal drift prevention)
- Goal drift prevention guidance in prevailing-wisdom.md
- Manus/planning-with-files framework comparison

### Changed

- Framework comparison expanded with Manus pattern analysis

## [0.7.0] - 2026-01-02

### Added

- Explore agent for interactive codebase navigation and learning
- Auto-advance from Research to Plan agent
- Repo-specific copilot instructions (`.github/copilot-instructions.md`)
- Autonomous feedback loop guidance in global instructions (log files, programmatic verification)
- Self-improving instructions pattern for new repos
- RDR-011: Code protection markers removal

### Removed

- Code protection markers (`[P]`, `[G]`, `[D]`) - unused feature, see RDR-011

## [0.6.0] - 2026-01-01

### Added

- Community engagement infrastructure (CONTRIBUTING.md, issue/PR templates, README badges)

### Changed

- Supported version matrix updated to 0.5.x

## [0.5.0] - 2026-01-01

### Added

- Autonomous subagent support for Research/Plan/Implement agents
- RDR-010: Subagents and context forking research

### Changed

- Implement agent now cleans up handoff files after completion

## [0.4.0] - 2025-12-31

### Added

- Memory and session continuity synthesis document
- Namespaced tool specifications for agents
- RDR-008: Handoff workspace constraint research
- RDR-009: MCP memory tools rejection research

### Changed

- README revamped with AGENTS branding and improved structure
- Handoffs moved to workspace `.github/handoffs/` with global gitignore

## [0.3.0] - 2025-12-30

### Added

- Handoff agent for multi-session continuity
- Handoff workflow integration into Research/Plan/Implement agents
- RDR-007: Mitsuhiko handoff pattern research

## [0.2.0] - 2025-12-29

### Added

- RDR-005: Beads memory system analysis
- RDR-006: Agentic coding trends analysis
- Skill validation enforcement
- Review agent requires verification evidence before approval
- Testing anti-patterns documentation

### Changed

- Architecture skill aligned with CSO pattern
- Agents simplified and cleaned up

## [0.1.1] - 2025-12-28

### Added

- Research Decision Record (RDR) format for documenting decisions
- Feature-dev patterns adopted in agents

## [0.1.0] - 2025-12-27

### Added

- Commit agent with Conventional Commits support
- Review agent with handoffs and iteration tracking
- Mandatory testing requirements for agents
- Global agent installation for VS Code and Claude Code
- CRITICAL section with inviolable rules in instructions
- Automatic installation of instruction files

### Changed

- Updated workflow diagram and agent table in README
- Simplified installation instructions

## [0.0.1] - 2025-12-26

### Added

- Initial release of AGENTS framework
- 5 core agents: Research, Plan, Implement, Review, Commit
- 6 skills: debug, tech-debt, architecture, mentor, janitor, critic
- 5 instruction files: global, python, typescript, testing, terminal
- Installation script for VS Code Copilot and Claude Code
- Comprehensive documentation and synthesis from multiple frameworks
- Source materials from 12-Factor Agents, HumanLayer, CursorRIPER, Superpowers

[Unreleased]: https://github.com/mcouthon/agents/compare/v0.10.0...HEAD
[0.10.0]: https://github.com/mcouthon/agents/compare/v0.9.1...v0.10.0
[0.9.1]: https://github.com/mcouthon/agents/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/mcouthon/agents/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/mcouthon/agents/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/mcouthon/agents/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/mcouthon/agents/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/mcouthon/agents/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/mcouthon/agents/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/mcouthon/agents/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mcouthon/agents/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mcouthon/agents/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mcouthon/agents/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/mcouthon/agents/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mcouthon/agents/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mcouthon/agents/releases/tag/v0.0.1
