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

# Helpers
proxy() {
    local scheme
    local name
    for scheme in 'http' 'https' 'ftp'; do 
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

# iTerm magic
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# brew install zsh-autosuggestions
share='/usr/local/share'
test -e $share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Hide git for dotfiles
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Setup our SSH agent - See https://github.com/gvengel/ssh-askpass
connect_ssh_agent() {
    export SSH_AUTH_SOCK=$(ls /private/tmp/com.apple.launchd.*/Listeners)
    ssh-add -l > /dev/null 2>&1
    if [ "$?" != "0" ]; then
        launchctl setenv SSH_ASKPASS /usr/local/bin/ssh-askpass DISPLAY :0 && launchctl stop com.openssh.ssh-agent
        ssh-add -c -t 12h
    fi
}
if [ -f ~/.ssh/id_rsa -o -f ~/.ssh/id_ed25519 ]; then
    connect_ssh_agent
fi

# Auto reconnect tmux over SSH
if [ "$SSH_CONNECTION" -a -z "$TMUX" ]; then
    tmux attach -d
fi

