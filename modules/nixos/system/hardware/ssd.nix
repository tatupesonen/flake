{...}: {
  den.aspects.ssd.nixos = {
    services.fstrim.enable = true;
  };
}
