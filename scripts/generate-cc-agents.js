#!/usr/bin/env node
/**
 * Generate Claude Code native subagent files from Copilot agent definitions.
 *
 * Usage:
 *   node scripts/generate-cc-agents.js <output-dir> [source-dir]
 *
 * Arguments:
 *   output-dir  - Target directory for generated CC agent files (e.g., ~/.claude/agents)
 *   source-dir  - Source directory containing *.agent.md files (default: .github/agents/)
 *
 * Features:
 * - Proper YAML frontmatter parsing (handles --- in body content)
 * - Maps Copilot frontmatter → CC frontmatter (tools, model, permissions)
 * - Appends CC Platform Notes sections per agent
 * - Skips Research and Worker (embedded into parent agents)
 * - Idempotent (safe to run multiple times)
 *
 * Exit codes:
 *   0 - Agents generated
 *   1 - No changes needed
 *   2 - Error
 */

const fs = require("fs");
const path = require("path");

// ---------------------------------------------------------------------------
// CC Agent Configuration
// ---------------------------------------------------------------------------

const CC_AGENT_CONFIG = {
  explore: {
    name: "Explore",
    description:
      "READ-ONLY research and planning. Cannot modify code—only saves work to .tasks/ directory.",
    tools: [
      "Read",
      "Grep",
      "Glob",
      "WebFetch",
      "WebSearch",
      "Edit",
      "Write",
      "Task(explore)",
      "TaskList",
      "TaskGet",
      "TaskCreate",
      "TaskUpdate",
      "LSP",
    ],
    disallowedTools: ["Bash"],
    model: "opus",
    skills: ["deep-research", "architecture", "critic"],
  },
  implement: {
    name: "Implement",
    description: "Execute implementation plans with full code access.",
    tools: [
      "Read",
      "Edit",
      "Write",
      "Bash",
      "Grep",
      "Glob",
      "WebFetch",
      "WebSearch",
      "TaskList",
      "TaskGet",
      "TaskCreate",
      "TaskUpdate",
      "LSP",
    ],
    model: "opus",
  },
  review: {
    name: "Review",
    description: "Verify implementation quality with read and test access.",
    tools: [
      "Read",
      "Grep",
      "Glob",
      "Bash",
      "WebFetch",
      "WebSearch",
      "TaskList",
      "TaskGet",
      "LSP",
    ],
    disallowedTools: ["Edit", "Write"],
    model: "sonnet",
    skills: ["critic", "tech-debt", "security-review"],
  },
  commit: {
    name: "Commit",
    description: "Create meaningful commits with logical file grouping.",
    tools: ["Read", "Grep", "Glob", "Bash", "TaskList", "TaskGet"],
    disallowedTools: ["Edit", "Write"],
    model: "sonnet",
  },
  orchestrate: {
    name: "Orchestrate",
    description:
      "Conductor for multi-phase task execution. Coordinates specialized agents.",
    tools: [
      "Read",
      "Glob",
      "Task(explore)",
      "Task(implement)",
      "Task(review)",
      "Task(commit)",
      "AskUserQuestion",
      "TaskList",
      "TaskGet",
      "TaskCreate",
      "TaskUpdate",
    ],
    disallowedTools: ["Edit", "Write", "Bash", "Grep"],
    permissionMode: "plan",
    model: "opus",
  },
};

// Agents to skip (embedded into parent agents for CC)
const SKIP_AGENTS = ["research", "worker"];

// ---------------------------------------------------------------------------
// CC Platform Notes (appended to body)
// ---------------------------------------------------------------------------

const CC_PLATFORM_NOTES = {
  explore: `## CC Platform Notes

### Research Capability (Embedded)
In Claude Code, there is no separate Research subagent. Use your own tools
(Read, Grep, Glob, WebFetch, WebSearch) directly for all investigation.
Where the instructions above say "Run the Research agent as a subagent,"
perform that research yourself using your available tools.

### Next Steps
When research is complete, tell the user to invoke the appropriate agent:
- To implement: \`@agent-Implement\`
- To plan next phase: re-invoke \`@agent-Explore\``,

  implement: `## CC Platform Notes

### Worker Capability (Embedded)
In Claude Code, there is no separate Worker subagent. Execute small fixes,
test runs, and isolated changes directly using your own tools.
Where the instructions above say "Run the Worker agent as a subagent,"
perform that work yourself.

### Next Steps
When implementation is complete:
- To review: \`@agent-Review\`
- To commit: \`@agent-Commit\`
- To check errors: re-invoke \`@agent-Implement\``,

  review: `## CC Platform Notes

### Worker Capability (Embedded)
In Claude Code, there is no separate Worker subagent. Run tests, lint checks,
and verifications directly using your Bash tool.

### Next Steps
After review is complete:
- PASS: \`@agent-Commit\` to create semantic commits
- NEEDS_WORK: \`@agent-Implement\` to fix issues
- FAIL: \`@agent-Explore\` to re-plan`,

  commit: `## CC Platform Notes

### Research Capability (Embedded)
In Claude Code, there is no separate Research subagent. Analyze changes
directly using your Read, Grep, and Glob tools before crafting commit messages.

### Next Steps
After commits are created:
- Push with \`git push\`
- Review commits: re-invoke \`@agent-Commit\``,

  orchestrate: `## CC Platform Notes

### Subagent Constraint
In Claude Code, subagents cannot spawn other subagents. The agents you invoke
(Explore, Implement, Review, Commit) perform all work directly — they do not
delegate to sub-subagents like Research or Worker.

### Checkpoints
Use the AskUserQuestion tool at checkpoint pauses to explicitly request user
input. Present options clearly and wait for a response before proceeding.

### Agent Invocation
To spawn agents, use the Task tool with the specific agent name:
- Task(explore, "Create a task and phased plan for: [description]")
- Task(implement, "Implement Phase N from: [plan path]")
- Task(review, "Verify implementation of Phase N")
- Task(commit, "Create semantic commits for Phase N")`,
};

