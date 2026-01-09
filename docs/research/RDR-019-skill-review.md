# Research Decision Record: Skill Review

| Field        | Value             |
| ------------ | ----------------- |
| **Source**   | Internal review   |
| **Reviewed** | 2026-01-09        |
| **Status**   | Partially Adopted |

## Summary

A systematic review of the 6 existing skills (architecture, critic, debug, janitor, mentor, tech-debt) against the framework's skill quality criteria from Superpowers and prevailing wisdom. The goal is to identify skills to remove, improve, or keep as-is.

## Evaluation Criteria

From prevailing wisdom and Superpowers:

1. **Distinct Value** - Does it provide guidance an agent wouldn't do naturally?
2. **Trigger Clarity** - Are activation keywords specific and discoverable?
3. **Constraint/Mode Shift** - Does it meaningfully change agent behavior?
4. **Size** - Is the skill <500 lines (progressive disclosure)?
5. **Overlap** - Does it overlap significantly with other skills?
6. **TDD Testable** - Can you observe failure without it, success with it?

## Skill Analysis

### 1. `debug` ✅ KEEP (Strong)

| Criterion       | Score | Notes                                              |
| --------------- | ----- | -------------------------------------------------- |
| Distinct Value  | ✅    | Hypothesis-driven investigation vs guess-and-fix   |
| Trigger Clarity | ✅    | Clear: "debug", "failing", "broken", "bug"         |
| Constraint/Mode | ✅    | Forces 4-phase process, hypothesis template        |
| Size            | ✅    | ~130 lines, focused                                |
| Overlap         | ⚠️    | Minor overlap with tech-debt (finding issues)      |
| TDD Testable    | ✅    | Without: random changes. With: systematic approach |

**Verdict**: Strong skill with clear value. No changes needed.

---

### 2. `mentor` ✅ KEEP (Strong)

| Criterion       | Score | Notes                                                    |
| --------------- | ----- | -------------------------------------------------------- |
| Distinct Value  | ✅    | Socratic method is opposite of normal "help" behavior    |
| Trigger Clarity | ✅    | Clear: "teach me", "guide", "don't give me the answer"   |
| Constraint/Mode | ✅    | Forces questions-only, fundamentally changes interaction |
| Size            | ✅    | ~130 lines, focused                                      |
| Overlap         | ❌    | Unique approach                                          |
| TDD Testable    | ✅    | Without: gives answers. With: asks questions             |

**Verdict**: Strong skill. Uniquely constrains agent to teaching mode. No changes.

---

### 3. `critic` ✅ KEEP (Strong)

| Criterion       | Score | Notes                                            |
| --------------- | ----- | ------------------------------------------------ |
| Distinct Value  | ✅    | Adversarial thinking is unnatural for helpful AI |
| Trigger Clarity | ✅    | Clear: "challenge", "devil's advocate", "5 whys" |
| Constraint/Mode | ✅    | Forces questioning without solutions             |
| Size            | ✅    | ~140 lines, focused                              |
| Overlap         | ⚠️    | Some overlap with mentor (questioning)           |
| TDD Testable    | ✅    | Without: suggests fixes. With: probes weaknesses |

**Verdict**: Strong skill. Distinct from mentor (adversarial vs educational). Keep.

---

### 4. `architecture` ⚠️ KEEP (Needs Polish)

| Criterion       | Score | Notes                                                   |
| --------------- | ----- | ------------------------------------------------------- |
| Distinct Value  | ⚠️    | Standard architecture documentation isn't novel         |
| Trigger Clarity | ✅    | Clear: "architecture", "system design", "diagram"       |
| Constraint/Mode | ⚠️    | Scope mantra is helpful, but mostly format guidance     |
| Size            | ✅    | ~160 lines, within limits                               |
| Overlap         | ❌    | Unique documentation focus                              |
| TDD Testable    | ⚠️    | Without: detailed code analysis. With: high-level focus |

**Recommendations**:

- Strengthen the "interfaces in, interfaces out" constraint
- Add explicit anti-pattern: "Don't describe implementation details"
- The scope mantra is the key differentiator - emphasize it more

