_: {
  flake.nixosModules.vindictaHardware = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
        kernelModules = [];
        luks.devices."luks-3cda9259-feda-4e9a-a021-3aa056161b23" = {
          device = "/dev/disk/by-uuid/3cda9259-feda-4e9a-a021-3aa056161b23";
          allowDiscards = true;
        };
      };
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/024ea781-d83e-43fd-9c6e-16d074d939d8";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/274A-9294";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
