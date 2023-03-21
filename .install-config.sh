#!/bin/bash

set -e
DOTFILES_PATH="$HOME/.dotfiles"
PKGS="stow zsh ripgrep curl"


clone_repo() {
  echo "🔨 Pulling dotfiles to $DOTFILES_PATH"
  while true; do
  read -p "Continue? (yes/no) " yn
  case $yn in 
          yes ) break;;
          no ) return;;
          * ) echo invalid response;;
  esac
  done
  git clone --progress https://github.com/tatupesonen/dotfiles.git $DOTFILES_PATH
}

install_pkg_debian() {
 echo "📦 Installing packages"
 echo "   $PKGS"
 sudo apt-get update && sudo apt-get -y -qq install $PKGS
 echo "✅ Packages installed!"
}

install_omz() {
  echo "📦 Installing Oh my Zsh"
  rm -rf $HOME/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc || true
}

mount_cfg() {
  echo "Will mount configuration from $DOTFILES_PATH to $HOME/"
  while true; do
  read -p "Do you want to mount the dotfiles? (yes/no) " yn
  case $yn in 
          yes ) echo Mounting dotfiles to $HOME/;
                break;;
          no ) return;;
          * ) echo invalid response;;
  esac
  done
  stow --dir=$DOTFILES_PATH --target=$HOME/ .
}

change_shell() {
  echo "🔨 Changing shell to $(which zsh)"
  chsh -s $(which zsh)
}

install_fzf() {
  echo "🔍 Installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}


install_pkg_debian
clone_repo
mount_cfg
change_shell
install_omz

echo "✅ Done!"
