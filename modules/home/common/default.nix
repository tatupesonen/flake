{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./tmux.nix ./fzf.nix ./zsh.nix ./neovim.nix ./git.nix];
}
