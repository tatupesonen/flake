# Secrets Management

This flake uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption.

## How it works

```
~/.ssh/sops_ed25519  (your SSH key — NEVER committed)
        |
        v
~/.config/sops/age/keys.txt  (derived age key — NEVER committed)
        |
        v
.sops.yaml  (lists public keys that can decrypt — committed)
        |
        v
secrets/secrets.yaml    (encrypted passwords — committed)
secrets/host-keys/*     (encrypted host SSH keys — committed)
secrets/files/*         (encrypted user files — committed)
```

### Two types of decryptors

| Who | Key source | Used for |
|-----|-----------|----------|
| You | `~/.ssh/sops_ed25519` -> age key | Editing secrets, running `nixctl install` |
| Each host | `/etc/ssh/ssh_host_ed25519_key` -> age key | Decrypting secrets at boot via sops-nix |

Both are listed as age public keys in `.sops.yaml`. sops encrypts to all listed keys, so both you and the hosts can decrypt.

## Initial setup (once)

```bash
ssh-keygen -t ed25519 -f ~/.ssh/sops_ed25519 -N ""
mkdir -p ~/.config/sops/age
nix shell nixpkgs#ssh-to-age -c ssh-to-age -private-key \
  -i ~/.ssh/sops_ed25519 > ~/.config/sops/age/keys.txt
```

Back up `~/.ssh/sops_ed25519` somewhere safe. If you lose it, you cannot decrypt or re-encrypt any secrets.

## Secret types

### Passwords (`secrets/secrets.yaml`)

YAML file encrypted with sops. Contains user login password hashes.

```bash
./nixctl secrets edit   # decrypt, edit, re-encrypt
```

### Host SSH keys (`secrets/host-keys/<hostname>`)

Each host's private ed25519 key, encrypted as binary with sops. Generated automatically by `./nixctl install`. The matching public key is stored unencrypted at `modules/hosts/<hostname>/keys/ssh_host_ed25519_key.pub`.

These keys serve double duty:
1. SSH host identity
2. sops-nix decryption key (via age derivation)

### User files (`secrets/files/<name>`)

Binary files encrypted with sops (SSH keys, AWS credentials, kubeconfig, etc.). Registered in `secrets/lib.nix` with tags.

```bash
./nixctl secrets encrypt   # encrypts files from $HOME based on the registry
```

## File reference

| File | Encrypted | Committed | Purpose |
|------|-----------|-----------|---------|
| `.sops.yaml` | No | Yes | Defines who can decrypt what |
| `secrets/secrets.yaml` | Yes | Yes | User passwords |
| `secrets/host-keys/*` | Yes (binary) | Yes | Host SSH private keys |
| `secrets/files/*` | Yes (binary) | Yes | User credential files |
| `secrets/pubkeys/*` | No | Yes | SSH public keys for deployment |
| `secrets/lib.nix` | No | Yes | Secret registry and helpers |
| `modules/hosts/*/keys/*.pub` | No | Yes | Host SSH public keys |
| `~/.ssh/sops_ed25519` | No | **Never** | Your master decryption key |
| `~/.config/sops/age/keys.txt` | No | **Never** | Derived age key |

## Adding a new secret file

1. Add an entry to `secrets/lib.nix`:

```nix
registry = {
  my-secret = { path = ".config/my/file"; tags = ["base"]; };
};
```

2. Encrypt it:

```bash
./nixctl secrets encrypt
```

3. Commit and deploy. sops-nix decrypts it to the user's home on the target host.

## Adding a new host

`./nixctl install` handles everything:
- Generates host SSH key
- Encrypts private key to `secrets/host-keys/<hostname>`
- Updates `.sops.yaml` with the new host's age public key
- Re-encrypts `secrets.yaml` so the new host can decrypt it

## Key rotation

If you need to re-encrypt all secrets with current keys (e.g., after adding/removing a host):

```bash
./nixctl secrets rotate
```

## Recovery

If a host's SSH key is lost (e.g., disk failure):
1. Remove the old key: `rm secrets/host-keys/<hostname> modules/hosts/<hostname>/keys/*`
2. Re-run `./nixctl install` for that host — generates new keys
3. Run `./nixctl secrets rotate` to update all secrets with the new host key
