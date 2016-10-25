# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
DEFAULT_USER="russley"
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/russley/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/bin/antigen.zsh

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme agnoster
antigen apply

alias fuck='$(thefuck $(fc -ln -1))'

export NVM_DIR="/home/russley/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
