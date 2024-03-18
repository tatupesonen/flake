{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh
  ];
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
}
