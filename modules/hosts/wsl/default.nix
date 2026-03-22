{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.wsl = self.lib.mkHost {
    modules = [
      self.nixosModules.system
      self.nixosModules.sshAgent
      self.nixosModules.rsyslog
      self.nixosModules.devPackages
      self.nixosModules.devLanguages
      self.nixosModules.nixvim
      self.nixosModules.homeBase
      ({userConfig, ...}: {
        imports = [
          inputs.nixos-wsl.nixosModules.wsl
          inputs.vscode-server.nixosModules.default
        ];

        services.vscode-server.enable = true;
        wsl = {
          enable = true;
          defaultUser = userConfig.userName;
          docker-desktop.enable = true;
          wslConf.interop.appendWindowsPath = true;
        };
        networking.hostName = "wsl";

        home-manager.users.tatu.imports = [
          self.homeManagerModules.git
          self.homeManagerModules.fzf
          self.homeManagerModules.tmux
          self.homeManagerModules.zsh
        ];
      })
    ];
  };
}
