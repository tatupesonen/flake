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
    shellAliases = {
      nixpull = "cd $HOME/dotfiles && git pull";
      update = "sudo nixos-rebuild switch --flake .";
      refresh = "nixpull && update";
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
