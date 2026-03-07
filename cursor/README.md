# Cursor

Configuration for [Cursor](https://cursor.com) editor — settings, keybindings, and extensions.

## Structure

```
cursor/
├── extensions/
│   └── extension-list        # One extension ID per line
├── keybindings/
│   ├── keybindings.json      # Deployed keybindings (generated)
│   └── keybindings.custom.json  # Your custom bindings (source of truth)
├── scripts/
│   ├── generate-keybindings.mjs       # Keybinding generator
│   └── generate-keybindings.test.mjs  # Tests
└── settings/
    └── settings.json         # Editor settings
```

## Keybindings

The keybindings file is **generated** — it removes all default bindings and applies only your custom ones from `keybindings.custom.json`.

### Regenerating keybindings

1. In Cursor, run `Preferences: Open Default Keyboard Shortcuts (JSON)` and save the output (e.g., to `~/Library/Application Support/Cursor/User/keybindings-default.json`)
2. Run the generator:

```bash
node cursor/scripts/generate-keybindings.mjs \
  --default "~/Library/Application Support/Cursor/User/keybindings-default.json"
```

This produces `keybindings/keybindings.json` with all defaults negated + your custom bindings appended.

## Key Repeat (macOS)

If holding `j`/`k` doesn't repeat, enable per-app key repeat:

```bash
# bash/zsh
CURSOR_BUNDLE_ID="$(osascript -e 'id of app "Cursor"')"
defaults write "$CURSOR_BUNDLE_ID" ApplePressAndHoldEnabled -bool false
```

Relaunch Cursor after running.
