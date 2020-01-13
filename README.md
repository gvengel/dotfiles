Setup on a new system
=====================

```zsh
git clone --bare https://github.com/gvengel/dotfiles.git $HOME/.dotfiles.git
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
git-dotfile checkout
```
