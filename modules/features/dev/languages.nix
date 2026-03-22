_: {
  flake.nixosModules.devLanguages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # C/C++
      clang

      # Go
      go
      gopls

      # PHP
      php83
      php83Packages.composer

      # Python
      python312
      python312Packages.pip
      python312Packages.virtualenv

      # Rust
      rustup
    ];
  };
}
