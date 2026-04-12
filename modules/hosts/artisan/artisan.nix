{den, ...}: {
  den.aspects.artisan = {
    includes = [
      den.aspects.desktop-base
      # den.aspects.work-profile
      den.aspects.dev-tools
      den.aspects.cybersec
      den.aspects.docker
      den.aspects.ssd
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "artisan";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
      environment.systemPackages = [pkgs.vim];
    };
  };
}
