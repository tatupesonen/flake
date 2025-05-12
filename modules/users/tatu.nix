{pkgs}: {
  users.users.tatu = {
    initialHashedPassword = "$6$3BPYRGiwphVi3Jfl$Mw46pM7giPYMOQD//c6E7z6yDzC7DDjYWJQF1MxgnF0iFh0Y1cft8juedbsVqOFYWtDIp5x9ztex79Zhumm5M0";
    isNormalUser = true;
    description = "tatu";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
