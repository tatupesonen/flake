{inputs, ...}: {
  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      imports = [inputs.niri.nixosModules.niri];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      niri-flake.cache.enable = false;

      programs.xwayland.enable = true;
      environment.systemPackages = [
        inputs.niri.packages.${pkgs.system}.xwayland-satellite-stable
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
