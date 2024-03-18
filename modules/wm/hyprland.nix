{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
  	rofi-wayland
  ];
  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    # waybar = {
    #   enable = true;
    #   package = pkgs.waybar.overrideAttrs (oldAttrs: {
    #     mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    #   });
    # };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
