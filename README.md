# Configuration

![Terminal Setup](assets/image-2.png)

This repository contains terminal and editor configurations optimized for development, featuring Neovim (AstroNvim v5), Ghostty with automatic theme switching, consistent color schemes, Fish shell integration, and Clojure configuration.

## Installation

Follow these steps in order to set up your terminal environment:

### 1. Neovim

**Install Neovim**:

```bash
brew install neovim
```

**Apply Neovim configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/nvim" /Users/slm.cassio/.config/nvim
```

### 2. Ghostty Terminal

**Install Ghostty**:

```bash
# Fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration
brew install --cask ghostty
```

**Apply Ghostty configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/ghostty" ~/.config/ghostty
```

### 3. Starship Prompt

**Install Starship**:

```bash
# The minimal, blazing-fast, and infinitely customizable prompt for any shell
brew install starship
```

**Apply Starship configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/starship" ~/.config/starship
```

### 4. Eza

**Install Eza**:

```bash
# A modern alternative to ls
brew install eza
```

**Apply Eza configuration**:

```bash
# Create symlink to config file to keep in sync
ln -sf "$(pwd)/eza" ~/.config/eza
```

### 5. Bat

**Install Bat**:

```bash
# A cat clone with syntax highlighting and Git integration
brew install bat
```

**Apply Bat configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/bat" ~/.config/bat

# Build bat cache to activate the theme
bat cache --build
```

### 6. FZF (Fuzzy Finder)

**Install FZF**:

```bash
# A command-line fuzzy finder
brew install fzf
```

**Apply FZF configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/fzf" ~/.config/fzf
```

### 7. fd

**Install fd**:

```bash
# A simple, fast and user-friendly alternative to 'find'
brew install fd
```

### 8. Zoxide

**Install Zoxide**:

```bash
# Zoxide is a smarter cd command, inspired by z and autojump.
brew install zoxide
```

### 9. Fish Shell

**Install Fish shell**:

```bash
# Fish is a smart and user-friendly command line shell.
brew install fish
```

**Apply Fish configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/fish" ~/.config/fish
```

**Configuration includes**:
- Morning routine function for system updates
- Enhanced aliases for common commands (ls, cp, mv, mkdir)
- Development shortcuts (dev, Dev directories)
- Clojure REPL shortcuts
- System utilities (DNS flush, IP address tools)
- Memory and CPU usage monitoring
- GPG and SSH agent setup
- Integration with Starship prompt and Zoxide

**One-time Git setup** (run these commands once):

```bash
# Enable colored output for Git commands
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
```

### 10. Fisher Plugin Manager

**Install Fisher**:

```bash
# A plugin manager for Fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

### 11. SDKMAN

**Install SDKMAN**:

```bash
# Reliable companion for effortlessly managing multiple Software Development Kits
curl -s "https://get.sdkman.io" | bash

# Makes command sdk
fisher install reitzig/sdkman-for-fish@v2.1.0
```

### 12. Clojure Configuration

**Install Clojure**:

```bash
# Clojure is a dynamic, general-purpose programming language
brew install clojure
```

**Apply Clojure configuration**:

```bash
# Create symlink to entire folder to keep in sync
ln -sf "$(pwd)/clojure" ~/.clojure
```

## Backup Existing Configuration

**Before applying new configurations, backup your existing setup**:

```bash
# Backup existing configurations (rename to .backup to preserve)

# Fish
mv ~/.config/fish ~/.config/fish.backup

# Ghostty
mv ~/.config/ghostty ~/.config/ghostty.backup

# Starship
mv ~/.config/starship.toml ~/.config/starship.toml.backup

# Bat
mv ~/.config/bat ~/.config/bat.backup

# Clojure
mv ~/.clojure ~/.clojure.backup

# Neovim (config, data, state, cache)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

## References

- **Neovim (AstroNvim v5)**: [practicalli/nvim-astro5](https://github.com/practicalli/nvim-astro5)
- **Ghostty Terminal**: [ghostty-org/ghostty](https://github.com/ghostty-org/ghostty)
- **Starship Prompt**: [starship/starship](https://github.com/starship/starship)
- **Eza**: [eza-community/eza](https://github.com/eza-community/eza)
- **Bat**: [sharkdp/bat](https://github.com/sharkdp/bat)
- **Zoxide**: [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- **Fish Shell**: [fish-shell/fish-shell](https://github.com/fish-shell/fish-shell)
- **Fisher Plugin Manager**: [jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)
- **SDKMAN Repository**: [sdkman/sdkman-cli](https://github.com/sdkman/sdkman-cli)
- **Fish Integration**: [reitzig/sdkman-for-fish](https://github.com/reitzig/sdkman-for-fish)
- **Clojure Configuration**: [practicalli/clojure-cli-config](https://github.com/practicalli/clojure-cli-config)
