export PATH="${PATH}:/usr/local/sbin:/usr/local/bin"
export EDITOR='vim'
export P4CONFIG='p4config'
# For local overrides (proxy settings, etc)
test -e "${HOME}/.zshenv.local" && source "${HOME}/.zshenv.local"
