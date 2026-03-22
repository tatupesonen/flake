{inputs, ...}: {
  flake.nixosModules.homeBase = {
    lib,
    userConfig,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${userConfig.userName} = {
        home = {
          username = userConfig.userName;
          homeDirectory = "/home/${userConfig.userName}";
          stateVersion = lib.mkDefault "24.05";
          sessionVariables.EDITOR = "nvim";
        };
        programs.home-manager.enable = true;
      };
      extraSpecialArgs = {
        inherit userConfig inputs;
      };
    };
  };
}
