{
  config,
  pkgs,
  ...
}: {
  # tmux
  # TODO: change to use home-manager
  home.packages = with pkgs; [
    tmux
  ];
  home.file.".tmux.conf".source = ../../../dot/tmux/.tmux.conf;
}
