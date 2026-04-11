{den, ...}: {
  den.aspects.artisan = {
    includes = [
      den.aspects.desktop-base
      den.aspects.work-profile
      den.aspects.ssd
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "artisan";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [vim];
    };
  };
}
