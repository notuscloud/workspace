#!/usr/bin/env bash

OHMYZSH_PATH=~/.oh-my-zsh
OHMYZSH_VERSION=v0.0.1
OHMYZSH_REPO=astraios/oh-my-zsh

# Silence pushd and popd
pushd () {
    command pushd "$@" > /dev/null
}
popd () {
    command popd "$@" > /dev/null
}

# Log function
function log {
    echo "[$(date +"%Y-%m-%d %T,%S")]: $*"
}

# Will prepare system for zsh to work
# function to install ohmyzsh
# function to install zsh theme

# OH-MY-ZSH installation
function install_omyzsh() {

  if [[ ! -f $OHMYZSH_PATH ]]; then
    # Fetch install script
    pushd /var/tmp || exit 1
    curl -Lo install.sh https://raw.githubusercontent.com/${OHMYZSH_REPO}/${OHMYZSH_VERSION}/tools/install.sh
    # execute install script
    rm -rf OHMYZSH_PATH
    ZSH=$OHMYZSH_PATH REPO=$OHMYZSH_REPO BRANCH=$OHMYZSH_VERSION sh install.sh
    # Return to previous directory
    popd || exit 1
  else
    log "Oh-my-zsh install dir exists, it might already be installed"
  fi

}

# -----------------------------------------------------------------
# Oh-my-zsh
# -----------------------------------------------------------------
install_omyzsh

# -----------------------------------------------------------------
# Copy dotfiles
# -----------------------------------------------------------------

# Move to home dir
cd

# .zshrc
log "Installing .zshrc symlink"
rm -rf ~/.zshrc
ln -s dotfiles/.zshrc .zshrc

# .tmux.conf
log "Installing .tmux.conf symlink"
rm -rf ~/.tmux.conf
ln -s dotfiles/.tmux.conf .

# vimrc
log "Installing .vimrc symlink"
rm -rf ~/.vimrc
ln -s dotfiles/.vimrc .
