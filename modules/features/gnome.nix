_: {
  flake.nixosModules.gnome = _: {
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}
