# Claude Code Memory

Source: https://code.claude.com/docs/en/memory (fetched 2026-02-17)

## Memory Types

| Type           | Location                                            | Scope        | Shared          |
| -------------- | --------------------------------------------------- | ------------ | --------------- |
| Managed policy | `/Library/Application Support/ClaudeCode/CLAUDE.md` | Organization | Yes             |
| Project memory | `./CLAUDE.md` or `./.claude/CLAUDE.md`              | Project      | Yes (VCS)       |
| Project rules  | `./.claude/rules/*.md`                              | Project      | Yes (VCS)       |
| User memory    | `~/.claude/CLAUDE.md`                               | All projects | No              |
| Project local  | `./CLAUDE.local.md`                                 | Project      | No (gitignored) |
| Auto memory    | `~/.claude/projects/<project>/memory/`              | Per project  | No              |

More specific instructions take precedence over broader ones.

## CLAUDE.md Format

Plain markdown file with instructions for Claude:

```markdown
# Project Instructions

## Build Commands

- `npm run build` - Build the project
- `npm test` - Run tests

## Code Style

- Use TypeScript with strict mode
- Prefer functional components in React
- Always include JSDoc comments

## Architecture

- Services in src/services/
- Components in src/components/
- Utils in src/utils/
```

## CLAUDE.md Imports

Import other files using `@path/to/import`:

```markdown
See @README for project overview.
See @package.json for available commands.

# Additional Instructions

- Git workflow: @docs/git-instructions.md
```

- Relative paths resolve relative to the file containing the import
- Max depth: 5 hops for recursive imports
- Not evaluated inside code blocks

## Modular Rules (.claude/rules/)

Organize instructions into multiple files:

```
.claude/
├── CLAUDE.md           # Main project instructions
└── rules/
    ├── code-style.md   # Code style guidelines
    ├── testing.md      # Testing conventions
    └── security.md     # Security requirements
```

All `.md` files in `.claude/rules/` automatically loaded as project memory.

### Path-Specific Rules

Use YAML frontmatter with `paths:` to scope rules:

```yaml
---
paths:
  - "src/api/**/*.ts"
---
# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

Rules without `paths:` apply to all files.

### Glob Patterns

| Pattern             | Matches                    |
| ------------------- | -------------------------- |
| `**/*.ts`           | All TypeScript files       |
| `src/**/*`          | All files under src/       |
| `*.md`              | Markdown files in root     |
| `src/**/*.{ts,tsx}` | TypeScript and TSX in src/ |

Multiple patterns:

```yaml
---
paths:
  - "src/**/*.ts"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
---
```

### User-Level Rules

Personal rules that apply to all projects:

```
~/.claude/rules/
├── preferences.md    # Personal coding preferences
└── workflows.md      # Preferred workflows
```

User rules load before project rules (lower priority).

## Auto Memory

Claude automatically saves learnings to `~/.claude/projects/<project>/memory/`:

```
~/.claude/projects/<project>/memory/
├── MEMORY.md          # Index, loaded into every session (first 200 lines)
├── debugging.md       # Detailed debugging notes
├── api-conventions.md # API design decisions
└── ...                # Other topic files
```

### What Claude Remembers

- Project patterns (build commands, test conventions)
- Debugging insights (solutions, common errors)
- Architecture notes (key files, module relationships)
- Your preferences (communication style, tool choices)

### Managing Auto Memory

```bash
# Disable auto memory
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1

# Force auto memory on
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0
```

Use `/memory` command to open memory files in editor.

## Memory Lookup

Claude reads memories recursively from cwd up to root:

- `project/subdir/CLAUDE.md`
- `project/CLAUDE.md`
- (stops before root)

CLAUDE.md in subdirectories loaded on-demand when Claude reads files there.

### Additional Directories

```bash
# Load memory from additional directories
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config
```

## Best Practices

1. **Be specific**: "Use 2-space indentation" > "Format code properly"
2. **Use structure**: Bullet points grouped under markdown headings
3. **Review periodically**: Update as project evolves
4. **Use .claude/rules/** for large projects: One topic per file
5. **Use CLAUDE.local.md** for personal preferences (gitignored)
