{inputs, ...}: let
  flakeSrc = inputs.self;
in {
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      inputs.disko.nixosModules.disko

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

        environment.systemPackages = with pkgs; [
          git
          vim
          disko
          nixos-facter
        ];

        # Auto-install script
        environment.etc."install.sh".source = pkgs.writeShellScript "auto-install" ''
          set -euo pipefail

          FLAKE="${flakeSrc}"
          HOST="artisan"
          DISK="/dev/sda"

          echo "============================================"
          echo "  NixOS Auto-Installer for: $HOST"
          echo "  Target disk: $DISK"
          echo "============================================"
          echo ""

          # Check target disk exists
          if [ ! -b "$DISK" ]; then
            echo "ERROR: Target disk $DISK not found."
            echo "Available disks:"
            ${pkgs.util-linux}/bin/lsblk -d -o NAME,SIZE,TYPE,MODEL
            echo ""
            echo "Update the disk device in the flake and rebuild the ISO."
            exit 1
          fi

          echo "WARNING: This will ERASE ALL DATA on $DISK"
          echo ""
          ${pkgs.util-linux}/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT "$DISK"
          echo ""
          read -p "Type 'yes' to continue: " confirm
          if [ "$confirm" != "yes" ]; then
            echo "Aborted."
            exit 1
          fi

          echo ""
          echo ">>> Partitioning and formatting with disko..."
          ${pkgs.disko}/bin/disko --mode destroy,format,mount --flake "$FLAKE#$HOST"

          echo ""
          echo ">>> Installing NixOS..."
          nixos-install --flake "$FLAKE#$HOST" --no-root-passwd

          echo ""
          echo ">>> Generating nixos-facter report..."
          mkdir -p /mnt/etc/nixos
          ${pkgs.nixos-facter}/bin/nixos-facter -o /mnt/etc/nixos/facter.json

          echo ""
          echo "============================================"
          echo "  Installation complete!"
          echo ""
          echo "  facter.json saved to /etc/nixos/facter.json"
          echo "  Copy it to your flake at:"
          echo "    modules/hosts/$HOST/facter.json"
          echo ""
          echo "  Remove the USB and reboot:"
          echo "    reboot"
          echo "============================================"
        '';

        system.stateVersion = "25.11";
      })
    ];
  };
}
