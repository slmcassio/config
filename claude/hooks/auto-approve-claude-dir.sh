#!/bin/bash
# PreToolUse hook: auto-approve Write/Edit and Bash(rm) operations inside ~/.claude/
# Reason: .claude/ is hardcoded as "sensitive" in Claude Code's binary,
# causing Write/Edit/rm to always prompt regardless of settings.json.
# This hook runs BEFORE the permission pipeline and bypasses that check.
#
# Exception: settings.json and settings.local.json are NOT auto-approved
# because modifying permission config should always be explicit.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

approve() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

case "$TOOL_NAME" in
  Edit|Write)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

    # Only act on files inside ~/.claude/
    if [[ "$FILE_PATH" == "$HOME/.claude/"* ]]; then
      BASENAME=$(basename "$FILE_PATH")

      # Never auto-approve settings files
      if [[ "$BASENAME" == "settings.json" || "$BASENAME" == "settings.local.json" ]]; then
        exit 0
      fi

      approve "Auto-approved: write to ~/.claude/ (hook)"
    fi
    ;;

  Bash)
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

    # Never auto-approve if settings files are mentioned
    if [[ "$COMMAND" == *"settings.json"* || "$COMMAND" == *"settings.local.json"* ]]; then
      exit 0
    fi

    # Strip trailing && chain (commonly used for status messages like && echo "done")
    CMD_CORE="${COMMAND%%&&*}"
    CMD_CORE=$(echo "$CMD_CORE" | xargs)

    # Must be an rm command
    if [[ ! "$CMD_CORE" =~ ^rm($|[[:space:]]) ]]; then
      exit 0
    fi

    # Extract path arguments (skip "rm" and any flags starting with -)
    PATHS=()
    SKIP_FIRST=true
    for arg in $CMD_CORE; do
      if $SKIP_FIRST; then
        SKIP_FIRST=false
        continue
      fi
      [[ "$arg" == -* ]] && continue
      PATHS+=("$arg")
    done

    # Must have at least one path
    if [[ ${#PATHS[@]} -eq 0 ]]; then
      exit 0
    fi

    # ALL paths must be inside ~/.claude/
    for path in "${PATHS[@]}"; do
      if [[ "$path" != "$HOME/.claude/"* && "$path" != "~/.claude/"* ]]; then
        exit 0
      fi
    done

    approve "Auto-approved: rm inside ~/.claude/ (hook)"
    ;;
esac

exit 0
