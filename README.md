# .dotfiles and NixOS configs

## Structure
```bash
└── dotfiles
    ├── dot                     # Contains dotfiles and whatnot
    │   ├── ...
    ├── flake.lock
    ├── flake.nix               # Flake entrypoint, also may inject additional modules to hosts
    ├── hosts                   # Per-host configuration
    │   ├── laptop 
    │   ├── vm
    │   └── wsl
    ├── modules
    │   ├── dev                 # Dev related (install Rust, PHP etc.)
    │   ├── home                # "Overlays"
    │   │   ├── common          # Commonly used home-manager configs that are present on pretty much every host
    │   │   ├── default.nix     # home.nix
    │   │   ├── style           # Styles
    │   │   └── work            # home-manager configs for work (install PHPStorm, alacritty etc.)
    │   ├── misc                # Miscellanous modules (installing Docker or adding VMWare Guest Agent etc.)
    │   ├── nixos               # System-level configs (eg. configuring Nvidia, base system.nix)
    │   └── wm                  # Window manager config
    └── README.md
```
