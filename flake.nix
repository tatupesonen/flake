{
  description = "NixOS Flake for @tatupesonen configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = {
    nixpkgs,
    nixos-wsl,
    vscode-server,
    home-manager,
    nixpkgs-unstable,
    ...
  } @ inputs: {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    devShells = {
      x86_64-linux.default = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in
        pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nil
          ];
        };
    };
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
                {...}: {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      "${userConfig.userName}" = import ./home;
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
          ./modules/nixvim
        ]
        # WSL host home modules
        [./home/common];
      vindicta =
        systemConfig "x86_64-linux"
        [
          ./hosts/vindicta/configuration.nix
          ./modules/dev
          ./modules/misc/docker.nix
          ./modules/work
          ./modules/nixvim
        ]
        [
          ./home/common
          ./home/work
          ./home/style
        ];
      vm =
        systemConfig "x86_64-linux"
        [
          ./hosts/vm/vm.nix
          ./modules/dev
          ./modules/wm/plasma
          #./modules/demo/k9s.nix
          #./modules/demo/ssh.nix
          #./modules/demo/kuma.nix
          #./modules/misc/docker.nix
          #./modules/demo/reverse_proxy.nix
          ./modules/misc/vmware.nix
          ./modules/nixvim
        ]
        [
          ./home/common
          ./home/style
          ./home/work
        ];
    };
  };
}
