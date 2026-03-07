#!/bin/bash
# PostToolUse hook: logs milestone events per project to session-events/<project>.jsonl
#
# Captured events:
#   - git commit  → hash, message, repo
#   - git push    → branch, remote, repo
#   - lein test   → pass/fail, counts
#   - gh pr create → PR URL
#   - lein compile → pass/fail
#
# Log location: ~/.claude/session-events/<project-slug>.jsonl
# Project slug: derived from git remote origin or CWD basename

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only process Bash tool calls
[[ "$TOOL_NAME" != "Bash" ]] && exit 0

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
OUTPUT=$(echo "$INPUT" | jq -r '.tool_output // empty')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_output_metadata.exit_code // "0"')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Derive project slug from git remote or CWD
project_slug() {
  local dir="${CWD:-$PWD}"
  # Try git remote
  local remote
  remote=$(git -C "$dir" remote get-url origin 2>/dev/null)
  if [[ -n "$remote" ]]; then
    # Extract org/repo from git@github.com:org/repo.git or https://...org/repo.git
    echo "$remote" | sed -E 's|.*[:/]([^/]+/[^/]+?)(\.git)?$|\1|' | tr '/' '_'
    return
  fi
  # Fallback: basename of CWD
  basename "$dir"
}

SLUG=$(project_slug)
[[ -z "$SLUG" ]] && exit 0

LOG_DIR="$HOME/.claude/session-events"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$SLUG.jsonl"

TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

log_event() {
  local event_type="$1"
  local details="$2"
  printf '{"ts":"%s","event":"%s","project":"%s",%s}\n' \
    "$TS" "$event_type" "$SLUG" "$details" >> "$LOG_FILE"
}

# Detect milestone events from command + output
case "$COMMAND" in
  *"git commit"*|*"git -C"*"commit"*)
    if [[ "$EXIT_CODE" == "0" ]]; then
      HASH=$(echo "$OUTPUT" | grep -oE '[0-9a-f]{7,}' | head -1)
      MSG=$(echo "$OUTPUT" | head -1 | sed 's/"/\\"/g')
      log_event "commit" "\"hash\":\"$HASH\",\"message\":\"$MSG\""
    fi
    ;;

  *"git push"*|*"git -C"*"push"*)
    if [[ "$EXIT_CODE" == "0" ]]; then
      BRANCH=$(echo "$OUTPUT" | grep -oE '[^ ]+\s*->\s*[^ ]+' | head -1 | sed 's/"/\\"/g')
      log_event "push" "\"ref\":\"$BRANCH\""
    fi
    ;;

  *"lein test"*|*"lein with-profile"*"test"*)
    if echo "$OUTPUT" | grep -q "0 failures, 0 errors"; then
      COUNTS=$(echo "$OUTPUT" | grep -oE 'Ran [0-9]+ tests containing [0-9]+ assertions' | head -1)
      log_event "test-pass" "\"summary\":\"$COUNTS\""
    elif echo "$OUTPUT" | grep -qE '[1-9][0-9]* (failures|errors)'; then
      FAIL_LINE=$(echo "$OUTPUT" | grep -E '[0-9]+ failures, [0-9]+ errors' | head -1 | sed 's/"/\\"/g')
      log_event "test-fail" "\"summary\":\"$FAIL_LINE\""
    fi
    ;;

  *"lein compile"*)
    if [[ "$EXIT_CODE" == "0" ]]; then
      log_event "compile-pass" "\"tool\":\"lein\""
    else
      ERR=$(echo "$OUTPUT" | head -3 | tr '\n' ' ' | sed 's/"/\\"/g')
      log_event "compile-fail" "\"error\":\"$ERR\""
    fi
    ;;

  *"gh pr create"*)
    if [[ "$EXIT_CODE" == "0" ]]; then
      PR_URL=$(echo "$OUTPUT" | grep -oE 'https://github.com/[^ ]+' | head -1)
      log_event "pr-created" "\"url\":\"$PR_URL\""
    fi
    ;;

  *"gh repo rename"*|*"gh repo create"*)
    if [[ "$EXIT_CODE" == "0" ]]; then
      log_event "repo-action" "\"command\":\"$(echo "$COMMAND" | sed 's/"/\\"/g')\""
    fi
    ;;
esac

exit 0
