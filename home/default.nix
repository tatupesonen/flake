{
  prof,
  userConfig,
  ...
}: {
  # Home-manager receives wanted home modules from flake.nix.

  imports = prof;
  home.username = userConfig.userName;
  home.homeDirectory = "/home/${userConfig.userName}";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
