{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      v2-settings = true;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb = {
          layout = "us,fi";
          options = "grp:alt_shift_toggle";
        };

        layout = {
          gaps = 8;
          default-column-width.proportion = 0.5;
          focus-ring.width = 2;
        };

        prefer-no-csd = true;

        window-rules = [
          {
            geometry-corner-radius = [8.0 8.0 8.0 8.0];
            clip-to-geometry = true;
          }
        ];

        binds = {
          "Mod+Return".spawn = [
            (lib.getExe pkgs.alacritty)
          ];
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+D".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+Q".close-window = _: {};
          "Mod+F".fullscreen-window = _: {};
          "Mod+Shift+F".maximize-column = _: {};
          "Mod+M".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call sessionMenu toggle";

          # Focus
          "Mod+H".focus-column-left = _: {};
          "Mod+J".focus-window-down = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+L".focus-column-right = _: {};

          # Move
          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+J".move-window-down = _: {};
          "Mod+Shift+K".move-window-up = _: {};
          "Mod+Shift+L".move-column-right = _: {};

          # Workspaces
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;

          # Resize
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          # Screenshot
          "Print".screenshot = _: {};
          "Mod+Print".screenshot-window = _: {};

          # Audio (via noctalia OSD)
          "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call audio volumeUp";
          "XF86AudioLowerVolume".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call audio volumeDown";
          "XF86AudioMute".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call audio volumeToggleMute";

          # Mouse scroll
          "Mod+WheelScrollDown".focus-workspace-down = _: {};
          "Mod+WheelScrollUp".focus-workspace-up = _: {};
          "Mod+TouchpadScrollDown".focus-workspace-down = _: {};
          "Mod+TouchpadScrollUp".focus-workspace-up = _: {};
        };
      };
    };
  };

  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      programs.niri = {
        enable = true;
        package = inputs.self.packages.${pkgs.system}.myNiri;
      };

      programs.xwayland.enable = true;
      environment.systemPackages = [
        pkgs.xwayland-satellite
      ];

      services.xserver.enable = true;
      services.xserver.xkb = {
        layout = "us,fi";
        options = "grp:alt_shift_toggle";
      };

      # ly display manager
      services.displayManager.ly.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
