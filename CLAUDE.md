# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS development environment configuration managing terminal emulators, shells, CLI tools, prompts, and code editors. Uses Catppuccin theme (Mocha dark / Latte light) with automatic macOS appearance switching across all tools.

## Key Architecture

### Tool Composition
Tools compose via environment variables and piping following Unix philosophy:
- **FZF** uses **fd** for file finding, **Bat** for file previews, **Eza** for directory previews (see `fzf/30-fzf.fish` for `FZF_DEFAULT_OPTS`)
- **Zoxide** reuses FZF's preview pattern via `_ZO_FZF_OPTS`
- **Fish** orchestrates all tools via `conf.d/` numbered loading and `init fish | source` pattern

### Fish Shell Modular Configuration
Files in `fish/conf.d/` load alphabetically by Fish; numbered prefix ensures dependency order:
- `00-paths.fish` - PATH setup (uses `fish_add_path` for deduplication)
- `10-env.fish` - Environment variables (EDITOR, VISUAL)
- `20-history.fish` - Shell history
- `30-*.fish` - Tool integrations (eza, fzf, zoxide)
- `40-gpg.fish` - GPG/SSH agent
- `50-starship.fish` - Prompt initialization
- `60-sdk.fish` - SDKMAN for Java
- `70-nvm.fish` - Node version manager (nvm.fish)
- `90-themes.fish` - Theme switching (loaded last to override all tool settings)

Custom functions live in `fish/functions/` (e.g., `uuid.fish` generates UUID to clipboard, `morning.fish` runs system updates). Abbreviations and tool initialization (starship, zoxide, fzf via `init fish | source`) happen in `fish/config.fish` within the interactive block.

### Theme Switching System
Theme detection uses macOS native API: `defaults read -g AppleInterfaceStyle`

Per-tool implementation:
- `fish/conf.d/90-themes.fish` - Orchestrates theme switching, sources tool-specific switchers
- `eza/theme-switcher.fish` - Copies `eza-catppuccin-{mocha,latte}-pink.yml` to `theme.yml`
- `fzf/theme-switcher.fish` - Sources `catppuccin-{mocha,latte}.fish` to set `FZF_DEFAULT_OPTS`
- Ghostty - Native support: `theme = light:Catppuccin Latte,dark:Catppuccin Mocha`
- Neovim/Starship - Hardcoded to Catppuccin (no dynamic switching)

Theme changes require a new shell session (no live updates).

### Neovim Structure (AstroNvim v5)
Leader keys: `<Leader>` = space, `<localleader>` = comma

- `nvim/init.lua` - Entry point, lazy.nvim bootstrap, sets shell to Fish
- `nvim/lua/lazy_setup.lua` - Plugin manager with `{ import = "plugins.category" }` pattern
- `nvim/lua/plugins/` - Plugin specs organized by purpose:
  - `core/user.lua` - AstroNvim overrides (colorscheme, keymaps, Conjure config)
  - `ui/` - Visual plugins (which-key, snacks, showkeys)
  - `editing/` - Text manipulation (trim.nvim)
  - `language/` - Language-specific (other.nvim for src/test switching)
  - `tools/` - Development tools (claudecode.nvim)

Each category has an `init.lua` that imports sibling plugins.

## Symlink Installation

Configurations are symlinked from this repo to their expected locations:
- `fish/` → `~/.config/fish/`
- `ghostty/` → `~/.config/ghostty/`
- `starship/` → `~/.config/starship/`
- `nvim/` → `~/.config/nvim/`
- `bat/` → `~/.config/bat/`
- `vscode/` → `~/Library/Application Support/{Cursor,Antigravity}/User/`
- `eza/` → `~/.config/eza/`
- `fzf/` → `~/.config/fzf/`
- `clojure/` → `~/.clojure/`

After symlinking bat: run `bat cache --build` to activate themes.

## Clojure Development

`clojure/deps.edn` provides REPL aliases:
- `clj -M:repl/basic` - Interactive REPL with nREPL/CIDER
- `clj -M:repl/headless` - Headless REPL for editor connections
- `clj -M:test` - Run tests with Kaocha

Neovim Conjure keybindings use `<localleader>` (comma). Toggle Kaocha test runner: `<localleader>tk`.
