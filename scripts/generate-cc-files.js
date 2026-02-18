#!/usr/bin/env node
/**
 * Generate Claude Code native files from Copilot definitions.
 *
 * Subcommands:
 *   agents <output-dir> [source-dir]  - Generate CC agent files
 *   skills <output-dir> [source-dir]  - Generate CC-enhanced skill files
 *
 * Agents:
 *   Reads *.agent.md from source-dir (default: .github/agents/)
 *   Maps Copilot frontmatter → CC frontmatter (tools, model, permissions)
 *   Appends CC Platform Notes sections per agent
 *   Skips Research and Worker (embedded into parent agents)
 *
 * Skills:
 *   Reads SKILL.md from source-dir subdirectories (default: .github/skills/)
 *   Merges CC-specific frontmatter (allowed-tools, context) from config
 *   Outputs enhanced skill files preserving directory structure
 *   Skills not in config are copied as-is
 *
 * Exit codes:
 *   0 - Files generated
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
// CC Skill Configuration
// ---------------------------------------------------------------------------

const CC_SKILL_CONFIG = {
  architecture: {
    context: "fork",
    "allowed-tools": ["Read", "Grep", "Glob", "LSP"],
  },
  critic: { context: "fork", "allowed-tools": ["Read", "Grep", "Glob", "LSP"] },
  mentor: { context: "fork", "allowed-tools": ["Read", "Grep", "Glob", "LSP"] },
  "deep-research": {
    context: "fork",
    "allowed-tools": ["Read", "Grep", "Glob", "WebFetch", "WebSearch", "LSP"],
  },
  "security-review": {
    context: "fork",
    "allowed-tools": ["Read", "Grep", "Glob", "LSP"],
  },
  "phase-review": { "allowed-tools": ["Read", "Grep", "Glob", "Edit", "LSP"] },
  debug: {
    "allowed-tools": ["Read", "Edit", "Write", "Bash", "Grep", "Glob", "LSP"],
  },
  "tech-debt": {
    "allowed-tools": ["Read", "Edit", "Write", "Bash", "Grep", "Glob", "LSP"],
  },
  "consolidate-task": {
    "allowed-tools": ["Read", "Edit", "Write", "Grep", "Glob"],
  },
  makefile: {
    "allowed-tools": ["Read", "Edit", "Write", "Bash", "Grep", "Glob"],
  },
  design: {
    "allowed-tools": [
      "Read",
      "Edit",
      "Write",
      "Bash",
      "Grep",
      "Glob",
      "WebFetch",
      "WebSearch",
      "LSP",
    ],
  },
};

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
    return { frontmatterLines: [], body: content };
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
    return { frontmatterLines: [], body: content };
  }

  const frontmatterLines = lines.slice(1, closingIndex);
  const body = lines.slice(closingIndex + 1).join("\n");

  return { frontmatterLines, body };
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
// Skill Generation
// ---------------------------------------------------------------------------

/**
 * Generate a CC-enhanced skill file from a Copilot skill source.
 * Merges CC-specific frontmatter fields (allowed-tools, context) into existing frontmatter.
 * Returns the complete file content, or the original content if no CC config exists.
 */
function generateCCSkill(sourceContent, skillName) {
  const ccConfig = CC_SKILL_CONFIG[skillName];

  // No CC enhancement needed — return as-is
  if (!ccConfig) {
    return sourceContent;
  }

  const { frontmatterLines, body } = parseFrontmatter(sourceContent);

  // Build enhanced frontmatter by appending CC fields
  const enhancedLines = [...frontmatterLines];
  if (ccConfig.context) {
    enhancedLines.push(`context: ${ccConfig.context}`);
  }
  if (ccConfig["allowed-tools"]) {
    enhancedLines.push(
      `allowed-tools: [${ccConfig["allowed-tools"].join(", ")}]`,
    );
  }

  return "---\n" + enhancedLines.join("\n") + "\n---" + body;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

function generateAgents(outputDir, sourceDir) {
  sourceDir = sourceDir || path.join(__dirname, "..", ".github", "agents");

  if (!fs.existsSync(sourceDir)) {
    console.error(`Source directory not found: ${sourceDir}`);
    process.exit(2);
  }

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

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
  return generated;
}

function generateSkills(outputDir, sourceDir) {
  sourceDir = sourceDir || path.join(__dirname, "..", ".github", "skills");

  if (!fs.existsSync(sourceDir)) {
    console.error(`Source directory not found: ${sourceDir}`);
    process.exit(2);
  }

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Find skill subdirectories (each has a SKILL.md)
  const skillDirs = fs
    .readdirSync(sourceDir)
    .filter((d) => {
      const skillPath = path.join(sourceDir, d, "SKILL.md");
      return (
        fs.statSync(path.join(sourceDir, d)).isDirectory() &&
        fs.existsSync(skillPath)
      );
    })
    .sort();

  let generated = 0;
  let copied = 0;

  for (const skillName of skillDirs) {
    const sourcePath = path.join(sourceDir, skillName, "SKILL.md");
    const content = fs.readFileSync(sourcePath, "utf8");

    const result = generateCCSkill(content, skillName);

    // Create output subdirectory
    const outSubdir = path.join(outputDir, skillName);
    if (!fs.existsSync(outSubdir)) {
      fs.mkdirSync(outSubdir, { recursive: true });
    }

    const outputPath = path.join(outSubdir, "SKILL.md");
    fs.writeFileSync(outputPath, result);

    if (CC_SKILL_CONFIG[skillName]) {
      console.log(`Generated: ${skillName}/SKILL.md (CC-enhanced)`);
      generated++;
    } else {
      console.log(`Copied: ${skillName}/SKILL.md (no CC config)`);
      copied++;
    }
  }

  console.log(`\n${generated} skills enhanced, ${copied} copied as-is.`);
  return generated + copied;
}

function main() {
  const subcommand = process.argv[2];
  const outputDir = process.argv[3];
  const sourceDir = process.argv[4];

  if (!subcommand || !outputDir) {
    console.error(
      "Usage: node generate-cc-files.js <agents|skills> <output-dir> [source-dir]",
    );
    process.exit(2);
  }

  let count;
  switch (subcommand) {
    case "agents":
      count = generateAgents(outputDir, sourceDir);
      break;
    case "skills":
      count = generateSkills(outputDir, sourceDir);
      break;
    default:
      console.error(`Unknown subcommand: ${subcommand}`);
      console.error(
        "Usage: node generate-cc-files.js <agents|skills> <output-dir> [source-dir]",
      );
      process.exit(2);
  }

  process.exit(count > 0 ? 0 : 1);
}

main();
