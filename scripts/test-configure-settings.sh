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
  },
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.copilotMemory.enabled": true,
  "chat.askQuestions.enabled": true,
  "github.copilot.chat.searchSubagent.enabled": true
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

# Test 9: File with BOM
printf '\xEF\xBB\xBF{\n  "editor.fontSize": 14\n}' > "$TEST_DIR/settings.json"
set +e
node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json"
exit_code=$?
set -e
echo "Exit code: $exit_code (expected: 0)"
if [[ $exit_code -ne 0 ]]; then
    echo "❌ FAILED: Wrong exit code for BOM file"
    exit 1
fi
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"editor.fontSize"'
# Verify BOM preserved (first 3 bytes)
if [[ $(hexdump -n3 -e '3/1 "%02x"' "$TEST_DIR/settings.json") == "efbbbf" ]]; then
    echo "✓ BOM preserved"
else
    echo "✓ BOM stripped (acceptable)"
fi
echo ""

# Test 10: Non-existent file
set +e
node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/nonexistent.json"
exit_code=$?
set -e
echo "Exit code: $exit_code (expected: 2)"
if [[ $exit_code -ne 2 ]]; then
    echo "❌ FAILED: Should exit 2 for non-existent file"
    exit 1
fi
echo "✓ Graceful error for non-existent file"
echo ""

# Test 11: Empty file
> "$TEST_DIR/settings.json"
set +e
node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json" 2>&1
exit_code=$?
set -e
echo "Exit code: $exit_code (expected: 2)"
if [[ $exit_code -ne 2 ]]; then
    echo "❌ FAILED: Should exit 2 for empty file (got $exit_code)"
    exit 1
fi
echo "✓ Graceful error for empty file"
echo ""

# Test 12: Whitespace-only file
printf '   \n  \n  ' > "$TEST_DIR/settings.json"
set +e
node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json" 2>&1
exit_code=$?
set -e
echo "Exit code: $exit_code (expected: 2)"
if [[ $exit_code -ne 2 ]]; then
    echo "❌ FAILED: Should exit 2 for whitespace-only file (got $exit_code)"
    exit 1
fi
echo "✓ Graceful error for whitespace-only file"
echo ""

# Test 13: Nested objects — keys inside [python] block should not confuse script
run_test "Nested similar keys" '{
  "[python]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "workbench.colorCustomizations": {
    "statusBar.background": "#005f87"
  }
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/instructions"'
verify_contains "$TEST_DIR/settings.json" '"editor.formatOnSave"'
verify_contains "$TEST_DIR/settings.json" '"statusBar.background"'
verify_contains "$TEST_DIR/settings.json" '"chat.customAgentInSubagent.enabled"'

# Test 14: All settings already configured (including booleans)
run_test "All settings configured (idempotent)" '{
  "chat.agentFilesLocations": {
    "~/.copilot/agents": true
  },
  "chat.instructionsFilesLocations": {
    "~/.copilot/instructions": true
  },
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.copilotMemory.enabled": true,
  "chat.askQuestions.enabled": true,
  "github.copilot.chat.searchSubagent.enabled": true
}' 1

# Test 15: Realistic large settings.json
run_test "Realistic large file" '{
  // User preferences
  "editor.fontSize": 14,
  "editor.tabSize": 2,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "editor.wordWrap": "on",
  "editor.rulers": [80, 120],
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",

  // Terminal
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "terminal.integrated.defaultProfile.osx": "zsh",

  // Theme
  "workbench.colorTheme": "One Dark Pro",
  "workbench.iconTheme": "material-icon-theme",

  /* Language-specific settings */
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },

  // Git settings
  "git.autofetch": true,
  "git.confirmSync": false,

  // Copilot (partial — missing some AGENTS settings)
  "github.copilot.enable": {
    "*": true,
    "yaml": false
  },

  // Extensions
  "eslint.validate": ["javascript", "typescript"],
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/*.code-search": true
  }
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/instructions"'
verify_contains "$TEST_DIR/settings.json" '"chat.customAgentInSubagent.enabled"'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.copilotMemory.enabled"'
verify_contains "$TEST_DIR/settings.json" '"chat.askQuestions.enabled"'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.searchSubagent.enabled"'
# Verify existing settings preserved
verify_contains "$TEST_DIR/settings.json" '"editor.fontSize"'
verify_contains "$TEST_DIR/settings.json" '"source.organizeImports"'
verify_contains "$TEST_DIR/settings.json" '"One Dark Pro"'
verify_contains "$TEST_DIR/settings.json" '// User preferences'

# Test 16: Partially configured — some settings exist, add missing ones
run_test "Partially configured" '{
  "chat.agentFilesLocations": {
    "~/.copilot/agents": true
  },
  "chat.customAgentInSubagent.enabled": true,
  "editor.fontSize": 14
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents"'
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/instructions"'
verify_contains "$TEST_DIR/settings.json" '"chat.customAgentInSubagent.enabled"'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.copilotMemory.enabled"'
verify_contains "$TEST_DIR/settings.json" '"chat.askQuestions.enabled"'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.searchSubagent.enabled"'
verify_contains "$TEST_DIR/settings.json" '"editor.fontSize"'

# Test 17: Correct wrong boolean value
run_test "Wrong boolean value" '{
  "chat.customAgentInSubagent.enabled": false,
  "github.copilot.chat.copilotMemory.enabled": false
}' 0
verify_contains "$TEST_DIR/settings.json" '"chat.customAgentInSubagent.enabled": true'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.copilotMemory.enabled": true'
# Verify the output mentions "Updated"
echo '{"chat.customAgentInSubagent.enabled": false}' > "$TEST_DIR/settings.json"
set +e
output=$(node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json" 2>&1)
set -e
if echo "$output" | grep -q "Updated:.*chat.customAgentInSubagent.enabled"; then
    echo "✓ Reports updated setting"
else
    echo "❌ Missing 'Updated' message for corrected setting"
    exit 1
fi

# Test 18: Correct wrong object entry value
run_test "Wrong object entry value" '{
  "chat.agentFilesLocations": {
    "~/.copilot/agents": false
  }
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents": true'
# Verify the output mentions "Updated"
echo '{"chat.agentFilesLocations": {"~/.copilot/agents": false}}' > "$TEST_DIR/settings.json"
set +e
output=$(node "$SCRIPT_DIR/configure-vscode-settings.js" "$TEST_DIR/settings.json" 2>&1)
set -e
if echo "$output" | grep -q "Updated:.*chat.agentFilesLocations"; then
    echo "✓ Reports updated object entry"
else
    echo "❌ Missing 'Updated' message for corrected object entry"
    exit 1
fi

# Test 19: Mixed correct and wrong values
run_test "Mixed correct and wrong values" '{
  "chat.agentFilesLocations": {
    "~/.copilot/agents": true
  },
  "chat.instructionsFilesLocations": {
    "~/.copilot/instructions": false
  },
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.copilotMemory.enabled": false
}' 0
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/instructions": true'
verify_contains "$TEST_DIR/settings.json" '"github.copilot.chat.copilotMemory.enabled": true'
verify_contains "$TEST_DIR/settings.json" '"~/.copilot/agents": true'
verify_contains "$TEST_DIR/settings.json" '"chat.customAgentInSubagent.enabled": true'

echo ""
echo "=== All tests completed ==="
