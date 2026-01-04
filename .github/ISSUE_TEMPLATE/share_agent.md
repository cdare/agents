---
name: Share Your Agent
about: Share a custom agent workflow you've created
labels: community-contribution, agent
---

## Agent Name

[Name of your agent]

## Purpose

[What is this agent's role? What phase of work does it handle?]

## Tool Restrictions

[Which tools should this agent have access to?]

Example: `['codebase', 'search', 'editFiles']`

## Handoff Flow

[Where does this agent fit in the workflow? What agents hand off to it? What agents does it hand off to?]

Example:

```
Explore → [Your Agent] → Implement
```

## Agent Code

[Paste your agent code here, or link to a gist/branch]

```yaml
---
name: my-agent
description: What this agent does
tools: ["codebase", "search"]
handoffs:
  - label: Next Step
    agent: implement
---
# Agent instructions here
```

## Use Case

[Provide a concrete example of when you'd use this agent]
