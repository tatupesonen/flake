{
  config,
  pkgs,
  ...
}: {
  imports = [./alacritty.nix ./vscode.nix];
}
