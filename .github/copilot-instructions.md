# AGENTS Repo - Copilot Instructions

VS Code Copilot-specific settings for this repository.

See [AGENTS.md](../AGENTS.md) for cross-agent instructions including:

- Repository structure
- Post-implementation steps (CHANGELOG, docs, versioning)
- Conventions

## File Conventions

| Type         | Pattern                          |
| ------------ | -------------------------------- |
| Agents       | `.github/agents/*.agent.md`      |
| Skills       | `.github/skills/*/SKILL.md`      |
| Instructions | `instructions/*.instructions.md` |
| Research     | `docs/research/RDR-XXX-*.md`     |

## Testing Changes

After modifying agents or skills:

```bash
make validate
./install.sh
./tests/validate-skills.sh
./tests/test-generate.sh
```
