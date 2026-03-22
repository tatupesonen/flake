_: {
  flake.nixosModules.vmware = _: {
    virtualisation.vmware.guest.enable = true;
  };
}
