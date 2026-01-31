# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS development environment configuration managing terminal emulators, shells, CLI tools, prompts, and code editors. Uses Catppuccin theme (Mocha dark / Latte light) with automatic macOS appearance switching across all tools.

## Key Architecture

### Fish Shell Modular Configuration
Files in `fish/conf.d/` load in numbered order (00-90):
- `00-paths.fish` - PATH setup
- `10-env.fish` - Environment variables (EDITOR, VISUAL)
- `20-history.fish` - Shell history
- `30-*.fish` - Tool integrations (eza, fzf, zoxide)
- `40-gpg.fish` - GPG/SSH agent
- `50-starship.fish` - Prompt initialization
- `60-sdk.fish` - SDKMAN for Java
- `90-themes.fish` - Theme switching (loaded last to override)

Custom functions live in `fish/functions/`, abbreviations in `fish/config.fish`. Tool initialization (starship, zoxide, fzf) happens in `fish/config.fish` within the interactive block.

### Theme Switching System
Each tool has theme switcher scripts that respond to macOS appearance:
- `eza/theme-switcher.fish` - Copies appropriate `.yml` to `theme.yml`
- `fzf/theme-switcher.fish` - Sources appropriate color config
- Ghostty, Starship, Neovim, and VSCode handle themes via their own configs

### Neovim Structure (AstroNvim v5)
- `nvim/init.lua` - Entry point, lazy.nvim bootstrap
- `nvim/lua/lazy_setup.lua` - Plugin manager configuration
- `nvim/lua/plugins/` - Plugin specs organized by purpose:
  - `core/` - User overrides for AstroNvim
  - `ui/` - Visual plugins (which-key, snacks, showkeys)
  - `editing/` - Text manipulation (surround, autopairs, trim)
  - `language/` - Language-specific (Conjure for Clojure)
  - `tools/` - Development tools (claudecode.nvim)

## Symlink Installation

Configurations are symlinked from this repo to their expected locations:
- `fish/` → `~/.config/fish/`
- `ghostty/` → `~/.config/ghostty/`
- `starship/starship.toml` → `~/.config/starship.toml`
- `nvim/` → `~/.config/nvim/`
- `bat/` → `~/.config/bat/`
- `vscode/` → `~/Library/Application Support/{Cursor,Antigravity}/User/`
- `eza/` → `~/.config/eza/`
- `fzf/` → `~/.config/fzf/`
- `clojure/` → `~/.clojure/`

## Clojure Development

`clojure/deps.edn` provides REPL aliases:
- `clj -M:repl/basic` - Interactive REPL with nREPL/CIDER
- `clj -M:repl/headless` - Headless REPL for editor connections
- `clj -M:test` - Run tests with Kaocha
