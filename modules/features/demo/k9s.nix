_: {
  flake.nixosModules.demoK9s = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [k9s];
  };
}
