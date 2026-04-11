{den, ...}: {
  den.aspects.vindicta = {
    includes = [
      den.aspects.desktop-base
      den.aspects.work-profile
      den.aspects.intel-cpu
      den.aspects.ssd
      den.aspects.mysql
      # den.aspects.lanzaboote  # Enable after running: sudo sbctl create-keys
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "vindicta";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [vim];
    };
  };
}
