_: {
  den.aspects.vm-vindicta.nixos = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/profiles/qemu-guest.nix")];

    boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    disko.devices.disk.main = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["fmask=0077" "dmask=0077"];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
