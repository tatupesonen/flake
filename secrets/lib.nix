# Secret registry — single source of truth for all sops secrets.
#
# Adding a new secret:
#   1. Encrypt the file:  sops -e myfile > secrets/files/my-secret
#   2. Add one line here:  my-secret = { path = ".config/my/file"; tags = ["work"]; };
#   3. Done. Every user with that tag gets it automatically.
#
# Usage in user aspects:
#   let sec = import ../../secrets/lib.nix; in
#   sops.secrets = sec.forUser "tatu" "/home/tatu" ["base" "work"];
#   system.activationScripts.tatu-pubkeys = sec.pubkeysFor "tatu" "/home/tatu" ["base" "work"];
let
  # ── Registry ────────────────────────────────────────────────────────
  # Each entry: { path = "relative/to/home"; tags = [...]; }
  # Optional: mode (default "0600"), pub = "filename.pub" for SSH pubkeys
  registry = {
    # ── base (every user) ──────────────────────────────
    ssh-config = {
      path = ".ssh/config";
      mode = "0644";
      tags = ["base"];
    };
    ssh-key = {
      path = ".ssh/id_ed25519";
      tags = ["base"];
      pub = "id_ed25519.pub";
    };
    age-key = {
      path = ".config/sops/age/keys.txt";
      tags = ["base"];
    };

    # ── work ───────────────────────────────────────────
  };

  # Pubkeys that aren't tied to a secret but should still be deployed
  extraPubkeys = [];

  # ── Helpers (builtins only — no nixpkgs lib needed) ──────────────
  matchesTags = tags: entry:
    builtins.any (t: builtins.elem t tags) entry.tags;

  fileExists = name: builtins.pathExists (./files + "/${name}");

  namesForTags = tags:
    builtins.filter (n: matchesTags tags registry.${n} && fileExists n) (builtins.attrNames registry);

  mkSecret = userName: home: name: let
    entry = registry.${name};
  in {
    sopsFile = ./files/${name};
    format = "binary";
    owner = userName;
    mode = entry.mode or "0600";
    path = "${home}/${entry.path}";
  };
in {
  inherit registry;

  # Generate sops.secrets attrset for a user with given tags
  # Usage: sops.secrets = sec.forUser "tatu" "/home/tatu" ["base" "work"];
  forUser = userName: home: tags:
    builtins.listToAttrs (map (name: {
      inherit name;
      value = mkSecret userName home name;
    }) (namesForTags tags));

  # Generate activation script that installs SSH public keys
  # Usage: system.activationScripts.tatu-pubkeys = sec.pubkeysFor "tatu" "/home/tatu" ["base" "work"];
  pubkeysFor = userName: home: tags: let
    matching =
      builtins.filter
      (n: matchesTags tags registry.${n} && registry.${n} ? pub)
      (builtins.attrNames registry);
    pubLines =
      map (
        n: "install -m 644 -o ${userName} ${./pubkeys/${registry.${n}.pub}} ${home}/.ssh/${registry.${n}.pub}"
      )
      matching;
    extraLines =
      map (
        e: "install -m 644 -o ${userName} ${./pubkeys/${e.file}} ${home}/${e.dest}"
      )
      extraPubkeys;
  in {
    text = ''
      install -d -m 700 -o ${userName} ${home}/.ssh
      ${builtins.concatStringsSep "\n      " (pubLines ++ extraLines)}
    '';
    deps = ["users" "groups"];
  };
}
