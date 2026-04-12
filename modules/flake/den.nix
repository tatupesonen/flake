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

    # ── Boot splash ─────────────────────────────────────
    boot.plymouth.enable = true;
    boot.initrd.systemd.enable = true;

    # ── Security hardening ──────────────────────────────
    boot.loader.systemd-boot.editor = false;

    boot.kernel.sysctl = {
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.yama.ptrace_scope" = 2;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv6.conf.all.accept_source_route" = 0;
    };

    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };

    security.audit = {
      enable = true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
    security.auditd.enable = true;

    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "hm-backup";
    system.stateVersion = lib.mkDefault "24.05";
  };

  den.default.homeManager = {
    imports = [
      inputs.stylix.homeModules.stylix
    ];
    home.stateVersion = lib.mkDefault "24.05";
  };
}
