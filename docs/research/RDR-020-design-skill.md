# Research Decision Record: Design Skill

| Field        | Value                                                                    |
| ------------ | ------------------------------------------------------------------------ |
| **Source**   | [claude-design-skill](https://github.com/Dammyjay93/claude-design-skill) |
| **Reviewed** | 2026-01-10                                                               |
| **Status**   | Adopted                                                                  |

## Summary

A Claude Code skill that enforces precise, minimal design principles for enterprise UIs, SaaS dashboards, and admin interfaces. Inspired by Linear, Notion, and Stripe aesthetics—Jony Ive-level precision with intentional personality.

## Key Concepts

| Concept              | Description                                                                    |
| -------------------- | ------------------------------------------------------------------------------ |
| Design Direction     | Commit to a personality before coding: precision, warmth, sophistication, etc. |
| 4px Grid System      | All spacing uses multiples of 4px for consistency                              |
| Depth Strategy       | Choose ONE approach: borders-only, subtle shadows, or layered shadows          |
| Color for Meaning    | Gray builds structure; color only for status, action, error                    |
| Symmetrical Padding  | TLBR should match; asymmetry requires justification                            |
| Typography Hierarchy | Headlines 600 weight, body 400-500, clear scale                                |
| Anti-Patterns        | No bouncy animations, dramatic shadows, large radius on small elements         |

## Decision

**Adopted:** Full skill with adaptations for AGENTS philosophy

**Adaptations made:**

1. Added YAML frontmatter with trigger keywords following AGENTS skill description pattern
2. Maintained core principles (4px grid, depth strategy, typography hierarchy)
3. Kept under 500 lines (source was 237 lines, well within limit)
4. Adjusted description to focus on symptoms/triggers, not workflow summary
5. Added context about when to use (dashboards, admin interfaces, etc.)

**Rationale:** This is a high-quality, opinionated design skill that fills a gap in AGENTS—there's no current skill for UI/UX design guidance. The principles are concrete, actionable, and based on proven patterns from best-in-class products. The skill is already appropriately sized (<500 lines) and focused on a single domain.

## Comparison to Current Framework

**Gap filled:** AGENTS has skills for debugging, architecture, tech-debt, mentoring, and criticism, but nothing for design/UI. This complements the existing set.

**Philosophy alignment:**

- ✅ Clear trigger conditions (dashboards, UI, design system, admin interface)
- ✅ Actionable guidance with specific values (4px, 8px, 12px...)
- ✅ Anti-patterns clearly stated
- ✅ Progressive disclosure (main concepts up front, details follow)
- ✅ Under 500 lines

**No conflicts with existing skills.**
