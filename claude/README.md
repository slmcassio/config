# Claude Code

Configuration for [Claude Code](https://claude.ai/code) — permissions, hooks, agents, and a living knowledge base.

Uses a **two-repo split**: this public repo holds generic config, while a private sibling repo (`config-private/`) holds machine profiles and the knowledge base.

## Prerequisites

Clone both repos as siblings in the same parent directory:

```bash
cd ~/Developer    # or your dev directory
git clone git@github.com:slmcassio/config.git
git clone git@github.com:slmcassio/config-private.git
```

This gives you:

```
parent-dir/
├── config/                        ← this repo (public)
│   └── claude/
│       ├── CLAUDE.md              # Global instructions (brain)
│       ├── templates/
│       │   └── settings.json.template
│       ├── hooks/                 # PreToolUse hooks
│       ├── agents/                # Agent templates
│       ├── install.sh             # Renders + deploys to ~/.claude/
│       └── knowledge/             # Example structure (public)
│
└── config-private/                ← sibling repo (private)
    └── claude/
        ├── profiles/              # Machine-specific config
        │   ├── <machine>.env
        │   └── <machine>.extra.json
        └── knowledge/             # Living knowledge base
```

## Install

> **Fish shell note**: run as `./claude/install.sh` or `bash claude/install.sh` — don't `source` it.

```bash
# From the config repo root — auto-detects machine via whoami:
./claude/install.sh

# Or specify a profile explicitly:
./claude/install.sh --profile personal
```

`install.sh` will:
1. Detect `config-private/` sibling (falls back to local if absent)
2. Match your profile by `whoami` → `MACHINE_USER`
3. Render `settings.json.template` with your profile variables
4. Merge extra permissions from `<profile>.extra.json` (if present)
5. Backup existing `~/.claude/` config
6. Deploy everything to `~/.claude/`

## Verify

```bash
readlink ~/.claude/CLAUDE.md          # → config/claude/CLAUDE.md
readlink ~/.claude/knowledge          # → config-private/claude/knowledge
file ~/.claude/settings.json          # → regular file (not symlink)
ls -la ~/.claude/hooks/               # → real files, executable
grep '{{' ~/.claude/settings.json     # → no output (all vars substituted)
```

## Rollback

```bash
ls -d ~/.claude/pre-dotfiles-backup-*          # find the backup
BACKUP_DIR=~/.claude/pre-dotfiles-backup-XXXXXXXX-XXXXXX

rm -f ~/.claude/CLAUDE.md
cp "$BACKUP_DIR/CLAUDE.md" ~/.claude/CLAUDE.md
cp "$BACKUP_DIR/settings.json" ~/.claude/settings.json 2>/dev/null
cp "$BACKUP_DIR/settings.local.json" ~/.claude/settings.local.json 2>/dev/null
[ -d "$BACKUP_DIR/hooks" ] && cp -r "$BACKUP_DIR/hooks" ~/.claude/hooks

echo "Rollback complete."
```

## GitHub MCP Server

Integrates GitHub into Claude Code (issues, PRs, repos, code search).

### Setup

1. Install the server:

```bash
brew install github-mcp-server
```

2. Create a [fine-grained GitHub PAT](https://github.com/settings/tokens?type=beta) with these permissions:

| Permission | Access |
|---|---|
| Contents | Read |
| Issues | Read and write |
| Metadata | Read (mandatory) |
| Pull requests | Read and write |

3. Store the token in macOS Keychain (paste when prompted):

```bash
security add-generic-password -a "github-mcp" -s "claude-mcp" -w
```

4. In Claude Code, run `/mcp` and install the **GitHub** plugin.

The hook at `hooks/github-mcp-server.sh` reads the token from Keychain at runtime — no plaintext storage.
