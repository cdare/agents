# Cross-Agent Instructions

Instructions that apply to all AI agents working in this repository.

## Repository Structure

This is an agentic coding framework. Key locations:

| Path              | Contents                                                                |
| ----------------- | ----------------------------------------------------------------------- |
| `templates/`      | Source-of-truth templates for agents, skills, instructions              |
| `Makefile`        | Build targets: `make [copilot\|cc\|all\|validate]`                     |
| `scripts/`        | Generator (`generate.js`) and VS Code config scripts                    |
| `.github/agents/` | GENERATED — Copilot agent files (do not edit)                           |
| `.github/skills/` | GENERATED — Copilot skill files (do not edit)                           |
| `.claude/`        | GENERATED — Claude Code output: agents, skills, rules (do not edit)     |
| `instructions/`   | GENERATED — Copilot instructions (do not edit)                          |
| `docs/sources/`   | Reference materials from external frameworks                            |
| `docs/synthesis/` | Framework design principles and analysis                                |

## Conventions

- Follow existing patterns in the codebase
- Run `make && ./install.sh` after modifying templates
- See [README.md](README.md) for full documentation and usage instructions

## Post-Implementation

After making changes to this repository, complete these steps:

### 1. Update CHANGELOG.md

- Add changes under `## [Unreleased]` section
- Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
- Follow [Keep a Changelog](https://keepachangelog.com/) format

### 2. Update Documentation (if changes justify it)

| Change Type                | Update                                                                             |
| -------------------------- | ---------------------------------------------------------------------------------- |
| New/removed agents/skills  | [README.md](README.md) counts and tables                                           |
| Workflow changes           | [README.md](README.md) workflow section                                            |
| Framework philosophy       | [docs/synthesis/prevailing-wisdom.md](docs/synthesis/prevailing-wisdom.md)         |
| Memory/continuity patterns | [docs/synthesis/memory-and-continuity.md](docs/synthesis/memory-and-continuity.md) |
| Framework comparisons      | [docs/synthesis/framework-comparison.md](docs/synthesis/framework-comparison.md)   |

### 3. Versioning (for releases)

When ready to release:

1. Move Unreleased content to new version section: `## [X.Y.Z] - YYYY-MM-DD`
2. Add new empty Unreleased section
3. Add version link at bottom of CHANGELOG.md
4. Create git tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`

**Version increments:**

- MAJOR: Breaking changes to agent/skill format
- MINOR: New agents, skills, or features
- PATCH: Bug fixes and documentation
