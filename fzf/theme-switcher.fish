# FZF automatic theme switcher for macOS
# Detects system appearance and loads appropriate Catppuccin theme

function set_fzf_theme
    # Detect macOS appearance mode
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    if test "$appearance" = "Dark"
        # Catppuccin Mocha (dark theme)
        set -gx FZF_DEFAULT_OPTS "
            --preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat --color=always -n --line-range :500 {}; fi'
            --height 75%
            --layout=reverse
            --border
            --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
            --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
            --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
            --color=selected-bg:#45475A \
            --color=border:#6C7086,label:#CDD6F4"

        set -gx _ZO_FZF_OPTS "
            --preview 'eza --tree --color=always {2..} | head -200'
            --height 75%
            --layout=reverse
            --border
            --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
            --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
            --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
            --color=selected-bg:#45475A \
            --color=border:#6C7086,label:#CDD6F4"
    else
        # Catppuccin Latte (light theme)
        set -gx FZF_DEFAULT_OPTS "
            --preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat --color=always -n --line-range :500 {}; fi'
            --height 75%
            --layout=reverse
            --border
            --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
            --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
            --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
            --color=selected-bg:#BCC0CC \
            --color=border:#9CA0B0,label:#4C4F69"

        set -gx _ZO_FZF_OPTS "
            --preview 'eza --tree --color=always {2..} | head -200'
            --height 75%
            --layout=reverse
            --border
            --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
            --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
            --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
            --color=selected-bg:#BCC0CC \
            --color=border:#9CA0B0,label:#4C4F69"
    end
end

# Load theme on shell startup
set_fzf_theme
