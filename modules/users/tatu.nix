{pkgs}: {
  users.users.tatu = {
    isNormalUser = true;
    description = "tatu";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
