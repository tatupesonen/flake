{
  config,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      kernelModules = ["nvidia"];
    };
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  };
  # If we're on nvidia, enable hyprland nvidia patches
  programs = {
    hyprland = {
      enableNvidiaPatches = true;
    };
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  # Hardware
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
    };
  };
}
