{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
  };
  home.file.".config/alacritty/alacritty.yml".source = ../../../dot/alacritty/alacritty.yml;
}
