{...}: {
  # Laitetaa tama nii voidaan muokata hosts filea!
  networking.firewall.allowedTCPPorts = [80];
  environment.etc.hosts.mode = "0644";
  services.nginx = {
    enable = true;
    virtualHosts."status.narigon.dev" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];

      locations."/" = {
        proxyPass = "http://localhost:3001";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
        '';
      };
    };
  };
}
