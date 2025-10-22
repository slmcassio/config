# ------------------------------------------------------------
# ZOXIDE CONFIGURATION
# ------------------------------------------------------------
# Smart directory jumping with fzf integration

# Zoxide FZF options (for directory jumping)
set -gx _ZO_FZF_OPTS "\
    --preview 'eza --tree --color=always {2..} | head -200' \
    --height 75% \
    --layout=reverse \
    --border"
