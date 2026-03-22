_: {
  flake.homeManagerModules.fzf = _: {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
