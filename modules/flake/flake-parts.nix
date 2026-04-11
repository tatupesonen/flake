{...}: {
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [alejandra nil statix deadnix sbctl];
    };
  };
}
