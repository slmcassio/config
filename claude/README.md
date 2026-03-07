# claude

Hello, Claude Code. If you're reading this, it means the user has shared this repository with you so you can set up their environment. This file contains everything you need to install, backup, and rollback their Claude Code configuration.

## What is this repository?

This is the **public** half of a two-repo configuration split:

| Repo | Visibility | Contents |
|------|------------|----------|
| `slmcassio/config` | public | generic config, templates, hooks, agents |
| `slmcassio/config-private` | private | machine profiles, knowledge base |

Both repos must be cloned as **siblings in the same parent directory**. `install.sh` auto-detects the private sibling — no extra flags needed.

```
config/                        ← this repo (public)
├── claude/
│   ├── CLAUDE.md              # Global instructions (personas, workflow rules, behaviors)
│   ├── templates/
│   │   └── settings.json.template  # Permission rules template (rendered per machine)
│   ├── hooks/                 # PreToolUse hooks (auto-approve scripts)
│   ├── agents/                # Custom agent definitions (global templates)
│   ├── install.sh             # Renders template + deploys to ~/.claude/
│   └── README.md              # You are here

config-private/                ← sibling private repo
└── claude/
    ├── profiles/              # Machine-specific config
    │   ├── personal.env       # Personal machine vars (username, dev dir)
    │   ├── work.env           # Work machine vars
    │   └── work.extra.json    # Extra permissions for work machine
    └── knowledge/             # Living knowledge base (domain, architecture, operations)
        ├── README.md
        └── domain/
```

## Deployment strategy

Not all files are deployed the same way. Some are **symlinked** (edits go directly to the repo), others must be **copied** (Claude Code breaks with symlinks for certain files).

