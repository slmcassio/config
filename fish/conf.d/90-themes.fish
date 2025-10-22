# ------------------------------------------------------------
# UNIFIED THEME CONFIGURATION
# ------------------------------------------------------------
# Detects macOS system appearance once and applies themes to all tools
# Loaded late (90-) to ensure tool configs are loaded first

# Source theme switcher functions
source ~/.config/eza/theme-switcher.fish
source ~/.config/fzf/theme-switcher.fish

# Apply all themes
set_eza_theme
set_fzf_theme
