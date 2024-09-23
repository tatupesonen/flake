{
  pkgs,
  userConfig,
  ...
}: {
  services = {
    vscode-server.enable = true;
  };
  wsl = {
    enable = true;
    defaultUser = userConfig.userName;
    docker-desktop.enable = true;
  };
  networking.hostName = "wsl";
}
