_: {
  flake.homeManagerModules.git = {userConfig, ...}: {
    programs.git = {
      enable = true;
      settings.user.name = userConfig.fullName;
      settings.user.email = userConfig.userEmail;
    };
  };
}
