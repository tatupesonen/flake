{
  config,
  pkgs,
  ...
}: {
  # tmux
  # TODO: change to use home-manager
  programs.tmux.enable = true;
  home.file.".tmux.conf".source = ../../../dot/tmux/.tmux.conf;
}
