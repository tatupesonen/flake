{
  description = "NixOS Flake for @tatupesonen configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    #sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    vscode-server,
    home-manager,
    deploy-rs,
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
      # VM host Nix modules
      vm =
        systemConfig "x86_64-linux"
        [
          ./hosts/vm/vm.nix
          ./modules/nixos/nvidia.nix
          ./modules/dev
          ./modules/misc/docker.nix
          ./modules/misc/vmware.nix
        ]
        # VM host home modules
        [
          ./modules/home/common
          ./modules/home/work
          ./modules/home/style
        ];
    };
  };
}
