{
  config,
  pkgs,
  ...
}: {
  imports = [./tmux.nix ./fzf.nix ./zsh.nix ./neovim.nix ./git.nix ./alacritty.nix ./phpstorm.nix];
}
