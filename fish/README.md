# Fish Shell

Configuration for [Fish shell](https://fishshell.com) with modular conf.d files, custom functions, and automatic theme switching.

## conf.d/

Configuration files are loaded in numbered order.

### Public (this repo → `~/.config/fish/conf.d/`)

| File | Purpose |
|------|---------|
| `00-paths.fish` | PATH setup (uses `fish_add_path` for deduplication) |
| `10-env.fish` | Environment variables (`$EDITOR`, `$VISUAL`) |
| `20-history.fish` | Shell history behavior |
| `30-eza.fish` | Eza aliases and options |
| `30-fzf.fish` | FZF keybindings and options |
| `30-zoxide.fish` | Zoxide (smart `cd`) integration |
| `40-gpg.fish` | GPG/SSH agent setup |
| `50-starship.fish` | Starship prompt init |
| `60-sdk.fish` | SDKMAN integration |
| `70-nvm.fish` | Node version manager |
| `90-themes.fish` | Theme switching (loaded last) |

### Private (optional)

Machine-specific or sensitive conf.d files can live in `config-private/fish/vendor_conf.d/`. Fish has a built-in [vendor configuration](https://fishshell.com/docs/current/language.html#configuration-files) directory at `~/.local/share/fish/vendor_conf.d/` that it reads alongside your regular `conf.d/`. Files from both directories are merged and sorted by name, so the numbering scheme works across both — a private `35-work-env.fish` loads between public `30-fzf.fish` and `40-gpg.fish`.

```bash
ln -sf "$(pwd)/../config-private/fish/vendor_conf.d" ~/.local/share/fish/vendor_conf.d
```

## Abbreviations

All defined in `config.fish`. Fish expands abbreviations inline when you press space or enter.

### Navigation & Search

| Abbr | Expands to |
|------|------------|
| `e` | `eza -la --icons --header --hyperlink --git ...` |
| `f` | `fzf` |
| `fe` | `$EDITOR (fzf)` |
| `ff` | `open -a Finder (fd --type d \| fzf)` |
| `fz` | `z (fd --type d \| fzf)` |
| `fkill` | `kill (ps aux \| fzf ...)` |

### System Utilities

| Abbr | Description |
|------|-------------|
| `flushdns` | Flush DNS cache |
| `running_services` | List listening services |
| `whatismyipaddress` | Get public IP address |
| `localip` | Get local IP address |
| `sha1` / `md5sum` | Hash utilities |
| `psmem` / `psmem10` | Sort processes by memory usage |
| `pscpu` / `pscpu10` | Sort processes by CPU usage |

## Functions

Standalone function files in `functions/`.

| Command | Description |
|---------|-------------|
| `morning` | Update Homebrew |
| `uuid` | Generate UUID and copy to clipboard |

## Git Abbreviations

| Abbr | Expands to |
|------|------------|
| `g` | `git` |
| `gs` | `git status` |
| `ga` / `gaa` | `git add` / `git add .` |
| `gc` / `gca` | `git commit` / `git commit --amend` |
| `gps` / `gpl` | `git push` / `git pull` |
| `gd` / `gdh` | `git diff` / `git diff HEAD` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `grb` | `git rebase` |
| `grs` / `grt` / `gst` | `git reset` / `git restore` / `git stash` |
| `glog` | `git log --oneline --graph --decorate` |

## Theme System

Automatic theme switching based on macOS appearance (dark/light):

- **FZF**: Catppuccin Mocha (dark) / Latte (light)
- **Eza**: Catppuccin color schemes
- Themes are applied in `90-themes.fish` (loaded last so all tools are available)
