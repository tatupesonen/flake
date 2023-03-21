#!/bin/bash

set -e

install_pkg_debian() {
 local pkgs="stow zsh"
 echo "📦 Installing packages"
 echo "   $pkgs"
 sudo apt-get -y -qq install $pkgs 1> /dev/null
 echo "✅ Packages installed!"
}

mount_cfg() {
  echo "Will mount configuration from $HOME/.dotfiles to $HOME/"
  while true; do
  read -p "Do you want to mount the dotfiles? (yes/no) " yn
  case $yn in 
          yes ) echo Mounting dotfiles to $HOME/;
                break;;
          no ) return;;
          * ) echo invalid response;;
  esac
  done
  stow --dir=$HOME/.dotfiles --target=$HOME/ .
}


install_pkg_debian
mount_cfg
echo "✅ Done!"
