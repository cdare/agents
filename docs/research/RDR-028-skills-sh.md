# RDR-028: Skills.sh Ecosystem Review

**Status:** Partially Adopted  
**Date:** 2025-01-27

## Source

- [skills.sh](https://skills.sh/) - Open agent skills ecosystem by Vercel
- [anthropics/skills](https://github.com/anthropics/skills) - Official Anthropic skills
- [trailofbits/skills](https://github.com/trailofbits/skills) - Security-focused skills ⭐
- [getsentry/skills](https://github.com/getsentry/skills) - Engineering practices
- [obra/superpowers](https://github.com/obra/superpowers) - TDD/debugging methodology ⭐

## Finding

Reviewed ~80 skills across the skills.sh ecosystem. Our SKILL.md format is fully compatible—same YAML frontmatter, markdown body, progressive disclosure pattern.

### High-Value Discoveries

| Repo                   | Notable Skills                                                                | Relevance to AGENTS                                                          |
| ---------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **obra/superpowers**   | systematic-debugging, test-driven-development, verification-before-completion | Enhances debug skill with 4-phase process, rationalization prevention tables |
| **trailofbits/skills** | differential-review, sharp-edges, code-maturity-assessor                      | Security review patterns for critic skill, "blast radius" concept            |
| **getsentry/skills**   | commit, create-pr, iterate-pr, find-bugs                                      | Git workflow automation, PR iteration patterns                               |

### Patterns Worth Adopting

1. **Rationalization Prevention Tables** (obra/trailofbits)
   - `| Excuse | Reality | Required Action |` format
   - Explicit counters to agent shortcuts

2. **Four-Phase Debugging** (obra)
   - Root Cause → Pattern Analysis → Hypothesis Testing → Implementation
   - "NEVER fix symptom" mandate with redundancy

3. **Blast Radius Calculation** (trailofbits)
   - Quantify change impact by counting callers
   - Risk classification (HIGH/MEDIUM/LOW)

### Not Adopted

- Framework-specific skills (React, Vue, Next.js, etc.) - out of scope
- Document format skills (pdf, docx, pptx) - proprietary/source-available
- Claude Code-specific plugin mechanics - different runtime

## Decision

**Partially Adopted:**

- Study rationalization prevention pattern for critic and debug skills
- Consider systematic-debugging 4-phase process for debug skill
- Reference getsentry commit conventions as pattern example

**Not Adopted:**

- Direct skill imports (format compatible but context differs)
- Anthropic creative skills (domain-specific)

## References

- [RDR-004](RDR-004-superpowers.md) - Previous obra/superpowers review
- Skill format spec: [agentskills.io/specification](https://agentskills.io/specification)
