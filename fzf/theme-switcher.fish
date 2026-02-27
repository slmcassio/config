# FZF automatic theme switcher for macOS
# Detects system appearance and loads appropriate Catppuccin theme

function set_fzf_theme
    # Detect macOS appearance mode
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    # Get the config directory
    set -l config_dir (dirname (status --current-filename))

    if test "$appearance" = "Dark"
        source "$config_dir/catppuccin-mocha.fish"
    else
        source "$config_dir/catppuccin-latte.fish"
    end
end
