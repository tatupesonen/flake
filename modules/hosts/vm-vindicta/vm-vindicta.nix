{den, ...}: {
  den.aspects.vm-vindicta = {
    includes = [
      den.aspects.desktop-base
      den.aspects.work-profile
      den.aspects.ssd
      den.aspects.mysql
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "vm-vindicta";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [vim];
    };
  };
}
