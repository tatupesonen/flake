{inputs, ...}: {
  den.aspects.noctalia-shell = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.system}.default
      ];
      services.upower.enable = true;
    };

    homeManager = {...}: {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia-shell = {
        enable = true;
      };
    };
  };
}
