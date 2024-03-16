{pkgs, ...}: {
  wsl.enable = true;
  wsl.defaultUser = "tatu";
  networking.hostName = "moltres";
}
