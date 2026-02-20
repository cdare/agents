#!/bin/zsh
#
# Test install and uninstall using a temporary prefix directory.
# Never touches real $HOME/.copilot/ or $HOME/.claude/ directories.
#

set -e

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo "${BLUE}ℹ${NC} $1"; }
success() { echo "${GREEN}✓${NC} $1"; }
error() { echo "${RED}✗${NC} $1"; exit 1; }

# Create isolated test prefix — all symlinks go here instead of real $HOME
TEST_PREFIX=$(mktemp -d)
trap 'rm -rf "$TEST_PREFIX"' EXIT
export INSTALL_PREFIX="$TEST_PREFIX"

echo "Testing install script (isolated: $TEST_PREFIX)..."
echo ""

# Test install
info "Running install..."
"$REPO_ROOT/install.sh" > /dev/null

# Derive expected target dirs (mirrors install.sh HOME_DIR logic with prefix)
HOME_DIR="$TEST_PREFIX$HOME"
VSCODE_AGENTS_DIR="$HOME_DIR/.copilot/agents"
VSCODE_INSTRUCTIONS_DIR="$HOME_DIR/.copilot/instructions"
SKILLS_TARGET_DIR="$HOME_DIR/.copilot/skills"
CLAUDE_AGENTS_DIR="$HOME_DIR/.claude/agents"
CLAUDE_SKILLS_TARGET_DIR="$HOME_DIR/.claude/skills"
CLAUDE_RULES_DIR="$HOME_DIR/.claude/rules"
INTELLIJ_COPILOT_DIR="$HOME_DIR/.config/github-copilot/intellij"

# Verify agent symlinks exist in global agents directory
for agent in "$REPO_ROOT"/generated/copilot/agents/*.agent.md; do
    [[ -f "$agent" ]] || continue
    name=$(basename "$agent")
    if [[ ! -L "$VSCODE_AGENTS_DIR/$name" ]]; then
        error "Agent symlink not created: $name"
    fi
done
success "Agent symlinks created"

# Verify skill symlinks exist
for skill in "$REPO_ROOT"/generated/copilot/skills/*/; do
    [[ -d "$skill" ]] || continue
    name=$(basename "$skill")
    if [[ ! -L "$SKILLS_TARGET_DIR/$name" ]]; then
        error "Skill symlink not created: $name"
    fi
done
success "Skill symlinks created"

# Verify instruction symlinks exist in global instructions directory
for instr in "$REPO_ROOT"/generated/copilot/instructions/*.instructions.md; do
    [[ -f "$instr" ]] || continue
    name=$(basename "$instr")
    if [[ ! -L "$VSCODE_INSTRUCTIONS_DIR/$name" ]]; then
        error "Instruction symlink not created: $name"
    fi
done
success "Instruction symlinks created"

# Verify Claude Code agent symlinks exist
for agent in "$REPO_ROOT"/generated/claude/agents/*.md; do
    [[ -f "$agent" ]] || continue
    name=$(basename "$agent")
    if [[ ! -L "$CLAUDE_AGENTS_DIR/$name" ]]; then
        error "CC agent symlink not created: $name"
    fi
done
success "CC agent symlinks created"

# Verify Claude Code skill symlinks exist
for skill in "$REPO_ROOT"/generated/claude/skills/*/; do
    [[ -d "$skill" ]] || continue
    name=$(basename "$skill")
    if [[ ! -L "$CLAUDE_SKILLS_TARGET_DIR/$name" ]]; then
        error "CC skill symlink not created: $name"
    fi
done
success "CC skill symlinks created"

# Verify Claude Code rule symlinks exist
for rule in "$REPO_ROOT"/generated/claude/rules/*.md; do
    [[ -f "$rule" ]] || continue
    name=$(basename "$rule")
    if [[ ! -L "$CLAUDE_RULES_DIR/$name" ]]; then
        error "CC rule symlink not created: $name"
    fi
done
success "CC rule symlinks created"

# Verify IntelliJ global instructions symlink
intellij_src="$REPO_ROOT/generated/copilot/instructions/global.instructions.md"
intellij_dest="$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md"
if [[ -f "$intellij_src" ]]; then
    if [[ ! -L "$intellij_dest" ]]; then
        error "IntelliJ global instructions symlink not created"
    fi
    if [[ "$(readlink "$intellij_dest")" != "$intellij_src" ]]; then
        error "IntelliJ global instructions symlink points to wrong target"
    fi
    success "IntelliJ global instructions symlink created"
fi

# Test uninstall
info "Running uninstall..."
"$REPO_ROOT/install.sh" uninstall > /dev/null

# Verify agent symlinks removed
for agent in "$REPO_ROOT"/generated/copilot/agents/*.agent.md; do
    [[ -f "$agent" ]] || continue
    name=$(basename "$agent")
    if [[ -L "$VSCODE_AGENTS_DIR/$name" ]]; then
        error "Agent symlink not removed: $name"
    fi
done
success "Agent symlinks removed"

# Verify skill symlinks removed
for skill in "$REPO_ROOT"/generated/copilot/skills/*/; do
    [[ -d "$skill" ]] || continue
    name=$(basename "$skill")
    if [[ -L "$SKILLS_TARGET_DIR/$name" ]]; then
        error "Skill symlink not removed: $name"
    fi
done
success "Skill symlinks removed"

# Verify instruction symlinks removed
for instr in "$REPO_ROOT"/generated/copilot/instructions/*.instructions.md; do
    [[ -f "$instr" ]] || continue
    name=$(basename "$instr")
    if [[ -L "$VSCODE_INSTRUCTIONS_DIR/$name" ]]; then
        error "Instruction symlink not removed: $name"
    fi
done
success "Instruction symlinks removed"

# Verify CC agent symlinks removed
for agent in "$REPO_ROOT"/generated/claude/agents/*.md; do
    [[ -f "$agent" ]] || continue
    name=$(basename "$agent")
    if [[ -L "$CLAUDE_AGENTS_DIR/$name" ]]; then
        error "CC agent symlink not removed: $name"
    fi
done
success "CC agent symlinks removed"

# Verify CC skill symlinks removed
for skill in "$REPO_ROOT"/generated/claude/skills/*/; do
    [[ -d "$skill" ]] || continue
    name=$(basename "$skill")
    if [[ -L "$CLAUDE_SKILLS_TARGET_DIR/$name" ]]; then
        error "CC skill symlink not removed: $name"
    fi
done
success "CC skill symlinks removed"

# Verify CC rule symlinks removed
for rule in "$REPO_ROOT"/generated/claude/rules/*.md; do
    [[ -f "$rule" ]] || continue
    name=$(basename "$rule")
    if [[ -L "$CLAUDE_RULES_DIR/$name" ]]; then
        error "CC rule symlink not removed: $name"
    fi
done
success "CC rule symlinks removed"

# Verify IntelliJ symlink removed
if [[ -L "$intellij_dest" ]]; then
    error "IntelliJ global instructions symlink not removed"
fi
success "IntelliJ global instructions symlink removed"

# No re-install needed — test ran in isolated prefix, real HOME untouched

echo ""
echo "${GREEN}All install tests passed (isolated mode)${NC}"
