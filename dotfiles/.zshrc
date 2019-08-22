# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git, terraform, vault, kubectl)

# Source oh-my-zsh script
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
# Test if $SSH_CONNECTION is set
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
