# Research Decision Record: Agno Framework

| Field        | Value                                         |
| ------------ | --------------------------------------------- |
| **Source**   | https://www.agno.com/, https://docs.agno.com/ |
| **Reviewed** | 2026-01-10                                    |
| **Status**   | Rejected                                      |

## Summary

Agno is a high-performance open-source Python framework for building multi-agent systems, paired with a commercial "AgentOS" control plane for deployment and monitoring. It emphasizes performance (529x faster than LangGraph), modular architecture, and privacy-first design where all data stays in your cloud.

## Key Concepts

| Concept        | Description                                                                                                                            |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **Agents**     | AI programs where a model controls execution flow using tools, instructions, memory, knowledge, and reasoning                          |
| **Teams**      | Collections of agents/sub-teams that work together; a team leader delegates tasks to members                                           |
| **Workflows**  | Deterministic step-by-step orchestration of agents, teams, and functions—contrast with Teams' dynamic coordination                     |
| **Tools**      | Python functions auto-converted to JSON schema tool definitions; supports MCP servers, toolkits, and concurrent execution              |
| **Memory**     | Persistent user facts across sessions (automatic or agentic); stored in database                                                       |
| **Knowledge**  | Vector DB-backed RAG for domain-specific information retrieval at runtime                                                              |
| **Reasoning**  | Three approaches: reasoning models (native CoT), reasoning tools (think/analyze functions), reasoning agents (prompt-engineered CoT)   |
| **AgentOS**    | Runtime + control plane for running agents as APIs with built-in monitoring, sessions, and state management                            |
| **Delegation** | Team leaders route tasks to specialized members; supports passthrough/router patterns, parallel execution, and direct member responses |

## Decision

**Adopted:** None

**Rationale:**

Agno is a **fundamentally different category** from the AGENTS framework:

1. **Python runtime framework vs. AI instruction framework**: Agno is code you run (`pip install agno`), while AGENTS is markdown instructions that guide AI agents in IDEs like VS Code Copilot or Claude Code. They're complementary, not competitive.

2. **Multi-agent orchestration vs. human-AI workflow**: Agno focuses on running multiple AI agents programmatically in production (APIs, databases, deployments). AGENTS focuses on a single developer working with AI agents through phases (Explore → Implement → Review → Commit).

3. **No transferable patterns**: Agno's concepts (Teams, Workflows, Delegation) are implementation details for Python orchestration. AGENTS already has phase-based workflows, context management, and human-in-the-loop principles that serve the IDE-based workflow.

4. **Commercial product**: AgentOS is a paid control plane for running production agents. Not relevant to IDE-based agentic coding.

**Interesting observations (for reference, not adoption):**

- **Teams vs Workflows distinction**: Teams = dynamic/flexible coordination; Workflows = deterministic/predictable steps. This reinforces AGENTS' existing approach where Explore is exploratory and Implement follows a plan.
- **Reasoning approaches**: The three approaches (models, tools, agents) are a nice taxonomy, but AGENTS already handles this via model selection and chain-of-thought prompting.
- **Passthrough/router pattern**: Team leaders that just route without processing—similar to how AGENTS routes between modes.

## Comparison to Current Framework

| Aspect            | Agno                              | AGENTS                                    |
| ----------------- | --------------------------------- | ----------------------------------------- |
| **Type**          | Python library + cloud platform   | Markdown-based AI instructions            |
| **Target**        | Production multi-agent systems    | IDE-based developer workflows             |
| **Execution**     | Python runtime, FastAPI endpoints | VS Code Copilot, Claude Code              |
| **Agents**        | Multiple coordinating agents      | Single agent with multiple modes          |
| **Human-in-loop** | Via AgentOS UI or custom code     | Built into phase transitions              |
| **Memory**        | Database-backed per-user memory   | Task-centric file persistence (`.tasks/`) |
| **Context**       | Session history, knowledge bases  | Context engineering, handoff documents    |

**Conclusion:** Agno would be relevant if building a Python application that orchestrates AI agents, but it doesn't inform how to instruct AI agents in an IDE workflow.
