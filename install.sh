#!/bin/zsh
#
# Agentic Coding Framework - Install/Uninstall Script
#
# Installs:
# - Custom Agents (workflow modes with tool restrictions and handoffs)
# - Agent Skills (auto-activated specialized capabilities)
#
# For GitHub Copilot (coding agent, CLI, VS Code, IntelliJ) and Claude Code
#
# Usage:
#   ./install.sh              # Install agents and skills
#   ./install.sh uninstall    # Uninstall
#

set -e

# Configuration
SCRIPT_DIR="${0:A:h}"

# Target directories
SKILLS_TARGET_DIR="$HOME/.copilot/skills"
CLAUDE_SKILLS_TARGET_DIR="$HOME/.claude/skills"

# Agent and instruction target directories (VS Code 1.109+)
VSCODE_AGENTS_DIR="$HOME/.copilot/agents"
VSCODE_INSTRUCTIONS_DIR="$HOME/.copilot/instructions"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"

# Old location (for migration cleanup)
OLD_VSCODE_PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"

# IntelliJ Copilot configuration directory
INTELLIJ_COPILOT_DIR="$HOME/.config/github-copilot/intellij"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() { echo "${BLUE}ℹ${NC} $1"; }
success() { echo "${GREEN}✓${NC} $1"; }
warn() { echo "${YELLOW}⚠${NC} $1"; }
error() { echo "${RED}✗${NC} $1"; exit 1; }

# Create symlink, backing up existing files
# Returns 0 if link created, 1 if already correct
link_file() {
    local src="$1" dest="$2" name="${3:-$(basename "$src")}"
    
    if [[ -L "$dest" ]]; then
        [[ "$(readlink "$dest")" == "$src" ]] && return 1  # Already correct
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        warn "Backing up: $name → $name.backup"
        mv "$dest" "$dest.backup"
    fi
    
    ln -s "$src" "$dest"
    return 0
}

# Remove symlink if it points to our source
# Returns 0 if removed, 1 if not ours
unlink_if_ours() {
    local src="$1" dest="$2"
    [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]] && rm "$dest" && return 0
    return 1
}

# Configure global gitignore to exclude .tasks/
configure_global_gitignore() {
    local pattern=".tasks/"
    
    # Get global gitignore path, or set default if not configured
    local gitignore_global=$(git config --global core.excludesFile)
    
    if [[ -z "$gitignore_global" ]]; then
        # No global gitignore configured, use default location
        gitignore_global="$HOME/.gitignore_global"
        git config --global core.excludesFile "$gitignore_global"
        info "Configured global gitignore: $gitignore_global"
    fi
    
    # Expand tilde if present
    gitignore_global="${gitignore_global/#\~/$HOME}"
    
    # Create the file if it doesn't exist
    if [[ ! -f "$gitignore_global" ]]; then
        touch "$gitignore_global"
    fi
    
    # Check if pattern already exists
    if grep -Fxq "$pattern" "$gitignore_global" 2>/dev/null; then
        return 1  # Already exists
    fi
    
    # Add pattern with a comment
    echo "" >> "$gitignore_global"
    echo "# Copilot task state (personal session context)" >> "$gitignore_global"
    echo "$pattern" >> "$gitignore_global"
    return 0
}

# Remove .tasks/ from global gitignore
unconfigure_global_gitignore() {
    local pattern=".tasks/"
    local gitignore_global=$(git config --global core.excludesFile)
    
    [[ -z "$gitignore_global" ]] && return 1
    gitignore_global="${gitignore_global/#\~/$HOME}"
    [[ ! -f "$gitignore_global" ]] && return 1
    
    # Resolve symlinks for sed compatibility (macOS sed -i doesn't work on symlinks)
    if [[ -L "$gitignore_global" ]]; then
        gitignore_global=$(readlink -f "$gitignore_global" 2>/dev/null || greadlink -f "$gitignore_global" 2>/dev/null || echo "$gitignore_global")
    fi
    
    # Remove the pattern and its comment if they exist
    if grep -Fxq "$pattern" "$gitignore_global" 2>/dev/null; then
        # Use sed to remove the pattern and the comment line before it
        sed -i.bak '/# Copilot task state (personal session context)/d' "$gitignore_global"
        sed -i.bak '\|'"$pattern"'|d' "$gitignore_global"
        rm "${gitignore_global}.bak" 2>/dev/null || true
        return 0
    fi
    return 1
}

