#!/bin/zsh
# Integration tests for scripts/generate.js

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

pass() { echo "✓ $1"; PASS=$((PASS + 1)); }
fail() { echo "✗ $1"; FAIL=$((FAIL + 1)); }

echo "Testing generate.js..."
cd "$SCRIPT_DIR"

# Test 1: --help exits 0
node scripts/generate.js --help >/dev/null 2>&1 && pass "Help flag works" || fail "Help flag failed"

# Test 2: Missing command exits 2
node scripts/generate.js >/dev/null 2>&1 && fail "Missing command should exit non-zero" || {
  code=$?
  [[ $code -eq 2 ]] && pass "Missing command exits 2" || fail "Missing command exited $code (expected 2)"
}

# Test 3: Dry run exits 0 or 1
node scripts/generate.js all --dry-run >/dev/null 2>&1; dry_code=$?
[[ $dry_code -eq 0 || $dry_code -eq 1 ]] && pass "Dry run succeeds" || fail "Dry run exited $dry_code"

# Test 4: Generate all files
node scripts/generate.js all --source "$SCRIPT_DIR/templates" >/dev/null 2>&1; gen_code=$?
[[ $gen_code -eq 0 || $gen_code -eq 1 ]] && pass "Generate all succeeds" || fail "Generate all exited $gen_code"

# Test 5: Verify Copilot agent file count
AGENT_COUNT=$(find "$SCRIPT_DIR/.github/agents" -name "*.agent.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$AGENT_COUNT" -ge 7 ]]; then
  pass "Generated $AGENT_COUNT Copilot agents (expected 7)"
else
  fail "Expected 7 Copilot agents, got $AGENT_COUNT"
fi

# Test 6: Verify Copilot skill count
SKILL_COUNT=$(find "$SCRIPT_DIR/.github/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$SKILL_COUNT" -ge 11 ]]; then
  pass "Generated $SKILL_COUNT Copilot skills (expected 11)"
else
  fail "Expected 11 Copilot skills, got $SKILL_COUNT"
fi

# Test 7: Verify Copilot instruction count
INSTR_COUNT=$(find "$SCRIPT_DIR/instructions" -name "*.instructions.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$INSTR_COUNT" -ge 5 ]]; then
  pass "Generated $INSTR_COUNT Copilot instructions (expected 5)"
else
  fail "Expected 5 Copilot instructions, got $INSTR_COUNT"
fi

# Test 8: Verify CC agent count
CC_AGENT_COUNT=$(find "$SCRIPT_DIR/.claude/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$CC_AGENT_COUNT" -ge 7 ]]; then
  pass "Generated $CC_AGENT_COUNT CC agents (expected 7)"
else
  fail "Expected 7 CC agents, got $CC_AGENT_COUNT"
fi

# Test 9: Verify CC skill count
CC_SKILL_COUNT=$(find "$SCRIPT_DIR/.claude/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$CC_SKILL_COUNT" -ge 11 ]]; then
  pass "Generated $CC_SKILL_COUNT CC skills (expected 11)"
else
  fail "Expected 11 CC skills, got $CC_SKILL_COUNT"
fi

# Test 10: Verify CC rule count
CC_RULE_COUNT=$(find "$SCRIPT_DIR/.claude/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$CC_RULE_COUNT" -ge 5 ]]; then
  pass "Generated $CC_RULE_COUNT CC rules (expected 5)"
else
  fail "Expected 5 CC rules, got $CC_RULE_COUNT"
fi

# Test 11: Idempotent - second run should report unchanged or no changes
OUTPUT=$(node scripts/generate.js all 2>&1)
node scripts/generate.js all >/dev/null 2>&1
idem_code=$?
[[ $idem_code -eq 1 ]] && pass "Idempotent: second run exits 1 (no changes)" || {
  # Check if updated shows - there should be no updates
  if echo "$OUTPUT" | grep -q "(updated)"; then
    fail "Idempotent: second run still updating files"
  else
    pass "Idempotent: no files updated on second run"
  fi
}

# Test 12: Global CC rule has no frontmatter
GLOBAL_RULE="$SCRIPT_DIR/.claude/rules/global.md"
if [[ -f "$GLOBAL_RULE" ]]; then
  first_line=$(head -1 "$GLOBAL_RULE")
  if [[ "$first_line" != "---" ]]; then
    pass "Global CC rule has no frontmatter"
  else
    fail "Global CC rule should have no frontmatter"
  fi
else
  fail "Global CC rule file not found"
fi

# Test 13: make validate exits 0
make validate >/dev/null 2>&1 && pass "make validate succeeds" || fail "make validate failed"

# Test 14: make copilot exits 0
make copilot >/dev/null 2>&1 && pass "make copilot succeeds" || fail "make copilot failed"

# Test 15: make cc exits 0
make cc >/dev/null 2>&1 && pass "make cc succeeds" || fail "make cc failed"

# Test 16: generate copilot subcommand only
node scripts/generate.js copilot >/dev/null 2>&1 && pass "Generate copilot subcommand succeeds" || fail "Generate copilot subcommand failed"

# Test 17: generate cc subcommand only
node scripts/generate.js cc >/dev/null 2>&1 && pass "Generate cc subcommand succeeds" || fail "Generate cc subcommand failed"

# Test 18: CC agents have required 'tools:' frontmatter
cc_fm_ok=true
for agent in "$SCRIPT_DIR"/.claude/agents/*.md; do
  [[ -f "$agent" ]] || continue
  if ! grep -q "^tools:" "$agent"; then
    cc_fm_ok=false
    echo "  Missing tools: in $(basename $agent)"
  fi
done
[[ "$cc_fm_ok" == true ]] && pass "CC agents have tools: frontmatter" || fail "CC agents missing tools: frontmatter"

# Test 19: CC rules with frontmatter have paths: scoping
cc_paths_ok=true
for rule in "$SCRIPT_DIR"/.claude/rules/*.md; do
  [[ -f "$rule" ]] || continue
  first_line=$(head -1 "$rule")
  # Only check rules that have frontmatter (global and terminal apply unconditionally)
  [[ "$first_line" == "---" ]] || continue
  if ! grep -q "^paths:" "$rule"; then
    cc_paths_ok=false
    echo "  Missing paths: in $(basename $rule)"
  fi
done
[[ "$cc_paths_ok" == true ]] && pass "CC rules with frontmatter have paths: scoping" || fail "CC rules missing paths: scoping"

echo ""
echo "Results: $PASS passed, $FAIL failed"
if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
echo "All tests passed!"
