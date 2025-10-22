# ------------------------------------------------------------
# GPG CONFIGURATION
# ------------------------------------------------------------
# GPG agent setup for SSH authentication

set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null