# Show what will be linked
show_files() {
    echo "\n${BLUE}Custom Agents (workflow modes):${NC}"
    for f in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
        [[ -f "$f" ]] && echo "    - $(basename "$f")"
    done
    
    echo "\n${BLUE}Agent Skills (auto-activated capabilities):${NC}"
    for d in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$d" ]] && echo "    - $(basename "$d")/"
    done
    echo ""
}

# Install: Create symlinks for skills globally
install() {
    info "Installing Agentic Coding Framework..."
    info "Source: $SCRIPT_DIR/.github/"
    info "Target: ~/.github/"
    
    show_files
    
    local skill_count=0
    local skipped=0
    
    # Create global skills directory if it doesn't exist
    if [[ ! -d "$SKILLS_TARGET_DIR" ]]; then
        info "Creating global skills directory..."
        mkdir -p "$SKILLS_TARGET_DIR"
    fi
    
    # Link Agent Skills directories
    for src in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$src" ]] || continue
        local name=$(basename "$src")
        if link_file "${src%/}" "$SKILLS_TARGET_DIR/$name" "$name"; then
            success "Linked skill: $name"
            skill_count=$((skill_count + 1))
        else
            skipped=$((skipped + 1))
        fi
    done
    
    # Generate CC-enhanced skills (with CC-specific frontmatter)
    info "Generating Claude Code enhanced skills..."
    # Remove old compatibility symlink if it exists
    if [[ -L "$CLAUDE_SKILLS_TARGET_DIR" ]]; then
        rm "$CLAUDE_SKILLS_TARGET_DIR"
        info "Removed old Claude Code skills symlink"
    fi
    local cc_skill_count=0
    if command -v node &>/dev/null; then
        if node "$SCRIPT_DIR/scripts/generate-cc-files.js" skills "$CLAUDE_SKILLS_TARGET_DIR" "$SCRIPT_DIR/.github/skills" 2>&1; then
            success "Generated Claude Code enhanced skills"
            cc_skill_count=$(find "$CLAUDE_SKILLS_TARGET_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
        else
            local exit_code=$?
            if [[ $exit_code -eq 1 ]]; then
                info "Claude Code skills already up to date"
                cc_skill_count=$(find "$CLAUDE_SKILLS_TARGET_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
            else
                warn "Could not generate Claude Code skills"
            fi
        fi
    else
        warn "Node.js not found — cannot generate Claude Code skills"
        info "Install Node.js and re-run to enable Claude Code skill generation"
    fi
    
    # Configure global gitignore for tasks
    info "Configuring global gitignore for task state..."
    if configure_global_gitignore; then
        success "Added .tasks/ to global gitignore"
    else
        info "Global gitignore already configured for task state"
    fi

    # Migrate: Remove old symlinks from deprecated prompts folder
    if [[ -d "$OLD_VSCODE_PROMPTS_DIR" ]]; then
        local migrated=0
        for src in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
            [[ -f "$src" ]] || continue
            local name=$(basename "$src")
            if unlink_if_ours "$src" "$OLD_VSCODE_PROMPTS_DIR/$name"; then
                migrated=$((migrated + 1))
            fi
        done
        for src in "$SCRIPT_DIR"/instructions/*.instructions.md; do
            [[ -f "$src" ]] || continue
            local name=$(basename "$src")
            if unlink_if_ours "$src" "$OLD_VSCODE_PROMPTS_DIR/$name"; then
                migrated=$((migrated + 1))
            fi
        done
        if [[ $migrated -gt 0 ]]; then
            info "Migrated $migrated files from old prompts folder"
        fi
    fi

    # Install agents to global agents directory
    info "Installing agents to global agents directory..."
    if [[ ! -d "$VSCODE_AGENTS_DIR" ]]; then
        mkdir -p "$VSCODE_AGENTS_DIR"
    fi
    
    local agent_count=0
    for src in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        if link_file "$src" "$VSCODE_AGENTS_DIR/$name" "$name"; then
            success "Linked agent: $name"
            agent_count=$((agent_count + 1))
        fi
    done
    
    # Generate Claude Code native subagents
    info "Generating Claude Code subagents..."
    local cc_agent_count=0
    if command -v node &>/dev/null; then
        if node "$SCRIPT_DIR/scripts/generate-cc-files.js" agents "$CLAUDE_AGENTS_DIR" "$SCRIPT_DIR/.github/agents" 2>&1; then
            success "Generated Claude Code native subagents"
            cc_agent_count=$(ls "$CLAUDE_AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
        else
            local exit_code=$?
            if [[ $exit_code -eq 1 ]]; then
                info "Claude Code agents already up to date"
                cc_agent_count=$(ls "$CLAUDE_AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
            else
                warn "Could not generate Claude Code agents"
            fi
        fi
    else
        warn "Node.js not found — cannot generate Claude Code agents"
        info "Install Node.js and re-run to enable Claude Code agent generation"
    fi

    # Clean up old slash commands if they exist
    if [[ -d "$CLAUDE_COMMANDS_DIR" ]]; then
        local has_old_cmds=false
        for old_cmd in "$CLAUDE_COMMANDS_DIR"/*.md; do
            [[ -f "$old_cmd" ]] || continue
            has_old_cmds=true
            break
        done
        if [[ "$has_old_cmds" == true ]]; then
            info "Migrating from slash commands to native agents..."
            for old_cmd in "$CLAUDE_COMMANDS_DIR"/*.md; do
                [[ -f "$old_cmd" ]] || continue
                local old_name=$(basename "$old_cmd" .md)
                rm "$old_cmd"
                info "Removed old command: /$old_name"
            done
            rmdir "$CLAUDE_COMMANDS_DIR" 2>/dev/null || true
        fi
    fi
    
    # Install instructions to global instructions directory
    info "Installing instructions to global instructions directory..."
    if [[ ! -d "$VSCODE_INSTRUCTIONS_DIR" ]]; then
        mkdir -p "$VSCODE_INSTRUCTIONS_DIR"
    fi
    
    local instruction_count=0
    for src in "$SCRIPT_DIR"/instructions/*.instructions.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        if link_file "$src" "$VSCODE_INSTRUCTIONS_DIR/$name" "$name"; then
            success "Linked instruction: $name"
            instruction_count=$((instruction_count + 1))
        fi
    done
    
    # Install global instructions to IntelliJ
    info "Installing global instructions to IntelliJ..."
    if [[ ! -d "$INTELLIJ_COPILOT_DIR" ]]; then
        mkdir -p "$INTELLIJ_COPILOT_DIR"
    fi
    local intellij_src="$SCRIPT_DIR/instructions/global.instructions.md"
    local intellij_dest="$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md"
    if [[ -f "$intellij_src" ]]; then
        if link_file "$intellij_src" "$intellij_dest" "global-copilot-instructions.md"; then
            success "Linked IntelliJ global instructions"
        else
            info "IntelliJ global instructions already linked"
        fi
    fi
    
    # Configure VS Code settings for agent/instruction file locations
    info "Configuring VS Code settings..."
    if command -v node &>/dev/null; then
        if node "$SCRIPT_DIR/scripts/configure-vscode-settings.js" 2>/dev/null; then
            success "Configured VS Code settings for agent discovery"
        else
            local exit_code=$?
            if [[ $exit_code -eq 1 ]]; then
                info "VS Code settings already configured"
            else
                warn "Could not auto-configure VS Code settings"
                info "Add to settings.json:"
                echo '  "chat.agentFilesLocations": { "~/.copilot/agents": true }'
                echo '  "chat.instructionsFilesLocations": { "~/.copilot/instructions": true }'
            fi
        fi
    else
        warn "Node.js not found - cannot auto-configure VS Code settings"
        info "Add to settings.json:"
        echo '  "chat.agentFilesLocations": { "~/.copilot/agents": true }'
        echo '  "chat.instructionsFilesLocations": { "~/.copilot/instructions": true }'
    fi
    
    echo ""
    success "Installation complete!"
    info "Installed $agent_count agents, $skill_count skills, $instruction_count instructions, $cc_agent_count CC agents, and $cc_skill_count CC skills"
    echo ""
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo "${YELLOW}  Agents are now available globally${NC}"
    echo "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    info "Agents installed to:"
    info "  • ~/.copilot/agents/"
    echo ""
    info "Instructions installed to:"
    info "  • ~/.copilot/instructions/"
    echo ""
    info "IntelliJ global instructions installed to:"
    info "  • ~/.config/github-copilot/intellij/"
    info "  (Note: Agents and skills require VS Code—see README)"
    echo ""
    info "Skills installed to:"
    info "  • ~/.copilot/skills/ (Copilot, symlinked)"
    info "  • ~/.claude/skills/ (Claude Code, generated with CC frontmatter)"
    echo ""
    info "Claude Code agents installed to:"
    info "  • ~/.claude/agents/ (invoke with @agent-<Name>)"
    echo ""
    info "VS Code settings configured:"
    info "  • chat.agentFilesLocations → ~/.copilot/agents"
    info "  • chat.instructionsFilesLocations → ~/.copilot/instructions"
    echo ""
    info "Task state location:"
    info "  • .tasks/ (in each workspace, gitignored globally)"
    echo ""
}

# Uninstall: Remove symlinks (skills only)
uninstall() {
    info "Uninstalling Agentic Coding Framework..."
    
    local skill_count=0
    local agent_count=0
    local instruction_count=0
    
    # Remove global gitignore configuration
    unconfigure_global_gitignore
    
    # Remove Agent Skills symlinks
    info "Removing skills from $SKILLS_TARGET_DIR..."
    for src in "$SCRIPT_DIR"/.github/skills/*/; do
        [[ -d "$src" ]] || continue
        local name=$(basename "$src")
        if unlink_if_ours "${src%/}" "$SKILLS_TARGET_DIR/$name"; then
            success "Removed skill: $name"
            skill_count=$((skill_count + 1))
        fi
    done
    
    # Remove Claude Code generated skills
    if [[ -d "$CLAUDE_SKILLS_TARGET_DIR" ]]; then
        local cc_skill_removed=0
        for skill_dir in "$CLAUDE_SKILLS_TARGET_DIR"/*/; do
            [[ -d "$skill_dir" ]] || continue
            local sname=$(basename "$skill_dir")
            rm -rf "$skill_dir"
            cc_skill_removed=$((cc_skill_removed + 1))
        done
        rmdir "$CLAUDE_SKILLS_TARGET_DIR" 2>/dev/null || true
        if [[ $cc_skill_removed -gt 0 ]]; then
            success "Removed $cc_skill_removed CC skills"
        fi
    elif [[ -L "$CLAUDE_SKILLS_TARGET_DIR" ]]; then
        # Handle old compatibility symlink
        rm "$CLAUDE_SKILLS_TARGET_DIR"
        success "Removed: Claude Code compatibility symlink"
    fi
    
    # Remove agents from global agents directory
    info "Removing agents from global agents directory..."
    for src in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        if unlink_if_ours "$src" "$VSCODE_AGENTS_DIR/$name"; then
            success "Removed agent: $name"
            agent_count=$((agent_count + 1))
        fi
    done
    
    # Remove Claude Code native agents
    info "Removing Claude Code agents..."
    local cc_agent_count=0
    if [[ -d "$CLAUDE_AGENTS_DIR" ]]; then
        for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
            [[ -f "$agent_file" ]] || continue
            local agent_name=$(basename "$agent_file")
            rm "$agent_file"
            success "Removed CC agent: $agent_name"
            cc_agent_count=$((cc_agent_count + 1))
        done
        rmdir "$CLAUDE_AGENTS_DIR" 2>/dev/null || true
    fi

    # Remove old Claude Code slash commands (migration cleanup)
    local cmd_count=0
    if [[ -d "$CLAUDE_COMMANDS_DIR" ]]; then
        for cmd_file in "$CLAUDE_COMMANDS_DIR"/*.md; do
            [[ -f "$cmd_file" ]] || continue
            rm "$cmd_file"
            cmd_count=$((cmd_count + 1))
        done
        rmdir "$CLAUDE_COMMANDS_DIR" 2>/dev/null || true
    fi
    
    # Remove instructions from global instructions directory
    info "Removing instructions from global instructions directory..."
    for src in "$SCRIPT_DIR"/instructions/*.instructions.md; do
        [[ -f "$src" ]] || continue
        local name=$(basename "$src")
        if unlink_if_ours "$src" "$VSCODE_INSTRUCTIONS_DIR/$name"; then
            success "Removed instruction: $name"
            instruction_count=$((instruction_count + 1))
        fi
    done
    
    # Remove task state pattern from global gitignore
    info "Removing task state pattern from global gitignore..."
    if unconfigure_global_gitignore; then
        success "Removed .tasks/ from global gitignore"
    else
        info "Task state pattern not found in global gitignore"
    fi
    
    # Remove global instructions from IntelliJ
    info "Removing global instructions from IntelliJ..."
    local intellij_src="$SCRIPT_DIR/instructions/global.instructions.md"
    local intellij_dest="$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md"
    if unlink_if_ours "$intellij_src" "$intellij_dest"; then
        success "Removed IntelliJ global instructions"
    fi
    
    echo ""
    success "Uninstallation complete!"
    info "Removed $agent_count agents, $skill_count skills, $instruction_count instructions, $cc_agent_count CC agents, and $cmd_count old commands"
}

# Main
case "${1:-install}" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Usage: $0 [install|uninstall]"
        echo ""
        echo "Commands:"
        echo "  install    Install agents and skills globally"
        echo "  uninstall  Remove global agent and skill symlinks"
        exit 1
        ;;
esac
