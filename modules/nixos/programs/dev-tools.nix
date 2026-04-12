_: {
  den.aspects.dev-tools.nixos = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.vscode.fhs
      pkgs.claude-code
    ];
  };
}
