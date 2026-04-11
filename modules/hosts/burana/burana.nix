{den, ...}: {
  den.aspects.burana = {
    includes = [
      den.aspects.server-base
      den.aspects.ssd
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "burana";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = [pkgs.vim];
    };
  };
}
