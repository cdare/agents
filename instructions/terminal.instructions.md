---
applyTo: "**"
---

# Terminal & CLI Instructions

## CRITICAL: Inviolable Rules

These rules have the highest priority and must never be violated.

1. **Long terminal commands**: NEVER attempt to run ANY commands in the terminal that exceed 5-7 lines. ALWAYS either break them down into smaller commands, or use IDE file editing tools to create a script file.

2. **Long outputs**: if there's a chance a terminal command might exceed 5-10 lines of output, pipe it to `head` or `tail`, or else use `cat` or `grep` to limit output.

## Shell Commands

- Target shell: **zsh** on macOS
- Use `ag` (The Silver Searcher) instead of `rg` for searching
- Use `docker-compose` instead of `docker compose`
- Quote variables: `"$var"` instead of `$var`

## File Operations

- Use `gh` CLI for GitHub operations
- See **CRITICAL** rules in global.instructions.md for file editing restrictions

## GitHub CLI (`gh`)

- Pipe output to `cat` to avoid interactive mode: `gh run view | cat`
- Use `gh api` for raw content from other repos

```zsh
# Fetch file from another repo
gh api repos/owner/repo/contents/path/to/file \
  -H "Accept: application/vnd.github.raw" > /tmp/file.txt

# View workflow run non-interactively
gh run view 12345 | cat
```
