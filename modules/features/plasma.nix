_: {
  flake.nixosModules.plasma = _: {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
