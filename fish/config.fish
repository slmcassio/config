# ------------------------------------------------------------
# MORNING CONFIGURATION
# ------------------------------------------------------------
function morning
    brew update
    brew upgrade
    gh extension upgrade gh-copilot
end
# ------------------------------------------------------------
# PATH
# ------------------------------------------------------------
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/sbin $PATH
set -x PATH /usr/local/opt/curl/bin $PATH
fish_add_path $HOME/.local/bin
# ------------------------------------------------------------
# PATH: HOMEBREW
# ------------------------------------------------------------
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
# ------------------------------------------------------------
# HISTORY HANDLING
# ------------------------------------------------------------
set -x HISTSIZE 10000
set -x fish_history_erasedups true
# ------------------------------------------------------------
# CLOJURE REPL SHORTCUTS
# ------------------------------------------------------------
alias clojure-repl-basic 'clojure -M:repl/basic'
alias clojure-repl-headless 'clojure -M:repl/headless'
alias clojure-test 'clojure -M:test'
# ------------------------------------------------------------
# SYSTEM SHORTCUTS
# ------------------------------------------------------------
alias flushdns 'sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
alias sha1 '/usr/bin/openssl sha1'
alias md5 'md5 -r'
alias md5sum 'md5 -r'
alias running_services 'sudo lsof -nPi -sTCP:LISTEN'
alias whatismyipaddress 'dig +short myip.opendns.com @resolver1.opendns.com'
alias localip 'ipconfig getifaddr en0'
# ------------------------------------------------------------
# UTILS
# ------------------------------------------------------------
alias uuid 'python3 -c "import sys,uuid; sys.stdout.write(str(uuid.uuid4()))" | pbcopy && pbpaste && echo'
# ------------------------------------------------------------
# MEMORY USAGE
# ------------------------------------------------------------
alias psmem 'ps aux | sort -nr -k 4'
alias psmem10 'ps aux | sort -nr -k 4 | head -10'
# ------------------------------------------------------------
# CPU USAGE
alias pscpu 'ps aux | sort -nr -k 3'
alias pscpu10 'ps aux | sort -nr -k 3 | head -10'
# ------------------------------------------------------------
# EZA
# ------------------------------------------------------------
set -x EZA_CONFIG_DIR $HOME/.config/eza
source ~/.config/eza/theme-switcher.fish
# ------------------------------------------------------------
# FZF
# ------------------------------------------------------------
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -gx FZF_CTRL_R_OPTS "--no-preview"
source ~/.config/fzf/theme-switcher.fish
# ------------------------------------------------------------
# GPG
# ------------------------------------------------------------
set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null
# ------------------------------------------------------------
# STARSHIP
# ------------------------------------------------------------
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
# ------------------------------------------------------------
# ALIASES AND FUNCTIONS
# ------------------------------------------------------------
function e --description 'List files using eza with icons, git status, and hyperlinks'
    # -la: long format with hidden files
    # --icons: show file type icons
    # --header: show column headers
    # --hyperlink: make filenames clickable
    # --git: show git status
    # --git-ignore: respect .gitignore
    # --git-repos-no-status: don't recurse into git repos
    # --ignore-glob=.git: hide .git directory
    eza -la --icons --header --hyperlink --git-repos-no-status --git --git-ignore --ignore-glob=.git $argv
end
function mkdir --description 'Make directories with parents'
    command mkdir -p $argv
end
# ------------------------------------------------------------
# WHEN INTERACTIVE
# ------------------------------------------------------------
if status is-interactive
    # --------------------------------------------------------
    # ABBREVIATIONS
    # --------------------------------------------------------
    abbr -a g git
    abbr -a gs git status
    abbr -a ga git add
    abbr -a gaa git add .
    abbr -a gc git commit
    abbr -a gps git push
    abbr -a gpl git pull
    abbr -a gd git diff
    abbr -a gdh git diff HEAD
    abbr -a gch git checkout
    abbr -a gb git branch
    abbr -a grb git rebase
    abbr -a grs git reset
    abbr -a grt git restore
    abbr -a glog git log --oneline --graph --decorate
    abbr -a c clear
    abbr -a f fzf
    abbr -a fi open -a Finder ./
    abbr -a p echo $PATH
    # --------------------------------------------------------
    # INIT
    # --------------------------------------------------------
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
end
