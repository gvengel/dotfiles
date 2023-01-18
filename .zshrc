# General shell settings 
HISTFILE=~/.histfile
HISTSIZE=100000 
SAVEHIST=100000
setopt appendhistory extendedglob
unsetopt autocd beep nomatch notify 
bindkey -e 
# Completion
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

# Custom prompt
setopt prompt_subst
PROMPT='%F{102}%15<..<%~%<<%f %F{$(($??124:31))}%#%f '

# Color lists
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='Bxgxfxfxcxdxdxhbadbxbx'

# Color aliases
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Directory aliases
setopt cdable_vars
export desktop="${HOME}/Desktop"
export downloads="${HOME}/Downloads"

# Put local tools in path (pipx, etc)
export PATH="${PATH}:${HOME}/.local/bin"

# Helpers
proxy() {
    local scheme
    local name
    for scheme in 'all' 'http' 'https' 'ftp'; do 
        if [ "$1" == 'off' ]; then
            name="${scheme}_proxy"
            export ${scheme}_proxy_off="${(P)${name}}"
            unset ${scheme}_proxy
        elif [ "$1" == 'on' ]; then
            name="${scheme}_proxy_off"
            export ${scheme}_proxy="${(P)${name}}"
            unset ${scheme}_proxy_off
        else
            export ${scheme}_proxy="${1:=http://proxy:3128}"
            unset ${scheme}_proxy_off
        fi
    done
}

enable_mosh() {
    local here=$(pwd)
    local fw='/usr/libexec/ApplicationFirewall/socketfilterfw'
    local mosh="$(which mosh-server)"
    local target=$(basename $mosh)

    cd $(dirname $mosh)
    # Iterate down a (possible) chain of symlinks
    while [ -L "$target" ]; do
        target=$(readlink $target)
        cd $(dirname $target)
        target=$(basename $target)
    done

    mosh=$(pwd -P)/$target

    sudo "$fw" --setglobalstate off
    sudo "$fw" --add "$mosh"
    sudo "$fw" --unblockapp "$mosh"
    sudo "$fw" --setglobalstate on

    cd "$here"
}

# iTerm magic
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# brew install zsh-autosuggestions romkatv/gitstatus/gitstatus
test -e $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
test -e $HOMEBREW_PREFIX/opt/gitstatus/gitstatus.prompt.zsh && source $HOMEBREW_PREFIX/opt/gitstatus/gitstatus.prompt.zsh

# Hide git for dotfiles
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

link_ssh_agent() {
    auth_link="$HOME/.ssh/ssh-auth-sock"
    if [ "$SSH_AUTH_SOCK" != "$auth_link" ]; then
        ln -sf "$SSH_AUTH_SOCK" "$auth_link"
        export SSH_AUTH_SOCK="$auth_link"
    fi
}

# Setup our SSH agent - See https://github.com/gvengel/ssh-askpass
connect_ssh_agent() {
    if ! ssh-add -l > /dev/null 2>&1; then
        echo "start new agent"
        killall -q ssh-agent
        eval `SSH_ASKPASS=/usr/local/bin/ssh-askpass DISPLAY=:0 ssh-agent -s -t 12h`
        link_ssh_agent
        ssh-add -c ~/.ssh/id_ed25519
    fi
}
#[ -f ~/.ssh/id_ed25519 ] && connect_ssh_agent

# Setup our GPG Agent
#   brew install gnupg
#   brew install pinentry-mac
# To prompt for a missing smartcard, with key inserted
#   gpg --with-keygrip --card-status | awk '/keygrip/ {print $3; exit}' >> $HOME/.gnupg/sshcontrol
connect_gpg_agent() {
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    link_ssh_agent
    gpgconf --launch gpg-agent
    gpg-connect-agent updatestartuptty /bye > /dev/null
}

test -e ~/.zshrc.local && source ~/.zshrc.local

attach() {
    if [ -z "$SSH_CONNECTION" ]; then
        connect_gpg_agent
    else
        if [ -z "$TMUX" ]; then                                                                               
            tmux attach -d
            exit
        fi
    fi
    link_ssh_agent
}
attach
