# Eza automatic theme switcher for macOS
# Detects system appearance and loads appropriate Catppuccin theme

function set_eza_theme
    # Detect macOS appearance mode
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    # Get the config directory
    set -l config_dir (dirname (status --current-filename))

    if test "$appearance" = "Dark"
        # Copy Catppuccin Mocha (dark theme)
        cp "$config_dir/eza-catppuccin-mocha-pink.yml" "$config_dir/theme.yml"
    else
        # Copy Catppuccin Latte (light theme)
        cp "$config_dir/eza-catppuccin-latte-pink.yml" "$config_dir/theme.yml"
    end
end

# Load theme on shell startup
set_eza_theme
