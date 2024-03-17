{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    fzf
    git
    rustup
    wget
    alejandra
    nil
    tmux
    eza
    zsh
  ];

  system.stateVersion = "23.11";
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  services = {
    vscode-server.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      accept-flake-config = true;
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
