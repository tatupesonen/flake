_: {
  flake.nixosModules.system = {
    pkgs,
    lib,
    userConfig,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      git
    ];

    system.stateVersion = lib.mkDefault "24.05";
    time.timeZone = "Europe/Helsinki";
    i18n.defaultLocale = "en_US.UTF-8";
    services.printing.enable = false;

    programs.zsh.enable = true;
    users.users.${userConfig.userName} = {
      isNormalUser = true;
      description = userConfig.fullName;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TIME = "fi_FI.UTF-8";
    };

    nixpkgs.config.allowUnfree = true;
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        max-jobs = "auto";
        auto-optimise-store = true;
        accept-flake-config = true;
        trusted-users = [
          "root"
          "@wheel"
        ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      };
    };
  };
}
