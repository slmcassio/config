# Configuration

![Terminal Setup](assets/image.png)

Terminal and editor configurations for macOS — Ghostty, Fish shell, Neovim, Cursor, and Claude Code. All themed with [Catppuccin](https://github.com/catppuccin/catppuccin).

## Clone

```bash
cd ~/Developer    # or your dev directory
git clone git@github.com:slmcassio/config.git
git clone git@github.com:slmcassio/config-private.git   # optional, for profiles & private config
cd config
```

All commands below assume you're in the `config/` root.

## Before You Start

Backup any existing config you want to keep:

<details>
<summary>Backup commands</summary>

```bash
# Ghostty
mv ~/.config/ghostty ~/.config/ghostty.backup

# Eza
mv ~/.config/eza ~/.config/eza.backup

# Bat
mv ~/.config/bat ~/.config/bat.backup

# FZF
mv ~/.config/fzf ~/.config/fzf.backup

# Fish
mv ~/.config/fish ~/.config/fish.backup

# Starship
mv ~/.config/starship ~/.config/starship.backup

# Clojure
mv ~/.clojure ~/.clojure.backup

# Neovim (config, data, state, cache)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup

# Cursor (keybindings and settings)
mv ~/Library/Application\ Support/Cursor/User/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json.backup
mv ~/Library/Application\ Support/Cursor/User/settings.json ~/Library/Application\ Support/Cursor/User/settings.json.backup

# Claude Code (install.sh creates its own backups, but just in case)
mv ~/.claude ~/.claude.backup
```

</details>

## Installation

Install in order — later tools depend on earlier ones.

### 1. Ghostty

```bash
brew install --cask ghostty
ln -sf "$(pwd)/ghostty" ~/.config/ghostty
```

### 2. Navigation & Search Tools

```bash
brew install eza           # Modern ls with icons and git integration
ln -sf "$(pwd)/eza" ~/.config/eza

brew install fzf            # Fuzzy finder
ln -sf "$(pwd)/fzf" ~/.config/fzf

brew install fd             # Modern find
brew install zoxide         # Smart cd that learns your habits
```

### 3. Bat

```bash
brew install bat            # cat with syntax highlighting
ln -sf "$(pwd)/bat" ~/.config/bat
bat cache --build
```

### 4. ripgrep

```bash
brew install ripgrep        # Fast recursive search
```

### 5. Fish Shell

```bash
brew install fish
ln -sf "$(pwd)/fish" ~/.config/fish
```

If you have private config in `config-private/fish/vendor_conf.d/`:

```bash
ln -sf "$(pwd)/../config-private/fish/vendor_conf.d" ~/.local/share/fish/vendor_conf.d
```

See [fish/README.md](fish/README.md) for how this works, functions, abbreviations, and theme details.

### 6. Starship Prompt

```bash
brew install starship
ln -sf "$(pwd)/starship" ~/.config/starship
```

### 7. Fisher Plugin Manager

> Steps 7-9 must be run from **Fish shell** (`fish`), not bash/zsh.

```fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

### 8. SDKMAN

```bash
curl -s "https://get.sdkman.io" | bash
```

```fish
fisher install reitzig/sdkman-for-fish@v2.1.0
```

### 9. nvm.fish

```fish
fisher install jorgebucaran/nvm.fish
nvm install lts
set -U nvm_default_version lts
```

### 10. Clojure

```bash
brew install clojure
ln -sf "$(pwd)/clojure" ~/.clojure
```

### 11. Neovim

**Note**: Neovim leverages many CLI tools from previous steps (bat, fzf, fd, ripgrep).

```bash
brew install neovim
ln -sf "$(pwd)/nvim" ~/.config/nvim
```

### 12. Cursor

```bash
brew install --cask cursor
ln -sf "$(pwd)/cursor/keybindings/keybindings.json" ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -sf "$(pwd)/cursor/settings/settings.json" ~/Library/Application\ Support/Cursor/User/settings.json
cat cursor/extensions/extension-list | xargs -I {} cursor --install-extension {}
```

See [cursor/README.md](cursor/README.md) for keybinding generation and macOS key repeat fix.

### 13. Claude Code

```bash
brew install claude
brew install jq
./claude/install.sh
```

See [claude/README.md](claude/README.md) for the two-repo setup, profiles, and GitHub MCP integration.

## References

- [Ghostty](https://github.com/ghostty-org/ghostty) · [Eza](https://github.com/eza-community/eza) · [FZF](https://github.com/junegunn/fzf) · [fd](https://github.com/sharkdp/fd) · [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [Bat](https://github.com/sharkdp/bat) · [ripgrep](https://github.com/BurntSushi/ripgrep)
- [Fish Shell](https://github.com/fish-shell/fish-shell) · [Starship](https://github.com/starship/starship) · [Fisher](https://github.com/jorgebucaran/fisher)
- [SDKMAN](https://github.com/sdkman/sdkman-cli) · [sdkman-for-fish](https://github.com/reitzig/sdkman-for-fish) · [nvm.fish](https://github.com/jorgebucaran/nvm.fish)
- [Clojure CLI Config](https://github.com/practicalli/clojure-cli-config) · [Neovim (AstroNvim v5)](https://github.com/practicalli/nvim-astro5)
- [Cursor](https://cursor.com) · [Claude Code](https://claude.ai/code) · [Catppuccin](https://github.com/catppuccin/catppuccin)
