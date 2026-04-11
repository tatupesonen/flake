_: {
  den.aspects.mysql.nixos = {pkgs, ...}: {
    services.mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
  };
}
