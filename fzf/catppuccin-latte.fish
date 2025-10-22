# Catppuccin Latte (Light) color scheme for FZF
# This file only contains color definitions

set -l latte_colors "\
--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
--color=selected-bg:#BCC0CC \
--color=border:#9CA0B0,label:#4C4F69"

# Append colors to existing FZF options
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS $latte_colors"
set -gx _ZO_FZF_OPTS "$_ZO_FZF_OPTS $latte_colors"
