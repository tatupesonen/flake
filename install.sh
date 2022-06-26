#!/bin/bash

# Functions 
install_pkg() {
	sudo apt install -y $packages
}

# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
	curl -s https://api.github.com/repos/$1/releases/latest \
	| grep "browser_download_url.*deb" \
	| cut -d : -f 2,3 \
	| tr -d \"
}

install_custom_omz_pkgs() {
	sudo git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
}

install_antigen() {
	curl -L git.io/antigen > antigen.zsh
}

install_omz() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	install_custom_omz_pkgs
	install_antigen
}

install_fzf() {
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
}

stow_dotfiles() {
	rm ~/.zshrc
	stow -St ~ zsh
}

# Packages to install
packages="zsh jq stow curl"

# Determine OS
case "$OSTYPE" in
  darwin*)  IS_LINUX=true ;; 
  linux*)   IS_LINUX=true ;;
  *)        echo "unknown: $OSTYPE"; exit ;;
esac

# Determine package manager for OS.
determine_packager

echo "Installing for $OSTYPE..."


if [ IS_LINUX ]; then
	install_pkg
	install_omz
	install_fzf
	stow_dotfiles
fi
