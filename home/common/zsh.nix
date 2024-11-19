{
  userConfig,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = false;
    };
    syntaxHighlighting = {
      enable = true;
      styles = {
        # Alias (Magenta)
        alias = "fg=#b294bb";
        # Unknown Token (Red)
        unknown-token = "fg=#cc6666";
        # Precommand (Bright Green)
        precommand = "fg=#8abeb7";
        # Command (Bright Cyan, Bold)
        command = "fg=#24eef9,bold";
        # Path (Bright Cyan)
        path = "fg=#24eef9";
        # Globbing (Bright Cyan)
        globbing = "fg=#24eef9";
        # Comments (Bright Blue)
        comment = "fg=#81a2be";
        # Builtins (Teal)
        builtin = "fg=#5e8d87";
        # Reserved Words (Dark Teal)
        reserved-word = "fg=#6d9cbe";
        # Strings (Bright Yellow)
        string = "fg=#f0c674";
        # Parameters (Orange)
        parameter = "fg=#de935f";
        # Constants (Magenta)
        constant = "fg=#b294bb";
        # Error (Red, Bold)
        error = "fg=#cc6666,bold";
        # Undefined Command (Red, Bold)
        undefined-command = "fg=#cc6666,bold";
      };
    };
    history = {
      size = 30000;
    };
    shellAliases = {
      nixpull = "cd $HOME/dotfiles && git pull";
      nixbackup = ''cd $HOME/dotfiles && git add . && git commit -m "backup: $(date -I)" && git push'';
      update = "sudo nixos-rebuild switch --flake $HOME/dotfiles --impure";
      refresh = "nixpull && update";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "bureau";
    };
  };
  # Add PHPUnit and whatnot to path
  home.sessionPath = [
    "/home/${userConfig.userName}/.config/composer/vendor/bin"
    "/home/${userConfig.userName}/.vscode-server/bin"
    "/home/${userConfig.userName}/go/bin"
  ];
}
