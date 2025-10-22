# ------------------------------------------------------------
# FZF CONFIGURATION
# ------------------------------------------------------------
# Fuzzy finder base configuration

# Base search command
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"

# Ctrl+R history search options
set -gx FZF_CTRL_R_OPTS "--no-preview"

# Base FZF options (behavior and layout)
set -gx FZF_DEFAULT_OPTS "\
    --preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat --color=always -n --line-range :500 {}; fi' \
    --height 75% \
    --layout=reverse \
    --border"