| File / Dir | Deploy method | Reason |
|------------|---------------|--------|
| `CLAUDE.md` | **symlink** | Works fine; edits go directly to repo |
| `settings.json` | **copy** (rendered) | Symlinked settings.json breaks Claude Code ([#3575](https://github.com/anthropics/claude-code/issues/3575)) |
| `hooks/` | **copy** | Same sensitive-path issue; must be real files |
| `knowledge/` | **symlink** → `config-private` | Sensitive; lives in private repo |
| `agents/` | **symlink** | Global agent templates; works as symlink |

`install.sh` handles backup, rendering (template + profile merge), and deployment automatically.

## Step 1: Clone both repos

Both repos must be siblings in the same parent directory so `install.sh` can auto-detect the private one. Navigate to your dev directory first, then clone:

```bash
git clone git@github.com:slmcassio/config.git
git clone git@github.com:slmcassio/config-private.git
```

If already cloned, just pull both from that same directory:

```bash
git -C config pull && git -C config-private pull
```

## Step 2: Install

> **Fish shell note**: `install.sh` is a bash script. Run it as `./claude/install.sh` or
> `bash claude/install.sh` — do **not** `source` it from fish.

```bash
# From the config repo root — auto-detects machine via whoami:
./claude/install.sh

# Or specify a profile explicitly:
./claude/install.sh --profile personal
./claude/install.sh --profile work
```

`install.sh` will:
1. Detect `config-private/` sibling and use its `profiles/` (falls back to local if absent)
2. Detect your profile by matching `whoami` to `MACHINE_USER` (or use `--profile`)
3. Render `templates/settings.json.template` with your machine's variables
4. Merge `profiles/<name>.extra.json` permissions via `jq`
5. Backup existing `~/.claude/{CLAUDE.md,settings.json,settings.local.json,hooks/}`
6. Deploy: symlink `CLAUDE.md`, `agents/`, `knowledge/`; copy `settings.json` + `hooks/`

## Step 3: Verify

```bash
readlink ~/.claude/CLAUDE.md                        # → <config>/claude/CLAUDE.md
readlink ~/.claude/knowledge                        # → <config-private>/claude/knowledge
file ~/.claude/settings.json                        # → regular file (not symlink)
ls -la ~/.claude/hooks/                             # → real files, executable
grep '{{' ~/.claude/settings.json                   # → no output (all vars substituted)
```

## Rollback

```bash
# Find the backup
ls -d ~/.claude/pre-dotfiles-backup-*

# Restore (use the actual backup directory name)
BACKUP_DIR=~/.claude/pre-dotfiles-backup-XXXXXXXX-XXXXXX

rm -f ~/.claude/CLAUDE.md
cp "$BACKUP_DIR/CLAUDE.md" ~/.claude/CLAUDE.md
cp "$BACKUP_DIR/settings.json" ~/.claude/settings.json 2>/dev/null
cp "$BACKUP_DIR/settings.local.json" ~/.claude/settings.local.json 2>/dev/null
[ -d "$BACKUP_DIR/hooks" ] && cp -r "$BACKUP_DIR/hooks" ~/.claude/hooks

echo "Rollback complete."
```

## Forking this repository

If you want to use this setup as a starting point for your own Claude Code configuration, **fork it** — do not clone directly. This prevents accidental pushes to the original repo.

### Step 1: Fork and clone

```bash
# Fork on GitHub first (via UI or gh cli), then:
gh repo fork slmcassio/config --clone --remote
```

### Step 2: Create a private repo for your profiles

Profiles contain machine-specific paths and usernames — keep them private. `install.sh` looks for a sibling directory named `config-private/` next to `config/` and uses it automatically if present. If it's absent, it falls back to a local `profiles/` directory inside the public repo (useful for quick local setups without a private repo).

Create a private GitHub repo (e.g., `your-username/config-private`) and clone both into the same parent directory:

```bash
cd ~/your-dev-dir   # same directory where you cloned config/

git clone git@github.com:YOUR_USERNAME/config-private.git
```

They must be siblings:

```
your-dev-dir/
├── config/          ← your fork (public)
└── config-private/  ← your private repo
```

The required structure inside `config-private/` is:

```
config-private/
└── claude/
    ├── profiles/
    │   ├── <machinename>.env         # one per machine (required)
    │   └── <machinename>.extra.json  # extra permissions per machine (optional)
    └── knowledge/                    # living knowledge base (optional, see below)
        ├── README.md
        └── domain/
            └── glossary/
                └── index.md
```

#### Profile `.env` variables

Each `.env` file defines four variables. The filename (without `.env`) is the profile name:

| Variable | Description | Example |
|----------|-------------|---------|
| `MACHINE_USER` | Output of `whoami` on this machine — used to auto-detect the profile and expand paths in `settings.json` | `john.doe` |
| `DEV_DIR` | Directory under `~` where you clone repos | `Developer` or `projects` |
| `CONFIG_SUBPATH` | Path from `~` to the `config` repo root — used to grant Claude edit access to its own config | `Developer/config` or `projects/config` |
| `WORKTREES_DIR_REL` | Path from `~` where Claude agent worktrees are created | `Developer/claude-working-here` or `projects/claude-working-here` |

Use the example files in this repo as a starting point:

```bash
cp claude/profiles/example.env config-private/claude/profiles/mymachine.env
cp claude/profiles/example.extra.json config-private/claude/profiles/mymachine.extra.json
# then edit mymachine.env with your actual values
```

#### Extra permissions (optional)

Add a `<machinename>.extra.json` alongside the `.env` to grant additional tool permissions specific to that machine. The file must be a JSON array of permission strings — they are merged into the base `settings.json.template` permissions by `install.sh`. See `claude/profiles/example.extra.json` for the format.

Then run `./claude/install.sh` (auto-detects your profile) or `./claude/install.sh --profile mymachine` from your `config/` root.

#### Knowledge base (optional)

`~/.claude/knowledge/` is symlinked to `config-private/claude/knowledge/` by `install.sh`. This is where Claude persists domain knowledge, glossaries, and architectural notes across sessions.

Use the example files in this repo as a starting point:

```bash
cp -r claude/knowledge/ config-private/claude/knowledge/
# then edit knowledge/README.md to reflect your domains
```

See `claude/knowledge/README.md` for structure conventions and `claude/knowledge/domain/glossary/index.md` for the glossary format.

If `config-private/claude/knowledge/` doesn't exist, the symlink is not created and Claude operates without a persistent knowledge base.

### Step 3: Protect against accidental pushes to the original

After forking, verify your remotes point to the right place:

```bash
git remote -v
# origin should point to YOUR fork, not slmcassio/config
```

If `origin` still points to the original repo, fix it:

```bash
git remote set-url origin git@github.com:YOUR_USERNAME/config.git
```

Optionally, keep the original as `upstream` (read-only, for pulling updates):

```bash
git remote add upstream https://github.com/slmcassio/config.git
git remote set-url --push upstream no-push  # prevents accidental pushes
```

### Step 4: Clean up and personalize

1. **Reset `Claude Notes`** — the last section of `CLAUDE.md` contains session-specific notes from the original author. Clear it and let your Claude build its own.
2. **Delete project memories** — run `rm -rf ~/.claude/projects/` to remove stale per-project memory from previous sessions. Claude will rebuild these as needed.
3. **Review `hooks/`** — the auto-approve hook uses `$HOME/.claude/` dynamically. Should work as-is.
4. **Adapt `agents/`** — keep `sandboxed-worker.md` as a template and adjust the worktree paths to match your setup.
5. **Update references** — replace `slmcassio` with your GitHub username in `README.md` clone URLs.

| What to replace | Where | Replace with |
|-----------------|-------|--------------|
| `slmcassio` (GitHub user) | `claude/README.md`, root `README.md` | Your GitHub username |
| Character personas | `CLAUDE.md` (Persons section) | Keep, modify, or remove — optional fun |
| Aliases table | `CLAUDE.md` (Aliases section) | Replace with your own repo/service aliases |

After cleaning up, run `./claude/install.sh --profile mymachine`.

---

## Notes for you, Claude Code

Once installed, read `CLAUDE.md` carefully. It contains:

- **Asimov's Laws**: Fundamental rules that override everything else.
- **Workflow behaviors**: Auto-commit rules for this repo, knowledge base conventions, dotfiles sync strategy.
- **Development behaviors**: Linting, testing, and commit rules (GPG signing required — always ask before committing).
- **Character mode**: The user may greet you as a fictional character. Follow the persona instructions in the Characters section.
- **Knowledge base**: Persist domain and technical knowledge under `knowledge/` following `knowledge/README.md` conventions.

Welcome aboard.
