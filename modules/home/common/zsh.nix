{
  config,
  pkgs,
  userConfig,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = false;
    };
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };
    shellAliases = {
      nixpull = "cd $HOME/dotfiles && git pull";
      update = "sudo nixos-rebuild switch --flake $HOME/dotfiles/flake.nix";
      refresh = "nixpull && update";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "z"];
      theme = "bira";
    };
  };
  # Add PHPUnit and whatnot to path
  home.sessionPath = [
    "/home/${userConfig.userName}/.config/composer/vendor/bin"
  ];
}
