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
export main="${HOME}/dev/itg/main"
export puppet="${main}/puppet"
export salt="${main}/salt"

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

# brew install zsh-autosuggestions
share='/usr/local'
test -e $share/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $share/share/zsh-autosuggestions/zsh-autosuggestions.zsh
test -e $share/opt/gitstatus/gitstatus.prompt.zsh && source $share/opt/gitstatus/gitstatus.prompt.zsh

# Hide git for dotfiles
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Setup our SSH agent - See https://github.com/gvengel/ssh-askpass
connect_ssh_agent() {
    auth_link="$HOME/.ssh/ssh-auth-sock"
    export SSH_AUTH_SOCK="$auth_link"
    if ! ssh-add -l > /dev/null 2>&1; then
        echo "start new agent"
        killall -q ssh-agent
        eval `SSH_ASKPASS=/usr/local/bin/ssh-askpass DISPLAY=:0 ssh-agent -s -t 12h`
        ln -sf "$SSH_AUTH_SOCK" "$auth_link"
        export SSH_AUTH_SOCK="$auth_link"
        ssh-add -c ~/.ssh/id_ed25519
    fi
}
[ -f ~/.ssh/id_ed25519 ] && connect_ssh_agent

# Setup our GPG Agent
connect_gpg_agent() {
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
    gpg-connect-agent updatestartuptty /bye > /dev/null
}

# Auto reconnect tmux over SSH
if [ "$SSH_CONNECTION" -a -z "$TMUX" ]; then
    tmux attach -d
fi

test -e ~/.zshrc.local && source ~/.zshrc.local

