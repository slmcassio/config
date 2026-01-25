# Dotfiles Configuration

Personal development environment configuration for macOS with Fish shell, Neovim, and VSCode-based editors. Uses Catppuccin theme system with light/dark mode support.

## Key Conventions

### Fish Shell Configuration

- Config files in `fish/conf.d/` are loaded in alphabetical order
- Prefix numbers control load order: `00-` loads first, `90-` loads last
- Number ranges:
  - `00-09`: Paths
  - `10-19`: Environment variables
  - `20-29`: History settings
  - `30-39`: Tool integrations (eza, fzf, zoxide)
  - `40-49`: Security (gpg)
  - `50-59`: Prompt (starship)
  - `60-69`: SDK managers
  - `90-99`: Theme switching (should load last)

### Theme System

- Catppuccin themes: Latte (light) and Mocha (dark)
- Theme files exist in pairs for: bat, eza, fzf
- Theme switchers in `*/theme-switcher.fish` handle transitions
- Pink accent color is used consistently across tools

### Neovim

- Uses AstroNvim v5 with Lazy.nvim plugin manager
- Plugins organized by category in `nvim/lua/plugins/`: core, ui, editing, language
- Run `:Lazy sync` after plugin changes
- Use `:checkhealth` to verify configuration

### VSCode Configuration

- Shared across VSCode, Cursor, and Antigravity editors
- Keybindings follow Vim-inspired patterns where possible
- Extensions listed in `vscode/extension-list`

## Testing Changes

1. **Fish config**: Source with `source ~/.config/fish/config.fish` or open new terminal
2. **Neovim**: Restart nvim; use `:checkhealth` to verify
3. **Theme changes**: Test both light and dark variants
4. **VSCode/Cursor/Antigravity**: Reload window with Cmd+Shift+P → "Reload Window"

## File Dependencies

- `fish/conf.d/90-themes.fish` depends on theme-switcher files in `eza/`, `fzf/`
- `nvim/init.lua` → `nvim/lazy_setup.lua` → plugins in `nvim/lua/plugins/`
- `bat/config` references themes in `bat/themes/`

## Common Tasks

### Adding a new Fish abbreviation

Edit `fish/config.fish` and add to the abbreviations section.

### Adding a new tool configuration

1. Create directory: `toolname/`
2. Add config files with Catppuccin theme support (both light/dark if applicable)
3. Add Fish integration in `fish/conf.d/` with appropriate number prefix
4. Update README.md with installation instructions

### Modifying Neovim plugins

1. Edit or create file in `nvim/lua/plugins/category/`
2. Run `:Lazy sync` in Neovim
3. Restart Neovim and run `:checkhealth`
