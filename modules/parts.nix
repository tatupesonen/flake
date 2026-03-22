{lib, ...}: {
  options.flake.homeManagerModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
    description = "Home Manager modules.";
  };

  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [alejandra nil statix deadnix];
      };
    };
  };
}
