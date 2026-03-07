import { describe, it } from "node:test";
import assert from "node:assert";
import {
  buildRemovalEntries,
  buildSections,
  dedupeEntries,
  entryKey,
  formatKeybindingsFile,
} from "./generate-keybindings.mjs";

describe("buildRemovalEntries", () => {
  it("returns one removal per entry with command prefixed by minus", () => {
    const entries = [
      { key: "ctrl+s", command: "workbench.action.files.save" },
      { key: "escape", command: "closeReferenceSearch", when: "inReferenceSearchEditor" },
    ];
    const removals = buildRemovalEntries(entries);
    assert.strictEqual(removals.length, 2);
    assert.deepStrictEqual(removals[0], { key: "ctrl+s", command: "-workbench.action.files.save" });
    assert.deepStrictEqual(removals[1], {
      key: "escape",
      command: "-closeReferenceSearch",
      when: "inReferenceSearchEditor",
    });
  });

  it("leaves command unchanged when already prefixed with minus", () => {
    const entries = [{ key: "x", command: "-some.command" }];
    const removals = buildRemovalEntries(entries);
    assert.strictEqual(removals[0].command, "-some.command");
  });
});

describe("dedupeEntries", () => {
  it("removes duplicates by key+command+when+args and preserves first occurrence order", () => {
    const entries = [
      { key: "a", command: "cmd1" },
      { key: "a", command: "cmd1" },
      { key: "b", command: "cmd2", when: "true" },
      { key: "a", command: "cmd1" },
    ];
    const result = dedupeEntries(entries);
    assert.strictEqual(result.length, 2);
    assert.strictEqual(result[0].key, "a");
    assert.strictEqual(result[1].key, "b");
  });

  it("treats missing when/args as distinct from present when/args for identity", () => {
    const entries = [
      { key: "a", command: "c" },
      { key: "a", command: "c", when: "x" },
    ];
    const result = dedupeEntries(entries);
    assert.strictEqual(result.length, 2);
  });
});

describe("overlap behavior (current)", () => {
  it("when default and custom have same binding, removalEntries includes that removal", () => {
    const sameBinding = { key: "ctrl+s", command: "workbench.action.files.save", when: "editorTextFocus" };
    const defaultEntries = [sameBinding];
    const customEntries = [sameBinding];
    const removalEntries = buildRemovalEntries(defaultEntries);
    const sections = buildSections("replace", [{ title: "CUSTOM KEYBINDINGS", entries: customEntries }], removalEntries);

    const customSection = sections.find((s) => s.title === "CUSTOM KEYBINDINGS");
    const removalsSection = sections.find((s) => s.title === "DEFAULT KEYBINDINGS REMOVALS");
    assert.ok(customSection);
    assert.ok(removalsSection);
    assert.strictEqual(customSection.entries.length, 1);
    assert.strictEqual(removalsSection.entries.length, 1);
    assert.strictEqual(removalsSection.entries[0].command, "-workbench.action.files.save");
  });
});

describe("overlap behavior (desired)", () => {
  it("when default and custom match exactly, removalEntries does not include that removal", () => {
    const sameBinding = {
      key: "ctrl+s",
      command: "workbench.action.files.save",
      when: "editorTextFocus",
    };
    const otherDefault = { key: "ctrl+x", command: "other.command" };
    const defaultEntries = [sameBinding, otherDefault];
    const customKeysSet = new Set([entryKey(sameBinding)]);
    const removals = buildRemovalEntries(defaultEntries, customKeysSet);
    assert.strictEqual(removals.length, 1);
    assert.strictEqual(removals[0].command, "-other.command");
  });
});

describe("output structure", () => {
  it("sections order is CUSTOM then REMOVALS when custom has entries", () => {
    const customEntries = [{ key: "x", command: "cmd" }];
    const removalEntries = buildRemovalEntries([{ key: "y", command: "other" }]);
    const sections = buildSections("replace", [{ title: "CUSTOM KEYBINDINGS", entries: customEntries }], removalEntries);
    assert.strictEqual(sections.length, 2);
    assert.strictEqual(sections[0].title, "CUSTOM KEYBINDINGS");
    assert.strictEqual(sections[1].title, "DEFAULT KEYBINDINGS REMOVALS");
  });

  it("formatted output includes header comments and valid JSON array", () => {
    const sections = [
      { title: "CUSTOM KEYBINDINGS", entries: [{ key: "a", command: "b" }] },
      { title: "DEFAULT KEYBINDINGS REMOVALS", entries: [] },
    ];
    const content = formatKeybindingsFile({
      sections,
      sourceLabel: "keybindings.default.json",
      runCommand: "node cursor/scripts/generate-keybindings.mjs",
    });
    assert.ok(content.includes("// GENERATED FILE - DO NOT EDIT DIRECTLY"));
    assert.ok(content.includes("// Source: keybindings.default.json"));
    assert.ok(content.startsWith("//"));
    assert.ok(content.trimEnd().endsWith("]"));
    assert.ok(content.includes("CUSTOM KEYBINDINGS"));
  });
});
