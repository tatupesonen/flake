_: {
  flake.homeManagerModules.bg = {pkgs, ...}: {
    home.packages = with pkgs; [swww];
  };
}
