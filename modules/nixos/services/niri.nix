{inputs, ...}: let
  noctalia = cmd: ["noctalia-shell" "ipc" "call"] ++ (builtins.filter (s: s != "") (builtins.split " " cmd));
in {
  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      imports = [inputs.niri.nixosModules.niri];

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

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };

    homeManager = {pkgs, ...}: {
      programs.niri.settings = {
        spawn-at-startup = [
          {command = ["noctalia-shell"];}
        ];

        binds = let
          spawn = cmd: {action.spawn = cmd;};
        in {
          "Mod+Return" = spawn ["alacritty"];
          "Mod+Space" = {action.spawn = noctalia "launcher toggle";};
          "Mod+Q" = {action.close-window = [];};
          "Mod+F" = {action.fullscreen-window = [];};
          "Mod+Shift+F" = {action.maximize-column = [];};
          "Mod+M" = {action.spawn = noctalia "sessionMenu toggle";};

          # Focus
          "Mod+H" = {action.focus-column-left = [];};
          "Mod+J" = {action.focus-window-down = [];};
          "Mod+K" = {action.focus-window-up = [];};
          "Mod+L" = {action.focus-column-right = [];};

          # Move
          "Mod+Shift+H" = {action.move-column-left = [];};
          "Mod+Shift+J" = {action.move-window-down = [];};
          "Mod+Shift+K" = {action.move-window-up = [];};
          "Mod+Shift+L" = {action.move-column-right = [];};

          # Workspaces
          "Mod+1" = {action.focus-workspace = 1;};
          "Mod+2" = {action.focus-workspace = 2;};
          "Mod+3" = {action.focus-workspace = 3;};
          "Mod+4" = {action.focus-workspace = 4;};
          "Mod+5" = {action.focus-workspace = 5;};
          "Mod+Shift+1" = {action.move-column-to-workspace = 1;};
          "Mod+Shift+2" = {action.move-column-to-workspace = 2;};
          "Mod+Shift+3" = {action.move-column-to-workspace = 3;};
          "Mod+Shift+4" = {action.move-column-to-workspace = 4;};
          "Mod+Shift+5" = {action.move-column-to-workspace = 5;};

          # Resize
          "Mod+Minus" = {action.set-column-width = "-10%";};
          "Mod+Equal" = {action.set-column-width = "+10%";};

          # Screenshot
          "Print" = {action.screenshot = [];};
          "Mod+Print" = {action.screenshot-window = [];};

          # Audio (via noctalia OSD)
          "XF86AudioRaiseVolume" = {action.spawn = noctalia "audio volumeUp";};
          "XF86AudioLowerVolume" = {action.spawn = noctalia "audio volumeDown";};
          "XF86AudioMute" = {action.spawn = noctalia "audio volumeToggleMute";};
        };

        # Niri layout
        layout = {
          gaps = 8;
          default-column-width.proportion = 0.5;
          focus-ring = {
            width = 2;
            active.color = "#91BEF5";
            inactive.color = "#414868";
          };
        };

        # For noctalia rounded corners
        window-rules = [
          {
            geometry-corner-radius = let r = 8.0; in {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
            clip-to-geometry = true;
          }
        ];
      };
    };
  };
}
