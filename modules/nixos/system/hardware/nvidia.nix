_: {
  den.aspects.nvidia.nixos = {config, ...}: {
    boot.initrd.kernelModules = ["nvidia"];
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
