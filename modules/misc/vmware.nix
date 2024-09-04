{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  # Enable vmware guest agent
  virtualisation.vmware.guest.enable = true;
}
