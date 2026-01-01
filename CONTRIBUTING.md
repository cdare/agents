# Contributing to AGENTS

Thank you for your interest in contributing! This document provides guidelines for contributing to the AGENTS framework.

## Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/agents.git`
3. Run `./install.sh` to set up agents and skills locally
4. Make your changes
5. Test your changes (see Testing section below)
6. Submit a pull request

## Adding a Skill

Skills are auto-activating capabilities that trigger based on user prompts. See [README.md](README.md#adding-a-skill) for the basic structure.

### Community Skill Guidelines

- Keep skills under 500 lines (focus and clarity)
- Use descriptive trigger keywords in the frontmatter
- Include clear examples in the description
- Follow existing patterns in `.github/skills/`
- Test using the TDD approach (see Testing section)

### Skill Structure

```yaml
---
name: my-skill
description: >
  Trigger keywords: "keyword1", "keyword2".
  Focus on WHEN to use (symptoms), not WHAT it does.
---
# My Skill Instructions

Your instructions here...
```

## Adding an Agent

Agents are workflow phases with enforced tool restrictions. See [README.md](README.md#adding-an-agent) for the basic structure.

### Agent Guidelines

- Define clear tool restrictions
- Specify handoff targets
- Document when to use this agent
- Include model recommendations if relevant

## Testing Your Changes

### TDD for Documentation (from README)

1. **RED** - Run task WITHOUT your skill/agent, note failures
2. **GREEN** - Add your skill/agent, verify improvement
3. **REFACTOR** - If agent rationalizes around it, strengthen guidance

### Validation

```bash
# Run validation script
./tests/validate-skills.sh

# Test installation
./install.sh
```

## Code Style

- Follow existing patterns in the codebase
- Use clear, actionable language in instructions
- Prefer tables and lists for structured information
- Keep markdown clean and readable

## Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to agent/skill format
- **MINOR**: New agents, skills, or features
- **PATCH**: Bug fixes and documentation

Releases are tagged as `vX.Y.Z` (e.g., `v0.1.0`).

## Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/mcouthon/agents/discussions)
- **Bugs**: Open an [issue](https://github.com/mcouthon/agents/issues/new/choose)
- **Feature Ideas**: Use the Feature Request template

## Pull Request Process

1. Update README.md if adding new agents/skills
2. Run `./install.sh` and test locally
3. Run `./tests/validate-skills.sh` if modifying skills
4. Fill out the PR template completely
5. Wait for review and address feedback
