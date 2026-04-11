{den, lib, ...}: let
  sec = import ../../secrets/lib.nix;
  u = "tatu";
  h = "/home/tatu";
  hasSecrets = builtins.pathExists ../../secrets/secrets.yaml;
  hasFileSecrets = hasSecrets && (sec.forUser u h ["base" "work"]) != {};
in {
  den.aspects.tatu = {
    includes = [
      den.provides.define-user
      den.aspects.hm-shell
      den.aspects.neovim
    ];

    user = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "docker"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0TRPtsjD7CV476AeJ1c2GbFIrrGc4Tq66CBjnSBmwu tatu@narigon.dev"
      ];
    } // (if hasSecrets then {
      hashedPasswordFile = "/run/secrets-for-users/tatu-password";
    } else {
      initialPassword = "changeme";
    });

    nixos = {pkgs, ...}: {
      programs.zsh.enable = true;
      users.users.tatu = {
        description = "Tatu Pesonen";
        shell = pkgs.zsh;
      };
      users.mutableUsers = !hasSecrets;

      sops.secrets = lib.mkIf hasSecrets (sec.forUser u h ["base" "work"] // {
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