// ---------------------------------------------------------------------------
// Frontmatter Parsing
// ---------------------------------------------------------------------------

/**
 * Parse frontmatter and body from a markdown file with YAML frontmatter.
 * Handles --- appearing in body content (e.g., markdown horizontal rules).
 * Only the FIRST ---...--- block is treated as frontmatter.
 */
function parseFrontmatter(content) {
  const lines = content.split("\n");

  // Must start with ---
  if (lines[0].trim() !== "---") {
    return { frontmatter: {}, body: content };
  }

  // Find the closing --- (second occurrence, scanning from line 1)
  let closingIndex = -1;
  for (let i = 1; i < lines.length; i++) {
    if (lines[i].trim() === "---") {
      closingIndex = i;
      break;
    }
  }

  if (closingIndex === -1) {
    return { frontmatter: {}, body: content };
  }

  const body = lines.slice(closingIndex + 1).join("\n");

  return { body };
}

// ---------------------------------------------------------------------------
// CC Frontmatter Generation
// ---------------------------------------------------------------------------

/**
 * Build CC YAML frontmatter string from config object.
 */
function buildCCFrontmatter(config) {
  let yaml = "---\n";
  yaml += `name: ${config.name}\n`;
  yaml += `description: "${config.description}"\n`;
  yaml += `tools: [${config.tools.join(", ")}]\n`;
  if (config.disallowedTools) {
    yaml += `disallowedTools: [${config.disallowedTools.join(", ")}]\n`;
  }
  yaml += `model: ${config.model}\n`;
  if (config.permissionMode) {
    yaml += `permissionMode: ${config.permissionMode}\n`;
  }
  if (config.skills) {
    yaml += `skills: [${config.skills.join(", ")}]\n`;
  }
  yaml += "---";
  return yaml;
}

// ---------------------------------------------------------------------------
// Agent Generation
// ---------------------------------------------------------------------------

/**
 * Generate a CC agent file from a Copilot agent source.
 * Returns the complete file content (frontmatter + body + CC notes), or null if skipped.
 */
function generateCCAgent(sourceContent, agentName) {
  // Skip agents embedded into parents
  if (SKIP_AGENTS.includes(agentName)) {
    return null;
  }

  const config = CC_AGENT_CONFIG[agentName];
  if (!config) {
    return null; // Unknown agent
  }

  // Parse source frontmatter and body
  const { body } = parseFrontmatter(sourceContent);

  // Build CC frontmatter
  const ccFrontmatter = buildCCFrontmatter(config);

  // Append CC Platform Notes
  const notes = CC_PLATFORM_NOTES[agentName] || "";
  const fullBody = notes ? body.trimEnd() + "\n\n" + notes + "\n" : body;

  return ccFrontmatter + "\n" + fullBody;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

function main() {
  const outputDir = process.argv[2];
  const sourceDir =
    process.argv[3] || path.join(__dirname, "..", ".github", "agents");

  if (!outputDir) {
    console.error(
      "Usage: node generate-cc-agents.js <output-dir> [source-dir]",
    );
    process.exit(2);
  }

  // Verify source directory exists
  if (!fs.existsSync(sourceDir)) {
    console.error(`Source directory not found: ${sourceDir}`);
    process.exit(2);
  }

  // Create output directory if needed
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Find all agent source files
  const sourceFiles = fs
    .readdirSync(sourceDir)
    .filter((f) => f.endsWith(".agent.md"))
    .sort();

  let generated = 0;
  let skipped = 0;

  for (const file of sourceFiles) {
    const agentName = file.replace(".agent.md", "");
    const sourcePath = path.join(sourceDir, file);
    const content = fs.readFileSync(sourcePath, "utf8");

    const result = generateCCAgent(content, agentName);

    if (result === null) {
      console.log(`Skipped: ${agentName} (embedded into parent agents)`);
      skipped++;
      continue;
    }

    const outputPath = path.join(outputDir, `${agentName}.md`);
    fs.writeFileSync(outputPath, result);
    console.log(`Generated: ${agentName}.md`);
    generated++;
  }

  console.log(`\n${generated} agents generated, ${skipped} skipped.`);
  process.exit(generated > 0 ? 0 : 1);
}

main();
