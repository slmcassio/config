#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# ---------------------------------------------------------------------------
# Private repo detection (sibling config-private/ next to config/)
# ---------------------------------------------------------------------------
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEV_DIR="$(dirname "$REPO_DIR")"
PRIVATE_CLAUDE_DIR="$DEV_DIR/config-private/claude"

if [[ -d "$PRIVATE_CLAUDE_DIR/profiles" ]]; then
  PROFILES_DIR="$PRIVATE_CLAUDE_DIR/profiles"
  echo "Private repo detected: using profiles from $PROFILES_DIR"
else
  PROFILES_DIR="$SCRIPT_DIR/profiles"
  echo "No private repo found: using local profiles from $PROFILES_DIR"
fi

KNOWLEDGE_DIR="$SCRIPT_DIR/knowledge"
if [[ -d "$PRIVATE_CLAUDE_DIR/knowledge" ]]; then
  KNOWLEDGE_DIR="$PRIVATE_CLAUDE_DIR/knowledge"
fi

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
PROFILE_ARG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      PROFILE_ARG="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--profile <name>]" >&2
      exit 1
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Dependency check
# ---------------------------------------------------------------------------
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed. Install with: brew install jq" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Profile detection
# ---------------------------------------------------------------------------
CURRENT_USER="$(whoami)"
PROFILE=""
MACHINE_USER=""
DEV_DIR=""
CONFIG_SUBPATH=""
WORKTREES_DIR_REL=""

if [[ -n "$PROFILE_ARG" ]]; then
  ENV_FILE="$PROFILES_DIR/$PROFILE_ARG.env"
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: profile '$PROFILE_ARG' not found (expected $ENV_FILE)" >&2
    exit 1
  fi
  source "$ENV_FILE"
  PROFILE="$PROFILE_ARG"
