#!/bin/bash
#
# Test configure-vscode-settings.js with various scenarios
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

echo "Test directory: $TEST_DIR"
echo ""

run_test() {
    local name="$1"
    local input="$2"
    local expected_exit="$3"
    
    echo "=== Test: $name ==="
    echo "$input" > "$TEST_DIR/settings.json"
    
    set +e
    node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json"
    local exit_code=$?
    set -e
    
    echo "Exit code: $exit_code (expected: $expected_exit)"
    
    if [[ $exit_code -ne $expected_exit ]]; then
        echo "❌ FAILED: Wrong exit code"
        return 1
    fi
    
    echo "Result:"
    cat "$TEST_DIR/settings.json"
    echo ""
    echo ""
    return 0
}

verify_contains() {
    local file="$1"
    local pattern="$2"
    if grep -q "$pattern" "$file"; then
        echo "✓ Contains: $pattern"
        return 0
    else
        echo "❌ Missing: $pattern"
        return 1
    fi
}

# Test 1: Empty object
run_test "Empty object" '{}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/instructions"'

# Test 2: Existing settings, no agent config
run_test "Existing settings" '{
  "editor.fontSize": 14,
  "terminal.integrated.fontSize": 12
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"editor.fontSize"'

# Test 3: Agent setting exists but without our entry
run_test "Setting exists, missing entry" '{
  "chat.agentFilesLocations": {
    "other/path": true
  }
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"other/path"'

# Test 4: Already configured (should exit 1)
run_test "Already configured" '{
  "chat.agentFilesLocations": {
    "~/.copilot/agents": true
  },
  "chat.instructionsFilesLocations": {
    "~/.copilot/instructions": true
  }
}' 1

# Test 5: Setting exists but is empty dict (no trailing comma issue)
run_test "Empty setting dict" '{
  "chat.agentFilesLocations": {}
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
# Verify no invalid trailing comma before }
if grep -q 'true,}' "$TEST_DIR/settings.json"; then
    echo "❌ Invalid trailing comma found"
else
    echo "✓ No trailing comma issue"
fi

# Test 6: With comments (JSONC)
run_test "With comments" '{
  // This is a comment
  "editor.fontSize": 14,
  /* block comment */
  "terminal.integrated.fontSize": 12
  // trailing comment
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '// This is a comment'

# Test 7: Trailing comma (common in VS Code settings)
run_test "Trailing comma" '{
  "editor.fontSize": 14,
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'

# Test 8: Complex nested structure
run_test "Complex nested" '{
  "[python]": {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit"
    }
  },
  "chat.agentFilesLocations": {
    "workspace/agents": true
  }
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"source.fixAll"'

echo ""
echo "=== All tests completed ==="
