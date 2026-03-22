{inputs, ...}: {
  flake.lib.mkHost = {
    system ? "x86_64-linux",
    modules,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        userConfig = {
          userName = "tatu";
          fullName = "Tatu Pesonen";
          userEmail = "tatu@narigon.dev";
        };
        inherit inputs;
      };
      inherit modules;
    };
}
