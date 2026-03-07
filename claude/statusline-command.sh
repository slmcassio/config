#!/usr/bin/env bash
# Claude Code status line — styled after Catppuccin Mocha Starship prompt

input=$(cat)

# --- Data from Claude Code JSON ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# --- Catppuccin Mocha palette (ANSI 24-bit) ---
# Colors are rendered with `printf` so escape sequences are interpreted.
# The terminal dims status-line output, so we use the full palette and let
# the terminal handle the dimming.
RED="\033[38;2;243;139;168m"       # #f38ba8
PEACH="\033[38;2;250;179;135m"     # #fab387
YELLOW="\033[38;2;249;226;175m"    # #f9e2af
GREEN="\033[38;2;166;227;161m"     # #a6e3a1
SAPPHIRE="\033[38;2;116;199;236m"  # #74c7ec
LAVENDER="\033[38;2;180;190;254m"  # #b4befe
MAUVE="\033[38;2;203;166;247m"     # #cba6f7
OVERLAY1="\033[38;2;127;132;156m"  # #7f849c  (dim separators)
RESET="\033[0m"
BOLD="\033[1m"

# --- Directory: truncate to 3 path components, substitute known dirs ---
truncate_dir() {
  local path="$1"
  local home="$HOME"
  # Replace $HOME prefix with ~
  path="${path/#$home/~}"
  # Apply substitutions matching your starship config
  path="${path/\/Developer\///󰲋 /}"
  path="${path/\/dev\///󰲋 /}"
  path="${path/\/projects\///󰲋 /}"
  path="${path/\/Documents\///󰈙 /}"
  path="${path/\/Downloads\/// /}"
  path="${path/\/Music\///󰝚 /}"
  path="${path/\/Pictures\/// /}"
  # Truncate to last 3 components
  local IFS='/'
  read -ra parts <<< "$path"
  local count=${#parts[@]}
  if [ "$count" -gt 3 ]; then
    printf "…/%s/%s/%s" "${parts[$count-3]}" "${parts[$count-2]}" "${parts[$count-1]}"
  else
    echo "$path"
  fi
}

dir_label=$(truncate_dir "$cwd")

# --- Git branch and status ---
git_info=""
if git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null); then
  git_status_flags=""
  git_status_porcelain=$(git -C "$cwd" status --porcelain 2>/dev/null)
  if [ -n "$git_status_porcelain" ]; then
    # Check for modifications, untracked, staged, etc.
    modified=$(echo "$git_status_porcelain" | grep -c '^ M\|^M ' 2>/dev/null || true)
    untracked=$(echo "$git_status_porcelain" | grep -c '^??' 2>/dev/null || true)
    staged=$(echo "$git_status_porcelain" | grep -c '^[MADRC] ' 2>/dev/null || true)
    [ "$modified" -gt 0 ] 2>/dev/null && git_status_flags="${git_status_flags}!"
    [ "$staged" -gt 0 ] 2>/dev/null && git_status_flags="${git_status_flags}+"
    [ "$untracked" -gt 0 ] 2>/dev/null && git_status_flags="${git_status_flags}?"
  fi
  # Ahead/behind
  ahead_behind=$(git -C "$cwd" rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null || true)
  if [ -n "$ahead_behind" ]; then
    behind=$(echo "$ahead_behind" | awk '{print $1}')
    ahead=$(echo "$ahead_behind" | awk '{print $2}')
    [ "$ahead" -gt 0 ] 2>/dev/null && git_status_flags="${git_status_flags}⇡${ahead}"
    [ "$behind" -gt 0 ] 2>/dev/null && git_status_flags="${git_status_flags}⇣${behind}"
  fi
  [ -n "$git_status_flags" ] && git_status_flags=" ${git_status_flags}"
  git_info=" ${git_branch}${git_status_flags}"
fi

# --- Time ---
time_label=$(date +%R)

# --- Context window ---
ctx_label=""
if [ -n "$used_pct" ]; then
  ctx_int=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "")
  if [ -n "$ctx_int" ]; then
    if [ "$ctx_int" -ge 80 ]; then
      ctx_color="$RED"
    elif [ "$ctx_int" -ge 50 ]; then
      ctx_color="$PEACH"
    else
      ctx_color="$GREEN"
    fi
    ctx_label=" ${ctx_int}%"
  fi
fi

# --- Model ---
model_label=""
[ -n "$model" ] && model_label=" ${model}"

# --- Vim mode ---
vim_label=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL)  vim_label=" [N]" ;;
    INSERT)  vim_label=" [I]" ;;
    *)       vim_label=" [${vim_mode}]" ;;
  esac
fi

# --- Compose the line ---
# Layout:  󰲋 dir  branch status    time   model  ctx%
printf "${PEACH}${BOLD} ${dir_label}${RESET}"
if [ -n "$git_info" ]; then
  printf "${OVERLAY1} ${RESET}${YELLOW}${git_info}${RESET}"
fi
printf "${OVERLAY1} ${RESET}${LAVENDER}  ${time_label}${RESET}"
if [ -n "$model_label" ]; then
  printf "${OVERLAY1} ${RESET}${SAPPHIRE}${model_label}${RESET}"
fi
if [ -n "$ctx_label" ]; then
  printf "${OVERLAY1} ${RESET}${ctx_color:-$MAUVE}${ctx_label}${RESET}"
fi
if [ -n "$vim_label" ]; then
  printf "${OVERLAY1} ${RESET}${MAUVE}${vim_label}${RESET}"
fi
printf "\n"
