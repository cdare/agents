# Makefile for agents framework
# Generates platform-specific files from templates/

.PHONY: all copilot cc validate clean build gen generate

# Default: generate everything
all: copilot cc

# Ensure dependencies are installed
node_modules: package.json
	npm install
	@touch node_modules

# Generate Copilot files to .github/
copilot: node_modules
	@node scripts/generate.js copilot

# Generate CC files to .claude/
cc: node_modules
	@node scripts/generate.js cc

# Validate committed files match templates (for CI)
validate: node_modules
	@node scripts/generate.js all --dry-run

# Clean: since generated files are tracked, just regenerate
clean:
	@echo "Generated files are tracked in git."
	@echo "Run 'make all' to regenerate from templates."

# Aliases
build gen generate: all
