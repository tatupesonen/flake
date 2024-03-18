{
  config,
  pkgs,
  ...
}: {
  imports = [./alacritty.nix ./vscode.nix ./phpstorm.nix];
}
