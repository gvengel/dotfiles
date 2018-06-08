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
RPROMPT='HI JIM! $?'

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

# iTerm magic
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# brew install zsh-autosuggestions
share='/usr/local/share'
test -e $share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Setup our SSH agent
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

