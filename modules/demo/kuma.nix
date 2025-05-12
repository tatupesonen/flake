{config, ...}: {
  config.virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      kuma = {
        image = "louislam/uptime-kuma:1";
        ports = ["0.0.0.0:3001:3001"];
        volumes = [
          "/home/tatu/kumadata:/app/data"
        ];
      };
    };
  };
}