else
  # Auto-detect by matching MACHINE_USER to whoami
  for env_file in "$PROFILES_DIR"/*.env; do
    unset MACHINE_USER DEV_DIR CONFIG_SUBPATH WORKTREES_DIR_REL
    source "$env_file"
    if [[ "$MACHINE_USER" == "$CURRENT_USER" ]]; then
      PROFILE="$(basename "$env_file" .env)"
      break
    fi
  done

  if [[ -z "$PROFILE" ]]; then
    echo "Error: no profile matched for user '$CURRENT_USER'." >&2
    echo "Available profiles:" >&2
    for env_file in "$PROFILES_DIR"/*.env; do
      source "$env_file"
      echo "  $(basename "$env_file" .env)  (MACHINE_USER=$MACHINE_USER)" >&2
    done
    echo "Use --profile <name> to override." >&2
    exit 1
  fi
fi

echo "Using profile: $PROFILE (user=$MACHINE_USER, dev=$DEV_DIR)"

HOME_DIR="/Users/$MACHINE_USER"

# ---------------------------------------------------------------------------
# Render template
# ---------------------------------------------------------------------------
TMP_SETTINGS="$SCRIPT_DIR/settings.json.tmp"

sed \
  -e "s|{{MACHINE_USER}}|$MACHINE_USER|g" \
  -e "s|{{DEV_DIR}}|$DEV_DIR|g" \
  -e "s|{{CONFIG_SUBPATH}}|$CONFIG_SUBPATH|g" \
  -e "s|{{WORKTREES_DIR_REL}}|$WORKTREES_DIR_REL|g" \
  "$TEMPLATES_DIR/settings.json.template" > "$TMP_SETTINGS"

# Verify no placeholders remain
if grep -q '{{' "$TMP_SETTINGS"; then
  echo "Error: unsubstituted placeholders remain in rendered template:" >&2
  grep '{{' "$TMP_SETTINGS" >&2
  rm -f "$TMP_SETTINGS"
  exit 1
fi

# ---------------------------------------------------------------------------
# Merge extra permissions
# ---------------------------------------------------------------------------
EXTRA_FILE="$PROFILES_DIR/$PROFILE.extra.json"
RENDERED_SETTINGS="$SCRIPT_DIR/settings.json"

if [[ -f "$EXTRA_FILE" ]]; then
  jq --argjson extra "$(cat "$EXTRA_FILE")" \
    '.permissions.allow += $extra' "$TMP_SETTINGS" > "$RENDERED_SETTINGS"
  echo "Merged extra permissions from $PROFILE.extra.json"
else
  cp "$TMP_SETTINGS" "$RENDERED_SETTINGS"
fi

rm -f "$TMP_SETTINGS"

# ---------------------------------------------------------------------------
# Backup existing ~/.claude config
# ---------------------------------------------------------------------------
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME_DIR/.claude/pre-dotfiles-backup-$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

backed_up=0
for f in CLAUDE.md settings.json settings.local.json; do
  if [[ -e "$HOME_DIR/.claude/$f" ]]; then
    cp -L "$HOME_DIR/.claude/$f" "$BACKUP_DIR/$f"
    echo "Backed up: $f"
    backed_up=1
  fi
done

if [[ -d "$HOME_DIR/.claude/hooks" ]]; then
  cp -r "$HOME_DIR/.claude/hooks" "$BACKUP_DIR/hooks"
  echo "Backed up: hooks/"
  backed_up=1
fi

if [[ $backed_up -eq 1 ]]; then
  echo "Backup created: $BACKUP_DIR"
else
  echo "Nothing to back up (fresh install)"
  rmdir "$BACKUP_DIR"
fi

# ---------------------------------------------------------------------------
# Deploy
# ---------------------------------------------------------------------------
CLAUDE_DIR="$HOME_DIR/.claude"
mkdir -p "$CLAUDE_DIR/hooks"

# CLAUDE.md — symlink
rm -f "$CLAUDE_DIR/CLAUDE.md"
ln -s "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "Symlinked: ~/.claude/CLAUDE.md -> $SCRIPT_DIR/CLAUDE.md"

# settings.json — copy (symlinks break Claude Code #3575)
cp "$RENDERED_SETTINGS" "$CLAUDE_DIR/settings.json"
echo "Copied: settings.json -> ~/.claude/settings.json"

# hooks/ — copy + chmod (must be real files)
for hook in "$SCRIPT_DIR/hooks/"*; do
  [[ -f "$hook" ]] || continue
  cp "$hook" "$CLAUDE_DIR/hooks/"
  chmod +x "$CLAUDE_DIR/hooks/$(basename "$hook")"
done
echo "Copied: hooks/ -> ~/.claude/hooks/"

# agents/ — symlink
rm -rf "$CLAUDE_DIR/agents"
ln -s "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents"
echo "Symlinked: ~/.claude/agents/ -> $SCRIPT_DIR/agents/"

# knowledge/ — symlink (to private repo if available, else local)
rm -rf "$CLAUDE_DIR/knowledge"
ln -s "$KNOWLEDGE_DIR" "$CLAUDE_DIR/knowledge"
echo "Symlinked: ~/.claude/knowledge/ -> $KNOWLEDGE_DIR"

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------
echo ""
echo "=== Verification ==="
echo ""

echo "CLAUDE.md symlink target:"
readlink "$CLAUDE_DIR/CLAUDE.md"

echo ""
echo "settings.json type:"
file "$CLAUDE_DIR/settings.json"

echo ""
echo "hooks/:"
ls -la "$CLAUDE_DIR/hooks/"

echo ""
echo "Checking for unsubstituted placeholders in settings.json:"
if grep -q '{{' "$CLAUDE_DIR/settings.json"; then
  echo "WARNING: placeholders found!" >&2
  grep '{{' "$CLAUDE_DIR/settings.json" >&2
else
  echo "OK — no placeholders remaining"
fi

echo ""
echo "knowledge/ symlink target:"
readlink "$CLAUDE_DIR/knowledge"

echo ""
echo "Done. Profile '$PROFILE' installed for $MACHINE_USER."
