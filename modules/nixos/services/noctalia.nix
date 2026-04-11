{inputs, ...}: {
  den.aspects.noctalia-shell = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.system}.default
      ];
      services.upower.enable = true;
    };
  };
}
