{
  pkgs,
  userConfig,
  ...
}: {
  wsl.enable = true;
  wsl.defaultUser = userConfig.userName;
  networking.hostName = "moltres";
}
