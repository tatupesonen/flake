{...}: {
  den.aspects.dev-languages.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      clang
      go
      gopls
      php83
      php83Packages.composer
      python312
      python312Packages.pip
      python312Packages.virtualenv
      rustup
    ];
  };
}
