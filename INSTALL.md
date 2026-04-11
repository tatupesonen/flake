# Installing NixOS on a New Host (Remote)

## Prerequisites

- A machine with Nix installed (to run `nixctl`)
- The sops age key at `~/.config/sops/age/keys.txt` and `~/.ssh/sops_ed25519`
- The target machine (physical or VM)

First-time sops setup (only once):

```bash
ssh-keygen -t ed25519 -f ~/.ssh/sops_ed25519 -N ""
mkdir -p ~/.config/sops/age
nix shell nixpkgs#ssh-to-age -c ssh-to-age -private-key -i ~/.ssh/sops_ed25519 > ~/.config/sops/age/keys.txt
```

## 1. Create the host config

Create `modules/hosts/<hostname>/` with three files:

**`<hostname>.nix`** — pick a profile and aspects:

```nix
{den, ...}: {
  den.aspects.<hostname> = {
    includes = [
      # Pick ONE profile:
      den.aspects.desktop-base   # Desktop: niri, noctalia, stylix, pipewire, browser
      # den.aspects.server-base  # Server: openssh, firewall, no GUI (~4 GiB)

      # Optional aspects:
      # den.aspects.work-profile # docker, dev-languages, work tools
      # den.aspects.ssd          # fstrim
      # den.aspects.intel-cpu    # Intel microcode
      # den.aspects.nvidia       # Nvidia drivers
      # den.aspects.mysql        # MySQL service
      # den.aspects.lanzaboote   # Secure boot (needs sbctl keys)
    ];

    nixos = {pkgs, ...}: {
      networking.hostName = "<hostname>";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [vim];
    };
  };
}
```

**`hardware.nix`** — disk layout:

```nix
{...}: {
  den.aspects.<hostname>.nixos = {modulesPath, ...}: {
    hardware.facter.reportPath = ./facter.json;

    disko.devices.disk.main = {
      device = "/dev/sda";  # SATA=/dev/sda  NVMe=/dev/nvme0n1  virtio=/dev/vda
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["fmask=0077" "dmask=0077"];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
```

**`facter.json`** — placeholder (auto-generated during install):

```json
{}
```

## 2. Register the host

Add to `modules/flake/hosts.nix`:

```nix
<hostname> = {users.tatu.classes = ["homeManager"];};
```

## 3. Verify it builds

```bash
git add -A
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

## 4. Prepare the target

### Physical machine

Build and flash the installer ISO:

```bash
./nixctl iso
sudo dd if=result/iso/nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress
```

Boot from USB, then:

```bash
sudo passwd root
sudo systemctl start sshd
ip a  # note the IP
```

### VM (for testing)

```bash
./nixctl vm
```

This boots a QEMU VM from the installer ISO with SSH on `localhost:2222`. Then in the VM:

```bash
sudo passwd root
sudo systemctl start sshd
```

## 5. Install

```bash
ssh-copy-id [-p 2222] root@<target>
./nixctl install
```

The wizard prompts for:

| Prompt | Description |
|--------|-------------|
| Configuration | Select your host |
| Target | `root@<ip>` (or `root@localhost` for VM) |
| SSH port | `22` (or `2222` for VM) |
| Auth | `key` (after ssh-copy-id) |
| User password | Login password for tatu |
| LUKS | Optional disk encryption |

It automatically:
- Generates and encrypts the host SSH key (sops)
- Encrypts the user password (sops)
- Partitions the disk (disko)
- Detects hardware (nixos-facter)
- Installs NixOS (nixos-anywhere)

## 6. Post-install

After rebooting:

1. Commit the generated files:

```bash
git add -A
git commit -m "feat: add <hostname>"
git push
```

2. To update the config later:

```bash
./nixctl deploy <hostname> root@<target> [port]
```

## Testing different configs

To switch a running host to a different config without reinstalling:

```bash
./nixctl deploy <other-config> root@<target> [port]
```
