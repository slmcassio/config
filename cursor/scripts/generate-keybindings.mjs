import fs from "fs/promises";
import path from "path";
import os from "node:os";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const isMain = process.argv[1] && path.resolve(process.cwd(), process.argv[1]) === __filename;

function resolveDefaultPath(rawPath) {
  const expanded = rawPath.startsWith("~")
    ? path.join(os.homedir(), rawPath.slice(1))
    : rawPath;
  return path.resolve(expanded);
}

function parseDefaultArg(args) {
  const i = args.indexOf("--default");
  if (i === -1) return null;
  if (args[i].includes("=")) return args[i].split("=", 2)[1];
  if (i + 1 < args.length) return args[i + 1];
  return null;
}

if (isMain) {
  const args = process.argv.slice(2);
  const defaultArgRaw = parseDefaultArg(args);

  if (!defaultArgRaw) {
    console.error("Usage: node cursor/scripts/generate-keybindings.mjs --default <path>");
    console.error('  e.g. --default "~/Library/Application Support/Cursor/User/keybindings.json"');
    process.exit(1);
  }

  const repoRoot = process.cwd();
  const defaultPath = resolveDefaultPath(defaultArgRaw);

  const customPath = path.resolve(repoRoot, "cursor/keybindings/keybindings.custom.json");
  const outputPath = path.resolve(repoRoot, "cursor/keybindings/keybindings.json");
  const runCommand = `node cursor/scripts/generate-keybindings.mjs --default "${defaultArgRaw}"`;

  const customEntries = await readCustomEntries(customPath);

  const customSections = [
    { title: "CUSTOM KEYBINDINGS", entries: customEntries },
  ];

  let defaultsEntries = [];
  let sourceLabel = "";
  try {
    const loaded = await loadDefaultKeybindings(defaultPath);
    defaultsEntries = loaded.entries;
    sourceLabel = loaded.sourceLabel;
  } catch (e) {
    console.warn(`Could not load ${defaultPath}`);
  }

  const combinedCustom = dedupeEntries(customEntries);
  const customKeys = new Set(combinedCustom.map(entryKey));

  const removalEntries = buildRemovalEntries(defaultsEntries, customKeys);

  await writeKeybindingsFile({
    repoRoot,
    outputPath,
    mode: "replace",
    customSections,
    removalEntries,
    sourceLabel: sourceLabel || path.basename(defaultPath),
    runCommand,
  });

  console.log(`Updated ${outputPath}`);
}

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

function entryKey(entry) {
  return JSON.stringify({
    key: entry.key,
    command: entry.command,
    when: entry.when ?? null,
    args: entry.args ?? null,
  });
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

function buildRemovalEntries(entries, customKeysSet) {
  const filtered =
    customKeysSet != null
      ? entries.filter((entry) => !customKeysSet.has(entryKey(entry)))
      : entries;
  return filtered.map((entry) => {
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
    const key = entryKey(entry);
    if (seen.has(key)) continue;
    seen.add(key);
    result.push(entry);
  }
  return result;
}

function buildSections(mode, customSections, removalEntries) {
  const seen = new Set();
  const finalSections = [];

  if (mode === "append" || customSections.some(s => s.entries.length > 0)) {
    for (const section of customSections) {
      if (section.entries.length === 0) continue;
      const dedupedEntries = [];
      for (const entry of section.entries) {
        const key = entryKey(entry);
        if (seen.has(key)) continue;
        seen.add(key);
        dedupedEntries.push(entry);
      }
      if (dedupedEntries.length > 0) {
        finalSections.push({ title: section.title, entries: dedupedEntries });
      }
    }
  }

  if (removalEntries.length > 0) {
    finalSections.push({ title: "DEFAULT KEYBINDINGS REMOVALS", entries: removalEntries });
  }

  return finalSections;
}

function normalizeRepoPaths(content, repoRoot) {
  const absolute = path.resolve(repoRoot);
  const withSep = absolute + path.sep;
  return content
    .split(withSep)
    .join("")
    .split(absolute)
    .join("");
}

async function writeKeybindingsFile({ repoRoot, outputPath, mode, customSections, removalEntries, sourceLabel, runCommand }) {
  const sections = buildSections(mode, customSections, removalEntries);
  let content = formatKeybindingsFile({ sections, sourceLabel, runCommand });
  if (repoRoot) content = normalizeRepoPaths(content, repoRoot);
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
  return parseKeybindingsFile(customPath, 0);
}

export { buildRemovalEntries, buildSections, dedupeEntries, entryKey, formatKeybindingsFile };
