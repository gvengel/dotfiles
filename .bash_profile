# Various settings
export HOSTNAME
export EDITOR=vim
export P4CONFIG=p4config
export PATH="/usr/local/sbin:$PATH"

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
ulimit -n 8096

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

# Manage dotfiles with git
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Bash login
if [ -f ~/.bash_login ]; then
    . ~/.bash_login
fi

# Bash completion
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
fi

# iTerm magic
if [ "$TERM_PROGRAM" == "iTerm.app" ]; then 
    test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
fi

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

# Setup GPG agent
#export GPG_TTY=$(tty)
#gpg-agent 2> /dev/null || gpg-agent --daemon > ~/.gnupg/gpg-agent.info
#. ~/.gnupg/gpg-agent.info
#gpg-connect-agent updatestartuptty /bye > /dev/null

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize
# Trim to 2 directories in prompt
PROMPT_DIRTRIM=2
# Do history expansion with a trailing space
bind Space:magic-space
# Turn on glob glob
shopt -s globstar

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"
# Colorize preview
bind "set colored-completion-prefix on"
bind "set colored-stats on"

# Setup menu completion 
bind "TAB: menu-complete"
bind '"\e[Z": menu-complete-backward'

# Append to history
shopt -s histappend
# Save multiline as one command
shopt -s cmdhist
# Record each line as it gets issued
PROMPT_COMMAND='history -a'
# Moar history
HISTSIZE=100000
HISTFILESIZE=100000
# Ignore dups and spaces
HISTCONTROL="ignoreboth"
# Use ISO 8601 timestamp
HISTTIMEFORMAT='%F %T '

# Navigate history with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# cd shortcuts
shopt -s cdable_vars
export desktop="$HOME/Desktop"
export downloads="$HOME/Downloads"
export main="$HOME/dev/itg/main"
export puppet="$main/puppet"

. ~/.bash_powerline
