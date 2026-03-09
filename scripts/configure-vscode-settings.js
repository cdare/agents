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
const { execSync } = require("child_process");

/**
 * Detect VS Code version from CLI.
 */
function getVSCodeVersion() {
  for (const cmd of ["code --version", "code-insiders --version"]) {
    try {
      const output = execSync(cmd, {
        encoding: "utf8",
        timeout: 5000,
        stdio: ["pipe", "pipe", "pipe"],
      });
      const version = output.split("\n")[0].trim();
      if (/^\d+\.\d+/.test(version)) return version;
    } catch {
      // Try next command
    }
  }
  return null;
}

function versionGreaterThan(version, major, minor) {
  const parts = version.split(".");
  const vMajor = parseInt(parts[0], 10);
  const vMinor = parseInt(parts[1], 10);
  if (isNaN(vMajor) || isNaN(vMinor)) return false;
  return vMajor > major || (vMajor === major && vMinor > minor);
}

// Settings to configure
const SETTINGS = [
  // Object-type settings (add entry to existing object)
  {
    type: "object",
    key: "chat.agentFilesLocations",
    entry: "~/.copilot/agents",
    value: "true",
  },
  {
    type: "object",
    key: "chat.instructionsFilesLocations",
    entry: "~/.copilot/instructions",
    value: "true",
  },
  // Boolean settings (VS Code 1.109)
  { type: "boolean", key: "chat.customAgentInSubagent.enabled", value: true },
  {
    type: "boolean",
    key: "github.copilot.chat.copilotMemory.enabled",
    value: true,
  },
  { type: "boolean", key: "chat.askQuestions.enabled", value: true },
  {
    type: "boolean",
    key: "github.copilot.chat.searchSubagent.enabled",
    value: true,
  },
];

/**
 * Add an entry to a settings object in JSONC content.
 * Uses string manipulation to preserve comments and formatting.
 */
function addToSetting(content, settingKey, entryKey, entryValue) {
  // Check if entry already exists
  const entryPattern = `"${entryKey}"`;
  const entryIndex = content.indexOf(entryPattern);
  if (entryIndex !== -1) {
    // Entry exists — check if value is correct
    const afterEntry = content.slice(entryIndex + entryPattern.length);
    const valueMatch = afterEntry.match(/^(\s*:\s*)(true|false|"[^"]*"|\d+|null)/);
    if (valueMatch) {
      const currentValue = valueMatch[2];
      if (currentValue === entryValue) {
        return { content, changed: false };
      }
      // Value is wrong — replace it
      const valueStart =
        entryIndex + entryPattern.length + valueMatch[1].length;
      const newContent =
        content.slice(0, valueStart) +
        entryValue +
        content.slice(valueStart + currentValue.length);
      return {
        content: newContent,
        changed: true,
        corrected: true,
        oldValue: currentValue,
      };
    }
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

/**
 * Add a top-level boolean setting to JSONC content.
 */
function addBooleanSetting(content, settingKey, value) {
  const keyPattern = `"${settingKey}"`;
  const keyIndex = content.indexOf(keyPattern);

  if (keyIndex !== -1) {
    // Setting exists — check if value is correct
    const afterKey = content.slice(keyIndex + keyPattern.length);
    const valueMatch = afterKey.match(/^(\s*:\s*)(true|false)/);
    if (valueMatch) {
      const currentValue = valueMatch[2];
      const desiredValue = String(value);
      if (currentValue === desiredValue) {
        return { content, changed: false };
      }
      // Value is wrong — replace it
      const valueStart = keyIndex + keyPattern.length + valueMatch[1].length;
      const newContent =
        content.slice(0, valueStart) +
        desiredValue +
        content.slice(valueStart + currentValue.length);
      return {
        content: newContent,
        changed: true,
        corrected: true,
        oldValue: currentValue,
      };
    }
    return { content, changed: false };
  }

  // Add before final }
  const lastBrace = content.lastIndexOf("}");
  if (lastBrace === -1) {
    return { content, changed: false, error: "No closing } found" };
  }

  const before = content.slice(0, lastBrace).trimEnd();
  const needsComma = /[}\]"'\d]$|true$|false$|null$/.test(before);
  const insert = (needsComma ? "," : "") + `\n  "${settingKey}": ${value}`;

  return { content: before + insert + "\n}", changed: true };
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

  // Validate file has JSON/JSONC structure
  if (!content.includes("{") || !content.includes("}")) {
    console.error(
      `Settings file is not valid JSON/JSONC (missing {} structure): ${settingsPath}`,
    );
    process.exit(2);
  }

  // Detect VS Code version and filter settings
  const vscodeVersion = getVSCodeVersion();
  let settings = SETTINGS;
  const builtInAfter110 = [
    "chat.askQuestions.enabled",
    "github.copilot.chat.searchSubagent.enabled",
  ];
  if (vscodeVersion && versionGreaterThan(vscodeVersion, 1, 110)) {
    settings = SETTINGS.filter((s) => !builtInAfter110.includes(s.key));
    console.log(
      `VS Code ${vscodeVersion} detected — skipping built-in settings: ${builtInAfter110.join(", ")}`,
    );
  }

  // Apply each setting
  let anyChanged = false;
  for (const setting of settings) {
    let result;
    if (setting.type === "boolean") {
      result = addBooleanSetting(content, setting.key, setting.value);
      if (result.changed) {
        if (result.corrected) {
          console.log(
            `Updated: ${setting.key} = ${setting.value} (was: ${result.oldValue})`,
          );
        } else {
          console.log(`Added: ${setting.key} = ${setting.value}`);
        }
      } else {
        console.log(`Already configured: ${setting.key}`);
      }
    } else {
      result = addToSetting(content, setting.key, setting.entry, setting.value);
      if (result.changed) {
        if (result.corrected) {
          console.log(
            `Updated: ${setting.key} → ${setting.entry} = ${setting.value} (was: ${result.oldValue})`,
          );
        } else {
          console.log(`Added: ${setting.key} → ${setting.entry}`);
        }
      } else {
        console.log(`Already configured: ${setting.entry}`);
      }
    }
    if (result.error) {
      console.error(`Warning: ${result.error}`);
    }
    if (result.changed) {
      content = result.content;
      anyChanged = true;
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
