{
  config,
  pkgs,
  userConfig,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "z"];
      theme = "robbyrussell";
    };
  };
  # Add PHPUnit and whatnot to path
  home.sessionPath = [
    "/home/${userConfig.userName}/.config/composer/vendor/bin"
  ];
}
