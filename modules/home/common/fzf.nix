{
  config,
  pkgs,
  environment,
  ...
}: {
 programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    tmux = {
      enableShellIntegration = true;
    };
  };
}
