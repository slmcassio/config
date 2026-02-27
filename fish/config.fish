# ------------------------------------------------------------
# FISH SHELL INTERACTIVE CONFIGURATION
# ------------------------------------------------------------
# This file is for interactive shell setup only
# All other configs are automatically loaded from conf.d/

if status is-interactive
    # --------------------------------------------------------
    # Fish
    # --------------------------------------------------------
    fish_config theme choose tomorrow-night-bright
    fish_vi_key_bindings

    # --------------------------------------------------------
    # GIT ABBREVIATIONS
    # --------------------------------------------------------
    abbr -a g git
    abbr -a gs git status
    abbr -a ga git add
    abbr -a gaa git add .
    abbr -a gc git commit
    abbr -a gca git commit --amend
    abbr -a gps git push
    abbr -a gpl git pull
    abbr -a gd git diff
    abbr -a gdh git diff HEAD
    abbr -a gco git checkout
    abbr -a gb git branch
    abbr -a grb git rebase
    abbr -a grs git reset
    abbr -a grt git restore
    abbr -a gst git stash
    abbr -a glog git log --oneline --graph --decorate

    # --------------------------------------------------------
    # GENERAL ABBREVIATIONS
    # --------------------------------------------------------
    abbr -a c clear
    abbr -a e 'eza -la --icons --header --hyperlink --git-repos-no-status --git --git-ignore --ignore-glob=.git'
    abbr -a p echo $PATH

    # System utilities
    abbr -a flushdns 'sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
    abbr -a running_services 'sudo lsof -nPi -sTCP:LISTEN'
    abbr -a whatismyipaddress 'dig +short myip.opendns.com @resolver1.opendns.com'
    abbr -a localip 'ipconfig getifaddr en0'
    abbr -a sha1 '/usr/bin/openssl sha1'
    abbr -a md5sum 'md5 -r'

    # Performance monitoring
    abbr -a psmem 'ps aux | sort -nr -k 4'
    abbr -a psmem10 'ps aux | sort -nr -k 4 | head -10'
    abbr -a pscpu 'ps aux | sort -nr -k 3'
    abbr -a pscpu10 'ps aux | sort -nr -k 3 | head -10'

    # --------------------------------------------------------
    # FZF ABBREVIATIONS
    # --------------------------------------------------------
    abbr -a f fzf
    abbr -a fe '$EDITOR (fzf)'
    abbr -a ff 'open -a Finder (fd --type d | fzf)'
    abbr -a fz 'z (fd --type d | fzf)'
    abbr -a fkill 'kill (ps aux | fzf --no-preview | awk \'{print $2}\')'

    # --------------------------------------------------------
    # CLOJURE ABBREVIATIONS
    # --------------------------------------------------------
    abbr -a crk env KAOCHA_CONFIG_FILE=tests.edn clojure -M

    # --------------------------------------------------------
    # TOOL INITIALIZATION
    # --------------------------------------------------------
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
end
