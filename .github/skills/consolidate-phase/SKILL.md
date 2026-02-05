---
name: consolidate-task
description: >
  Summarize a completed task into an architectural decision record. Used to reduce the need to keep unnecessary tasks in the .tasks/ directory.

  Triggers on: "consolidate-task", "consolidate task", "summarize task", "use consolidate task mode".
---

# Summarize Task to Architectural Decision Record

Read the task file at `.tasks/{task-folder}/task.md` and create an architecture decision summary in `.tasks/architecture/ADR-NNN-{decision-name}.md` (where NNN is the next available number).

## Output Format

````markdown
# {Decision Title}

**Source:** Task {NNN} ({Month Year})

## Decision

One sentence describing the high-level architectural choice.

## Why

- Bullet points explaining the motivation
- Focus on problems solved, not implementation details

## Problem Statement (if applicable)

What issue prompted this change? What was broken or suboptimal?

## Solution

Brief description with before/after comparison:

### Before

{Old approach - can include diagrams or code}

### After

{New approach - can include diagrams or code}

## Implementation Phases

| Phase     | What Changed       |
| --------- | ------------------ |
| 1. {Name} | {One-line summary} |
| ...       | ...                |

## Key Architectural Patterns

Include 2-3 code snippets showing the most important patterns established.
Only patterns that future developers need to understand and follow.

## Current Structure

```
relevant/directory/
├── file1.py # Brief purpose
├── file2.py # Brief purpose
```

## Deleted

- List of deleted files/code (shows what was replaced)
````

## Guidelines

1. **High-level only** — Skip implementation details that don't affect architecture
2. **Focus on patterns** — What should future code follow?
3. **Include deletions** — Shows what was replaced, not just what was added
4. **Code examples** — Only for patterns that repeat across the codebase
5. **Keep it scannable** — Tables and bullets over paragraphs

## After Creating

1. Update `.tasks/architecture/README.md` (create if missing with a decisions table)
2. Delete or archive the original task folder
