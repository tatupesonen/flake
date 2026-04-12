{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      pkgs = pkgs.extend (_: _: {noctalia-shell = inputs.noctalia.packages.${pkgs.system}.default;});
      inherit
        ((builtins.fromJSON
          (builtins.readFile ./noctalia.json)))
        settings
        ;
    };
  };

  den.aspects.noctalia-shell = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.system}.myNoctalia
      ];
      services.upower.enable = true;

      # Make wallpaper available system-wide
      environment.etc."noctalia/wallpaper.jpg".source = ./wallpaper.jpg;
    };
  };
}
