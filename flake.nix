{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    #sops-nix.url = "github:Mic92/sops-nix";
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-23.11";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    vscode-server,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = let
      systemConfig = system: modules:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          inherit system;
          modules =
            [
              vscode-server.nixosModules.default
              ./nixos/system.nix
              # ./nixos/sops.nix
              # ./home
            ]
            ++ modules;
        };
    in {
      wsl = systemConfig "x86_64-linux" [./hosts/wsl/wsl.nix nixos-wsl.nixosModules.wsl];
      laptop = systemConfig "x86_64-linux" [./hosts/laptop/laptop.nix];
    };
  };
}