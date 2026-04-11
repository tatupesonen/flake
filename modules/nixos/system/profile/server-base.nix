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
      networking.firewall.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
        };
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0TRPtsjD7CV476AeJ1c2GbFIrrGc4Tq66CBjnSBmwu tatu@narigon.dev"
      ];
    };
  };
}
