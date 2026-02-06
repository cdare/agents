#!/usr/bin/env node
/**
 * Configure VS Code settings.json for agent/instruction file locations.
 *
 * Usage:
 *   node scripts/configure-vscode-settings.js [settings.json path]
 *
 * Features:
 * - Insert-only (never removes content, preserves comments)
 * - Idempotent (safe to run multiple times)
 * - Creates backup before modifying
 *
 * Exit codes:
 *   0 - Settings updated
 *   1 - Already configured (no changes needed)
 *   2 - Error
 */

const fs = require("fs");
const path = require("path");
const os = require("os");

// Settings to configure
const SETTINGS = [
  {
    key: "chat.agentFilesLocations",
    entry: "~/.copilot/agents",
    value: "true",
  },
  {
    key: "chat.instructionsFilesLocations",
    entry: "~/.copilot/instructions",
    value: "true",
  },
];

/**
 * Add an entry to a settings object in JSONC content.
 * Uses string manipulation to preserve comments and formatting.
 */
function addToSetting(content, settingKey, entryKey, entryValue) {
  // Already has our entry?
  if (content.includes(`"${entryKey}"`)) {
    return { content, changed: false };
  }

  // Setting exists? Insert into it
  const keyPattern = `"${settingKey}"`;
  const keyIndex = content.indexOf(keyPattern);

  if (keyIndex !== -1) {
    // Find the opening { after the key
    const colonIndex = content.indexOf(":", keyIndex);
    if (colonIndex === -1) {
      return { content, changed: false, error: `No colon after ${settingKey}` };
    }

    const braceIndex = content.indexOf("{", colonIndex);
    if (braceIndex === -1) {
      return { content, changed: false, error: `No { after ${settingKey}` };
    }

    // Check if the object is empty (next non-whitespace is })
    const afterBrace = content.slice(braceIndex + 1);
    const isEmpty = /^\s*}/.test(afterBrace);

    // Insert after the opening { (no trailing comma if empty)
    const insert = isEmpty
      ? `\n    "${entryKey}": ${entryValue}\n  `
      : `\n    "${entryKey}": ${entryValue},`;
    const newContent =
      content.slice(0, braceIndex + 1) + insert + content.slice(braceIndex + 1);
    return { content: newContent, changed: true };
  }

  // Setting doesn't exist - add before final }
  const lastBrace = content.lastIndexOf("}");
  if (lastBrace === -1) {
    return { content, changed: false, error: "No closing } found" };
  }

  const before = content.slice(0, lastBrace).trimEnd();

  // Check if we need a comma (ends with a value, not { or ,)
  const needsComma = /[}\]"'\d]$|true$|false$|null$/.test(before);

  const insert =
    (needsComma ? "," : "") +
    `\n  "${settingKey}": {\n    "${entryKey}": ${entryValue}\n  }`;

  const newContent = before + insert + "\n}";
  return { content: newContent, changed: true };
}

function main() {
  // Get settings file path
  const defaultPath = path.join(
    os.homedir(),
    "Library/Application Support/Code/User/settings.json",
  );
  const settingsPath = process.argv[2] || defaultPath;

  // Check if file exists
  if (!fs.existsSync(settingsPath)) {
    console.error(`Settings file not found: ${settingsPath}`);
    process.exit(2);
  }

  // Read current content
  let content;
  try {
    content = fs.readFileSync(settingsPath, "utf8");
  } catch (err) {
    console.error(`Failed to read settings: ${err.message}`);
    process.exit(2);
  }

  // Apply each setting
  let anyChanged = false;
  for (const { key, entry, value } of SETTINGS) {
    const result = addToSetting(content, key, entry, value);
    if (result.error) {
      console.error(`Warning: ${result.error}`);
    }
    if (result.changed) {
      content = result.content;
      anyChanged = true;
      console.log(`Added: ${key} → ${entry}`);
    } else {
      console.log(`Already configured: ${entry}`);
    }
  }

  if (!anyChanged) {
    console.log("No changes needed.");
    process.exit(1);
  }

  // Create backup
  const backupPath = settingsPath + ".backup";
  try {
    fs.copyFileSync(settingsPath, backupPath);
    console.log(`Backup: ${backupPath}`);
  } catch (err) {
    console.error(`Warning: Failed to create backup: ${err.message}`);
  }

  // Write updated content
  try {
    fs.writeFileSync(settingsPath, content);
    console.log("Settings updated successfully.");
    process.exit(0);
  } catch (err) {
    console.error(`Failed to write settings: ${err.message}`);
    process.exit(2);
  }
}

main();
