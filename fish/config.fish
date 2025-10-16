# ------------------------------------------------------------
# MORNING CONFIGURATION
# ------------------------------------------------------------
function morning
    brew update
    brew upgrade
    gh extension upgrade gh-copilot
end
# ------------------------------------------------------------
# BASIC CONFIGURATION
# ------------------------------------------------------------
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/sbin $PATH
set -x PATH /usr/local/opt/curl/bin $PATH
fish_add_path $HOME/.local/bin
# ------------------------------------------------------------
# ALIASES AND FUNCTIONS
# ------------------------------------------------------------
function e --description 'List files using eza'
    eza -la --icons --header --hyperlink --git-repos-no-status --git --git-ignore --ignore-glob=.git $argv
end
function cp --description 'Copy files verbosely'
    command cp -v $argv
end
function mv --description 'Move files verbosely'
    command mv -v $argv
end
function mkdir --description 'Make directories with parents'
    command mkdir -pv $argv
end
alias f 'open -a Finder ./'             # Opens current directory in MacOS Finder
alias c 'clear'                         # Clear terminal display
alias path 'echo $PATH | tr ":" "\n"'   # Echo all executable Paths
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
# HISTORY HANDLING
# ------------------------------------------------------------
set -x fish_history erasedups
set -x fish_history 10000
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
# HOMEBREW
# ------------------------------------------------------------
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
# ------------------------------------------------------------
# EZA
# ------------------------------------------------------------
set -x EZA_CONFIG_DIR $HOME/.config/eza
# ------------------------------------------------------------
# GIT
# ------------------------------------------------------------
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
# ------------------------------------------------------------
# GPG
# ------------------------------------------------------------
set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null
# ------------------------------------------------------------
# FZF
# ------------------------------------------------------------
# Uses 'fd' (fast find alternative) + preview
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
# Default options with your color scheme
set -gx FZF_DEFAULT_OPTS "
  --preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat --color=always -n --line-range :500 {}; fi'
  --height 75%
  --layout=reverse
  --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# Override preview for Ctrl+R history search (disable preview for command history)
set -gx FZF_CTRL_R_OPTS "--no-preview"
# ------------------------------------------------------------
# ZOXIDE
# ------------------------------------------------------------
set -gx _ZO_FZF_OPTS "
  --preview 'eza --tree --color=always {2..} | head -200'
  --height 75%
  --layout=reverse
  --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# ------------------------------------------------------------
# ABBREVIATIONS
# ------------------------------------------------------------
if status is-interactive
    # GIT
    abbr -a g git
    abbr -a gs git status
    abbr -a ga git add
    abbr -a gc git commit
    abbr -a gp git push
    abbr -a gl git pull
    abbr -a gd git diff
    abbr -a gco git checkout
    abbr -a gb git branch
    abbr -a grb git rebase
    abbr -a grs git reset
    abbr -a grt git restore
    abbr -a glog git log --oneline --graph --decorate
    # FZF
    abbr -a ff fzf
end
# ------------------------------------------------------------
# STARSHIP & ZOXIDE
# ------------------------------------------------------------
if status is-interactive
  starship init fish | source
  zoxide init fish | source
  fzf --fish | source
end
