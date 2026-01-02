# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_No changes yet._

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

[Unreleased]: https://github.com/mcouthon/agents/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/mcouthon/agents/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/mcouthon/agents/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/mcouthon/agents/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mcouthon/agents/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mcouthon/agents/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mcouthon/agents/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/mcouthon/agents/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mcouthon/agents/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mcouthon/agents/releases/tag/v0.0.1
