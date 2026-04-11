{inputs, ...}: {
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

      ({
        pkgs,
        lib,
        ...
      }: {
        nixpkgs.hostPlatform = "x86_64-linux";
        nixpkgs.config.allowUnfree = true;
        nix.settings.experimental-features = ["nix-command" "flakes"];

        networking.wireless.enable = lib.mkForce false;
        networking.networkmanager.enable = true;

        # SSH ready out of the box
        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0TRPtsjD7CV476AeJ1c2GbFIrrGc4Tq66CBjnSBmwu tatu@narigon.dev"
        ];

        environment.systemPackages =
          (with pkgs; [
            git
            vim
            disko
            sops
          ])
          ++ [
            (pkgs.writeShellScriptBin "nixos-install-host" ''
              set -euo pipefail
              FLAKE_DIR="/home/nixos/flake"
              HOST="''${1:-}"
              AGE_KEY_FILE="/tmp/age-key.txt"

              # ── Age key ──────────────────────
              if [ ! -f "$AGE_KEY_FILE" ]; then
                echo ":: Paste your age secret key (AGE-SECRET-KEY-...):"
                read -r AGE_KEY
                if [[ ! "$AGE_KEY" =~ ^AGE-SECRET-KEY- ]]; then
                  echo "Error: invalid age key"
                  exit 1
                fi
                echo "$AGE_KEY" > "$AGE_KEY_FILE"
                chmod 600 "$AGE_KEY_FILE"
              fi
              export SOPS_AGE_KEY_FILE="$AGE_KEY_FILE"

              # ── Clone config ─────────────────
              if [ ! -d "$FLAKE_DIR" ]; then
                echo ":: Cloning flake..."
                ${pkgs.git}/bin/git clone https://github.com/tatupesonen/flake.git "$FLAKE_DIR"
              fi

              # List available hosts from the flake (excluding 'installer' itself)
              HOSTS=$(${pkgs.nix}/bin/nix flake show "$FLAKE_DIR" --json 2>/dev/null \
                | ${pkgs.jq}/bin/jq -r '.nixosConfigurations | keys[] | select(. != "installer")')

              if [ -z "$HOST" ]; then
                echo "Usage: nixos-install-host <host-name>"
                echo ""
                echo "Available hosts:"
                echo "$HOSTS" | while read -r h; do echo "  $h"; done
                exit 1
              fi

              # Validate host exists
              if ! echo "$HOSTS" | grep -qx "$HOST"; then
                echo "Error: unknown host '$HOST'"
                echo ""
                echo "Available hosts:"
                echo "$HOSTS" | while read -r h; do echo "  $h"; done
                exit 1
              fi

              # ── LUKS (optional) ──────────────
              if grep -rq "luks" "$FLAKE_DIR/modules/hosts/$HOST/" 2>/dev/null; then
                echo ":: Enter LUKS password:"
                read -rs LUKS_PASS
                echo "$LUKS_PASS" > /tmp/luks-password
              fi

              # ── Partition with disko ─────────
              echo ":: Running disko for $HOST..."
              ${pkgs.disko}/bin/disko --mode destroy,format,mount \
                --flake "$FLAKE_DIR#$HOST"

              [[ -f /tmp/luks-password ]] && rm -f /tmp/luks-password

              # ── Host SSH key ─────────────────
              SOPS_KEY="$FLAKE_DIR/secrets/host-keys/$HOST"
              HOST_KEY_DIR="$FLAKE_DIR/modules/hosts/$HOST/keys"
              mkdir -p /mnt/etc/ssh

              if [ -f "$SOPS_KEY" ]; then
                echo ":: Decrypting host SSH key from sops..."
                ${pkgs.sops}/bin/sops --decrypt "$SOPS_KEY" > /mnt/etc/ssh/ssh_host_ed25519_key
                chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
                cp "$HOST_KEY_DIR/ssh_host_ed25519_key.pub" /mnt/etc/ssh/ssh_host_ed25519_key.pub
                chmod 644 /mnt/etc/ssh/ssh_host_ed25519_key.pub
              else
                echo ":: WARNING: No sops-encrypted host key found for $HOST"
                echo ":: Generating new host SSH key (you will need to update .sops.yaml)..."
                ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""
              fi

              # ── Install ──────────────────────
              echo ":: Running nixos-install..."
              nixos-install --flake "$FLAKE_DIR#$HOST" --no-root-password

              # ── Generate facter.json ─────────
              echo ":: Generating hardware report..."
              if command -v nixos-facter &>/dev/null; then
                nixos-facter -o /mnt/etc/nixos/facter.json
                echo ":: facter.json saved to /mnt/etc/nixos/facter.json"
                echo ":: Copy it to your flake: modules/hosts/$HOST/facter.json"
              fi

              # Cleanup
              rm -f "$AGE_KEY_FILE"

              echo ""
              echo ":: Done! Remove USB and reboot."
            '')
          ];

        system.stateVersion = "25.11";
      })
    ];
  };
}
