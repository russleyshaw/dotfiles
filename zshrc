source ~/.antigen/antigen.zsh

zsh_nvm_version(){
    if [[ -f "package.json" || -f "../package.json" || -f "../../package.json"  ]]; then
        local version=$(nvm current)
        echo -n "$version"
    fi
}
POWERLEVEL9K_CUSTOM_NVM_VERSION="zsh_nvm_version"
POWERLEVEL9K_CUSTOM_NVM_VERSION_BACKGROUND="green"

DEFAULT_USER="russley"
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status custom_nvm_version root_indicator background_jobs history time)
export TERM="xterm-256color"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
POWERLEVEL9K_SHORTEN_DELIMITER=

antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme bhilburn/powerlevel9k powerlevel9k
antigen apply

autoload -Uz compinit promptinit
compinit
promptinit

prompt_context () { }

export PATH="$HOME/.yarn/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


