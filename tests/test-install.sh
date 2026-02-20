#!/bin/zsh
#
# Test install and uninstall
#

set -e

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="$SCRIPT_DIR/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo "${BLUE}ℹ${NC} $1"; }
success() { echo "${GREEN}✓${NC} $1"; }
error() { echo "${RED}✗${NC} $1"; exit 1; }

echo "Testing install script..."
echo ""

# Test install
info "Running install..."
"$REPO_ROOT/install.sh" > /dev/null

# Verify agent symlinks exist in global agents directory
VSCODE_AGENTS_DIR="$HOME/.copilot/agents"
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
    if [[ ! -L "$HOME/.copilot/skills/$name" ]]; then
        error "Skill symlink not created: $name"
    fi
done
success "Skill symlinks created"

# Verify instruction symlinks exist in global instructions directory
VSCODE_INSTRUCTIONS_DIR="$HOME/.copilot/instructions"
for instr in "$REPO_ROOT"/generated/copilot/instructions/*.instructions.md; do
    [[ -f "$instr" ]] || continue
    name=$(basename "$instr")
    if [[ ! -L "$VSCODE_INSTRUCTIONS_DIR/$name" ]]; then
        error "Instruction symlink not created: $name"
    fi
done
success "Instruction symlinks created"

# Verify Claude Code agent symlinks exist
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
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
    if [[ ! -L "$HOME/.claude/skills/$name" ]]; then
        error "CC skill symlink not created: $name"
    fi
done
success "CC skill symlinks created"

# Verify Claude Code rule symlinks exist
for rule in "$REPO_ROOT"/generated/claude/rules/*.md; do
    [[ -f "$rule" ]] || continue
    name=$(basename "$rule")
    if [[ ! -L "$HOME/.claude/rules/$name" ]]; then
        error "CC rule symlink not created: $name"
    fi
done
success "CC rule symlinks created"

# Verify global gitignore contains .tasks/ pattern
gitignore_global=$(git config --global core.excludesFile 2>/dev/null || echo "")
if [[ -n "$gitignore_global" ]]; then
    gitignore_global="${gitignore_global/#\~/$HOME}"
    if ! grep -Fxq ".tasks/" "$gitignore_global" 2>/dev/null; then
        error "Global gitignore does not contain .tasks/ pattern"
    fi
    success "Global gitignore configured with .tasks/"
else
    error "Global gitignore not configured"
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
    if [[ -L "$HOME/.copilot/skills/$name" ]]; then
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
    if [[ -L "$HOME/.claude/skills/$name" ]]; then
        error "CC skill symlink not removed: $name"
    fi
done
success "CC skill symlinks removed"

# Verify CC rule symlinks removed
for rule in "$REPO_ROOT"/generated/claude/rules/*.md; do
    [[ -f "$rule" ]] || continue
    name=$(basename "$rule")
    if [[ -L "$HOME/.claude/rules/$name" ]]; then
        error "CC rule symlink not removed: $name"
    fi
done
success "CC rule symlinks removed"

# Re-install for normal use
info "Re-installing for normal use..."
"$REPO_ROOT/install.sh" > /dev/null
success "Re-install complete"

echo ""
echo "${GREEN}All install tests passed${NC}"
