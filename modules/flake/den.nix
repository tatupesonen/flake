{
  inputs,
  lib,
  den,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.ctx.user.includes = [den._.mutual-provider];

  den.default.nixos = {...}: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.stylix.nixosModules.stylix
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = lib.mkIf (builtins.pathExists ../../secrets/secrets.yaml) ../../secrets/secrets.yaml;
    sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    nixpkgs.config.allowUnfree = true;

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        experimental-features = ["nix-command" "flakes"];
        max-jobs = "auto";
        auto-optimise-store = true;
        trusted-users = ["root" "@wheel"];
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://noctalia.cachix.org"
          "https://niri.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };
    };

    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "hm-backup";
    system.stateVersion = lib.mkDefault "24.05";
  };

  den.default.homeManager = {
    imports = [
      inputs.stylix.homeModules.stylix
      inputs.noctalia.homeModules.default
    ];
    home.stateVersion = lib.mkDefault "24.05";
  };
}
