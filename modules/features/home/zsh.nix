_: {
  flake.homeManagerModules.zsh = {userConfig, ...}: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting = {
        enable = true;
        styles = {
          alias = "fg=#b294bb";
          unknown-token = "fg=#cc6666";
          precommand = "fg=#8abeb7";
          command = "fg=#24eef9,bold";
          path = "fg=#24eef9";
          globbing = "fg=#24eef9";
          comment = "fg=#81a2be";
          builtin = "fg=#5e8d87";
          reserved-word = "fg=#6d9cbe";
          string = "fg=#f0c674";
          parameter = "fg=#de935f";
          constant = "fg=#b294bb";
          error = "fg=#cc6666,bold";
          undefined-command = "fg=#cc6666,bold";
        };
      };
      history.size = 30000;
      shellAliases = {
        nixpull = "cd $HOME/dotfiles && git pull";
        nixbackup = ''cd $HOME/dotfiles && git add . && git commit -m "backup: $(date -I)" && git push'';
        update = "sudo nixos-rebuild switch --flake $HOME/dotfiles --impure";
        refresh = "nixpull && update";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "z"];
        theme = "bureau";
      };
      initContent = ''
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^x^e' edit-command-line
      '';
    };
    home.sessionPath = [
      "/home/${userConfig.userName}/.config/composer/vendor/bin"
      "/home/${userConfig.userName}/.vscode-server/bin"
      "/home/${userConfig.userName}/go/bin"
    ];
  };
}
