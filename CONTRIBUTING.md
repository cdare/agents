# Contributing to AGENTS

Thank you for your interest in contributing! This document provides guidelines for contributing to the AGENTS framework.

## Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/agents.git`
3. Run `make && ./install.sh` to generate files and set up agents locally
4. Make your changes
5. If you modified templates, run `make` to regenerate output files
6. Test your changes (see Testing section below)
7. Submit a pull request

## Adding a Skill

Skills are auto-activating capabilities that trigger based on user prompts. Create a template at `templates/skills/my-skill/SKILL.template.md`. See [templates/README.md](templates/README.md) for the template format.

Then regenerate and install:

```bash
make && ./install.sh
```

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

Agents are workflow phases with enforced tool restrictions. Create a template at `templates/agents/my-agent.template.md`. See [templates/README.md](templates/README.md) for the template format.

Then regenerate and install:

```bash
make && ./install.sh
```

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
make validate                 # Verify generated files match templates
./tests/validate-skills.sh   # Validate skill format
./tests/test-generate.sh     # Test generator
./install.sh                  # Test installation
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

1. If you modified templates, run `make` and commit generated files
2. Run `make validate` to verify consistency
3. Update README.md if adding new agents/skills
4. Run `./install.sh` and test locally
5. Run `./tests/validate-skills.sh` if modifying skills
6. Fill out the PR template completely
7. Wait for review and address feedback
