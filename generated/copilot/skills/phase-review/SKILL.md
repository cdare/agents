---
name: phase-review
description: "Review implementation plans for a particular phase in a larger plan for flaws before committing to them. Use when reviewing phase plans from .tasks/ directory. Triggers on: 'use phase mode', 'review phase', 'review the plan', 'check phase', 'validate phase', 'review phase N', 'check the plan for phase'."
---

# Phase Plan Review

Go over the plan for the provided phase in the linked task, and make sure it doesn't have any flaws in it. Make suggestions if you think there are changes you'd consider making (keep the full context for the task in mind).

**Do NOT modify the plan file.** Your suggestions will be returned to the orchestrating agent, which will present them to the user for adoption or rejection.

Write your review findings as your response — do not append them to the plan file.

## After Review

When the review is complete:

1. Update the phase status in `task.md` from `📋 Planned` to `⭐ Reviewed`
2. Add any review notes to the phase's Notes column if relevant

**Only update the status in task.md.** Do not modify plan files in the `plan/` directory — that's the user's decision after seeing your suggestions.
