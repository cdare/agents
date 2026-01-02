# AGENTS Repo Development Instructions

Instructions for AI agents working on the AGENTS framework itself.

## Versioning & Releases

When making changes that warrant a version bump:

1. **Determine Version Increment** (Semantic Versioning):

   - **MAJOR**: Breaking changes to agent/skill format
   - **MINOR**: New agents, skills, or features
   - **PATCH**: Bug fixes and documentation

2. **Update CHANGELOG.md**:

   - Add changes under `## [Unreleased]` section
   - Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
   - Include links to relevant files/PRs

3. **When Ready to Release**:

   - Move Unreleased content to new version section: `## [X.Y.Z] - YYYY-MM-DD`
   - Add new empty Unreleased section
   - Add version link at bottom of file
   - Update README.md if version is mentioned

4. **Create Git Tag**:
   ```bash
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin vX.Y.Z
   ```

## File Conventions

- Agents: `.github/agents/*.agent.md`
- Skills: `.github/skills/*/SKILL.md`
- Instructions: `instructions/*.instructions.md`
- Research: `docs/research/RDR-XXX-*.md`

## Testing Changes

After modifying agents or skills:

```bash
./install.sh
./tests/validate-skills.sh
```
