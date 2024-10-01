{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./tmux.nix
    ./fzf.nix
    ./zsh.nix
    ./git.nix
  ];
}
