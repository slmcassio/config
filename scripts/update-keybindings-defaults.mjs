import fs from "fs/promises";
import path from "path";

const repoRoot = process.cwd();
const defaultsPath = path.resolve(repoRoot, "vscode/default-keybindings.json");
const customPath = path.resolve(repoRoot, "vscode/keybindings.custom.json");
const outputPath = path.resolve(repoRoot, "vscode/keybindings.json");
const runCommand = "node scripts/update-keybindings-defaults.mjs";

const defaults = await loadDefaultKeybindings(defaultsPath);
const removalEntries = buildRemovalEntries(defaults.entries);
const customEntries = await readCustomEntries(customPath);

await writeKeybindingsFile({
  outputPath,
  mode: "replace",
  customEntries,
  removalEntries,
  sourceLabel: defaults.sourceLabel,
  runCommand,
});

console.log(`Updated ${outputPath}`);

async function loadDefaultKeybindings(defaultsFile) {
  const sourceEntries = await parseKeybindingsFile(defaultsFile);
  return {
    entries: dedupeEntries(sourceEntries),
    sourceLabel: path.basename(defaultsFile),
  };
}

async function parseKeybindingsFile(filePath, minEntries = 10) {
  const raw = await fs.readFile(filePath, "utf8");
  const cleaned = stripJsonComments(raw);
  const normalized = cleaned.replace(/,\\s*([}\\]])/g, "$1");
  const parsed = JSON.parse(normalized);

  if (!Array.isArray(parsed)) {
    throw new Error(`Expected an array in ${filePath}`);
  }

  const entries = parsed
    .filter((entry) => entry && typeof entry === "object")
    .filter((entry) => typeof entry.key === "string" && typeof entry.command === "string")
    .map((entry) => normalizeEntry(entry));

  if (entries.length < minEntries) {
    throw new Error(`Too few keybindings parsed from ${filePath}`);
  }

  return entries;
}

function normalizeEntry(entry) {
  const normalized = {
    key: entry.key,
    command: entry.command,
  };
  if (entry.when) normalized.when = entry.when;
  if (entry.args) normalized.args = entry.args;
  return normalized;
}

function buildRemovalEntries(entries) {
  return entries.map((entry) => {
    const command = entry.command.startsWith("-")
      ? entry.command
      : `-${entry.command}`;
    return {
      key: entry.key,
      command,
      ...(entry.when ? { when: entry.when } : {}),
      ...(entry.args ? { args: entry.args } : {}),
    };
  });
}

function dedupeEntries(entries) {
  const seen = new Set();
  const result = [];

  for (const entry of entries) {
    const key = JSON.stringify({
      key: entry.key,
      command: entry.command,
      when: entry.when ?? null,
      args: entry.args ?? null,
    });
    if (seen.has(key)) continue;
    seen.add(key);
    result.push(entry);
  }

  return result;
}

async function writeKeybindingsFile({ outputPath, mode, customEntries, removalEntries, sourceLabel, runCommand }) {
  let sections;
  const combinedCustom = dedupeEntries(customEntries);
  if (mode === "append" || combinedCustom.length > 0) {
    sections = [
      { title: "CUSTOM KEYBINDINGS", entries: combinedCustom },
      { title: "DEFAULT KEYBINDINGS REMOVALS", entries: removalEntries },
    ];
  } else {
    sections = [
      { title: "DEFAULT KEYBINDINGS REMOVALS", entries: removalEntries },
    ];
  }

  const content = formatKeybindingsFile({ sections, sourceLabel, runCommand });
  await fs.writeFile(outputPath, content, "utf8");
}

function formatKeybindingsFile({ sections, sourceLabel, runCommand }) {
  const totalEntries = sections.reduce((sum, section) => sum + section.entries.length, 0);
  let index = 0;
  const lines = [];

  lines.push("// GENERATED FILE - DO NOT EDIT DIRECTLY");
  lines.push(`// Source: ${sourceLabel}`);
  lines.push(`// Run: ${runCommand}`);
  lines.push("[");

  for (const section of sections) {
    if (section.entries.length === 0) continue;
    lines.push(`  // ${section.title}`);
    for (const entry of section.entries) {
      index += 1;
      const isLast = index === totalEntries;
      lines.push(...formatEntry(entry, 2, isLast));
    }
  }

  lines.push("]");
  return lines.join("\n");
}

function formatEntry(entry, indent, isLast) {
  const spacing = " ".repeat(indent);
  const json = JSON.stringify(entry, null, 2);
  const lines = json.split("\n");
  const formatted = lines.map((line) => `${spacing}${line}`);
  if (!isLast) {
    formatted[formatted.length - 1] = `${formatted[formatted.length - 1]},`;
  }
  return formatted;
}

function stripJsonComments(text) {
  let result = "";
  let inString = false;
  let stringChar = "";
  let inLineComment = false;
  let inBlockComment = false;

  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];

    if (inLineComment) {
      if (char === "\n") {
        inLineComment = false;
        result += char;
      }
      continue;
    }

    if (inBlockComment) {
      if (char === "*" && next === "/") {
        inBlockComment = false;
        i += 1;
      }
      continue;
    }

    if (inString) {
      result += char;
      if (char === "\\" && next) {
        result += next;
        i += 1;
        continue;
      }
      if (char === stringChar) {
        inString = false;
        stringChar = "";
      }
      continue;
    }

    if (char === "\"" || char === "'") {
      inString = true;
      stringChar = char;
      result += char;
      continue;
    }

    if (char === "/" && next === "/") {
      inLineComment = true;
      i += 1;
      continue;
    }

    if (char === "/" && next === "*") {
      inBlockComment = true;
      i += 1;
      continue;
    }

    result += char;
  }

  return result;
}

async function readCustomEntries(customPath) {
  return parseKeybindingsFile(customPath, 1);
}
