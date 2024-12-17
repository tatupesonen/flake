{userConfig, ...}: {
  virtualisation.docker.enable = true;
  # Enable docker group
  users.users.${userConfig.userName}.extraGroups = ["docker"];
}
