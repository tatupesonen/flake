{
  den,
  lib,
  ...
}: let
  sec = import ../../secrets/lib.nix;
  u = "tatu";
  h = "/home/tatu";
  hasSecrets = builtins.pathExists ../../secrets/secrets.yaml;
  hasFileSecrets = hasSecrets && (sec.forUser u h ["base" "work"]) != {};
in {
  den.aspects.tatu = {
    includes = [
      den.provides.define-user
      den.aspects.hm-alacritty
      den.aspects.hm-shell
      den.aspects.neovim
    ];

    user =
      {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0TRPtsjD7CV476AeJ1c2GbFIrrGc4Tq66CBjnSBmwu tatu@narigon.dev"
        ];
      }
      // (lib.optionalAttrs hasSecrets {
        hashedPasswordFile = "/run/secrets-for-users/tatu-password";
      });

    homeManager = {config, ...}: {
      programs.git = {
        enable = true;
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
          format = "ssh";
        };
        settings = {
          user.name = "Tatu Pesonen";
          user.email = "tatu@narigon.dev";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = false;
          gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };
      };

      home.file.".ssh/allowed_signers".text = "tatu@narigon.dev ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0TRPtsjD7CV476AeJ1c2GbFIrrGc4Tq66CBjnSBmwu";
    };

    nixos = {
      config,
      pkgs,
      ...
    }: {
      programs.zsh.enable = true;
      users.users.tatu = {
        description = "Tatu Pesonen";
        shell = pkgs.zsh;
        extraGroups =
          lib.optionals config.networking.networkmanager.enable ["networkmanager"]
          ++ lib.optionals config.virtualisation.docker.enable ["docker"];
      };
      users.mutableUsers = !hasSecrets;

      sops.secrets = lib.mkIf hasSecrets (sec.forUser u h ["base" "work"]
        // {
          tatu-password.neededForUsers = true;
        });
      system.activationScripts = lib.mkIf hasFileSecrets {
        tatu-fix-home = {
          text = "chown -R ${u} ${h}/.config 2>/dev/null || true";
          deps = ["setupSecrets"];
        };
        tatu-pubkeys = sec.pubkeysFor u h ["base" "work"];
      };
    };
  };
}
