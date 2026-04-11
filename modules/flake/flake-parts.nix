_: {
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;

    checks = {
      formatting = pkgs.runCommand "check-formatting" {} ''
        ${pkgs.alejandra}/bin/alejandra -c ${../..} 2>&1 || (echo "Run 'nix fmt' to fix" && exit 1)
        touch $out
      '';
      lint = pkgs.runCommand "check-lint" {} ''
        ${pkgs.statix}/bin/statix check ${../..} -c ${../../statix.toml} 2>&1
        touch $out
      '';
      deadcode = pkgs.runCommand "check-deadcode" {} ''
        ${pkgs.deadnix}/bin/deadnix -f ${../..} 2>&1
        touch $out
      '';
    };

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [alejandra nil statix deadnix sbctl];
    };
  };
}
