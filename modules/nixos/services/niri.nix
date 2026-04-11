{inputs, ...}: {
  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      programs.xwayland.enable = true;
      environment.systemPackages = [
        inputs.niri.packages.${pkgs.system}.xwayland-satellite-stable
      ];

      services.xserver.enable = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # ly display manager
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          bg = 2369595; # 0x24283B - Tokyo Night background
          fg = 12634869; # 0xC0CAF5 - Tokyo Night foreground
          border_fg = 9551605; # 0x91BEF5 - Tokyo Night blue
          error_fg = 33064590; # 0x01F7768E - Tokyo Night red (bright)
          error_bg = 2369595;
          cmatrix_fg = 10408554; # 0x9ECE6A - Tokyo Night green
          cmatrix_head_col = 29492981; # 0x01C0CAF5
          hide_borders = false;
          hide_key_hints = false;
          bigclock = "digital";
          clock = "%H:%M";
        };
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
