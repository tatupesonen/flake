{ config, pkgs, ... }:
{
  imports = [
    ./php.nix
    ./rustup.nix
    ./clang.nix
    ./python.nix
  ];
}
