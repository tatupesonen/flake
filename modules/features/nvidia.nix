_: {
  flake.nixosModules.nvidia = {
    config,
    pkgs,
    ...
  }: {
    boot.initrd.kernelModules = ["nvidia"];
    boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    programs.hyprland.enableNvidiaPatches = true;
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      nvidia.modesetting.enable = true;
    };
  };
}