---

### 5. `janitor` ⚠️ MERGE into `tech-debt` (Significant Overlap)

| Criterion       | Score | Notes                                                        |
| --------------- | ----- | ------------------------------------------------------------ |
| Distinct Value  | ⚠️    | Deletion focus is good, but overlaps heavily                 |
| Trigger Clarity | ✅    | Clear: "clean up", "remove dead code", "delete"              |
| Constraint/Mode | ⚠️    | "Deletion is the most powerful refactoring"                  |
| Size            | ✅    | ~140 lines                                                   |
| Overlap         | 🔴    | **Heavy overlap with tech-debt** (dead code, unused imports) |
| TDD Testable    | ⚠️    | Marginal improvement over tech-debt                          |

**Analysis of Overlap**:

| What janitor does        | Already in tech-debt? |
| ------------------------ | --------------------- |
| Remove dead code         | ✅ "Debt Indicators"  |
| Unused imports/variables | ✅ "Debt Indicators"  |
| Debug artifacts          | ✅ "Quick Wins"       |
| Redundancy/DRY           | ✅ "Code Smells"      |
| Commented-out code       | ✅ "Dead Code"        |

**Verdict**: Merge janitor into tech-debt. Key concepts to preserve:

- "Deletion is the most powerful refactoring" philosophy
- Safe deletion patterns section
- Cleanup report format

---

### 6. `tech-debt` ⚠️ EXPAND (Absorb janitor)

| Criterion       | Score | Notes                                             |
| --------------- | ----- | ------------------------------------------------- |
| Distinct Value  | ✅    | Systematic debt cataloging is valuable            |
| Trigger Clarity | ✅    | Clear: "tech debt", "TODOs", "code smells"        |
| Constraint/Mode | ⚠️    | Scan/Categorize/Prioritize is structured          |
| Size            | ✅    | ~140 lines, room to absorb janitor                |
| Overlap         | 🔴    | Overlaps with janitor                             |
| TDD Testable    | ✅    | Without: random fixes. With: prioritized approach |

**Recommendation**: Absorb janitor's best content:

- Add "deletion is the most powerful refactoring" philosophy
- Add safe deletion patterns
- Rename to `tech-debt` (keep name, expand scope)

## Decision

### Remove: `janitor`

**Rationale**: ~80% overlap with `tech-debt`. Having both dilutes trigger keywords and confuses activation. The "deletion philosophy" is valuable but can be absorbed.

### Improve: `tech-debt`

Absorb janitor's key content:

- Add the deletion philosophy upfront
- Add safe deletion patterns section
- Expand cleaning checklist

### Improve: `architecture`

- Strengthen scope constraint language
- Add explicit "what NOT to include" examples

### Keep As-Is: `debug`, `mentor`, `critic`

These three skills are strong with distinct behavioral constraints.

## Updated Skill Summary

| Skill          | Status                         | Key Strength                        |
| -------------- | ------------------------------ | ----------------------------------- |
| `debug`        | ✅ Keep                        | Hypothesis-driven investigation     |
| `mentor`       | ✅ Keep                        | Questions-only teaching             |
| `critic`       | ✅ Keep                        | Adversarial probing, no solutions   |
| `architecture` | ⚠️ Polish                      | High-level focus, scope mantra      |
| `tech-debt`    | ⚠️ Expand                      | Prioritized debt catalog + deletion |
| `janitor`      | 🔴 Remove (merge to tech-debt) | Philosophy absorbed into tech-debt  |

## Implementation

1. Update `tech-debt/SKILL.md` to absorb janitor content
2. Remove `janitor/` skill directory
3. Polish `architecture/SKILL.md` with stronger constraints
4. Update README skill table (6 → 5 skills)
5. Run `./install.sh` to update symlinks

## Notes

- Skill count reduction (6 → 5) is a feature, not a bug: "Less is more"
- Future skills should pass the overlap test before creation
- The TDD testing approach (RED/GREEN/REFACTOR) should be applied to new skills
