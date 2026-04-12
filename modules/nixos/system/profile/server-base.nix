{den, ...}: {
  den.aspects.server-base = {
    includes = [
      den.aspects.locale
      den.aspects.cli-tools
      den.aspects.ssh-agent
    ];

    nixos = {
      hardware.graphics.enable = false;

      networking.networkmanager.enable = true;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [22];
        allowPing = false;
      };

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };

      # Root login disabled — deploy via tatu user with sudo
    };
  };
}
