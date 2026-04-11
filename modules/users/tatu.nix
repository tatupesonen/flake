{den, ...}: {
  den.aspects.tatu = {
    includes = [
      den.provides.define-user
      den.aspects.hm-programs
      den.aspects.neovim
    ];

    user = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "docker"];
      initialPassword = "changeme";
    };

    nixos = {pkgs, ...}: {
      programs.zsh.enable = true;
      users.users.tatu = {
        description = "Tatu Pesonen";
        shell = pkgs.zsh;
      };
    };
  };
}
