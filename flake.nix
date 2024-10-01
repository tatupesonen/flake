{
  description = "NixOS Flake for @tatupesonen configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    vscode-server,
    home-manager,
    nixpkgs-unstable,
    ...
  } @ inputs: {
    nixosConfigurations = let
      userConfig = {
        userName = "tatu";
        fullName = "Tatu Pesonen";
        userEmail = "tatu@narigon.dev";
        root = true;
      };
      systemConfig = system: modules: prof:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
            inherit inputs userConfig;
          };
          inherit system;
          modules =
            [
              home-manager.nixosModules.home-manager
              (
                {
                  config,
                  pkgs,
                  ...
                }: {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      "${userConfig.userName}" = import ./modules/home;
                    };
                    extraSpecialArgs = {
                      inherit inputs prof userConfig;
                    };
                  };
                }
              )
              # Default module imported for all hosts
              ./modules/nixos/system.nix
              ./modules/dev
              ./modules/nixos/ssh.nix
            ]
            ++ modules;
        };
    in {
      # WSL host Nix modules
      wsl =
        systemConfig "x86_64-linux"
        [
          ./hosts/wsl/wsl.nix
          nixos-wsl.nixosModules.wsl
          vscode-server.nixosModules.default
        ]
        # WSL host home modules
        [./modules/home/common];
      # Laptop host Nix modules
      laptop =
        systemConfig "x86_64-linux"
        [
          ./hosts/laptop/laptop.nix
          ./modules/home/common
          ./modules/dev
        ]
        # Laptop host home modules
        [];
      vindicta =
        systemConfig "x86_64-linux"
        [
          ./hosts/vindicta/configuration.nix
          ./modules/dev
          ./modules/misc/docker.nix
          ./modules/work
        ]
        [
          ./modules/home/common
          ./modules/home/work
          ./modules/home/style
        ];
    };
  };
}
