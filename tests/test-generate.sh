#!/bin/bash
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

# Test 13: Copilot snapshot parity
SNAPSHOT_DIR="$SCRIPT_DIR/.tasks/017-cc-full-compatibility/snapshots/copilot"
if [[ -d "$SNAPSHOT_DIR" ]]; then
  parity_ok=true
  for snap_dir in agents skills instructions; do
    if [[ -d "$SNAPSHOT_DIR/$snap_dir" ]]; then
      case "$snap_dir" in
        agents)     gen_dir="$SCRIPT_DIR/.github/agents" ;;
        skills)     gen_dir="$SCRIPT_DIR/.github/skills" ;;
        instructions) gen_dir="$SCRIPT_DIR/instructions" ;;
      esac
      if ! diff -rq "$SNAPSHOT_DIR/$snap_dir" "$gen_dir" >/dev/null 2>&1; then
        parity_ok=false
        echo "  Diff found in $snap_dir:"
        diff -r "$SNAPSHOT_DIR/$snap_dir" "$gen_dir" 2>&1 | head -20
      fi
    fi
  done
  [[ "$parity_ok" == true ]] && pass "Copilot output matches snapshots" || fail "Copilot output differs from snapshots"
else
  pass "No snapshot dir found (skipping parity check)"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
echo "All tests passed!"
