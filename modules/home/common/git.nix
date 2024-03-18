{
  config,
  pkgs,
  userConfig,
  ...
}: {
  programs.git.enable = true;
  programs.git = {
    userName = userConfig.fullName;
    userEmail = userConfig.userEmail;
  };
}
