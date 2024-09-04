{ config, pkgs, ... }:
{
  # tmux
  # TODO: change to use home-manager
  programs.tmux.enable = true;
  programs.tmux.baseIndex = 1;
  home.file.".tmux.conf".source = ../../../dot/tmux/.tmux.conf;
}
