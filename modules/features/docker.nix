_: {
  flake.nixosModules.docker = {userConfig, ...}: {
    virtualisation.docker.enable = true;
    users.users.${userConfig.userName}.extraGroups = ["docker"];
  };
}
