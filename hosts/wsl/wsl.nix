{
  pkgs,
  userConfig,
  ...
}: {
  services = {
    vscode-server.enable = true;
  };
  wsl.enable = true;
  wsl.defaultUser = userConfig.userName;
  networking.hostName = "moltres";
}
