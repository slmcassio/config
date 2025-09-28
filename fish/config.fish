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
alias ls 'ls -la'
alias cp 'cp -iv'                           # Preferred 'cp' implementation
alias mv 'mv -iv'                           # Preferred 'mv' implementation
alias mkdir 'mkdir -pv'                     # Preferred 'mkdir' implementation

alias dev 'cd ~/dev'
alias Dev 'cd ~/Developer'

alias f 'open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias c 'clear'                             # c:            Clear terminal display
alias path 'echo $PATH | tr ":" "\n"'       # path:         Echo all executable Paths
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
# STARSHIP & ZOXIDE
# ------------------------------------------------------------
if status is-interactive
  zoxide init fish | source
  starship init fish | source
end
