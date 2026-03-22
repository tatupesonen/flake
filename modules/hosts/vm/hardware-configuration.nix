_: {
  flake.nixosModules.vmHardware = {lib, ...}: {
    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
      initrd = {
        availableKernelModules = ["ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod"];
        kernelModules = [];
      };
      kernelModules = [];
      extraModulePackages = [];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/2ff3ed3e-6df1-4237-9acf-8b7f57a1e61c";
      fsType = "ext4";
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
