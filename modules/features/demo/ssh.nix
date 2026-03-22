_: {
  flake.nixosModules.demoSsh = _: {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [22 1234];
    };
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };
}
