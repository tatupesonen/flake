_: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [rofi-wayland];
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
  };
}
