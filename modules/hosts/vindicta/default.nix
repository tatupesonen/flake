{self, ...}: {
  flake.nixosConfigurations.vindicta = self.lib.mkHost {
    modules = [
      self.nixosModules.vindictaHardware
      self.nixosModules.system
      self.nixosModules.sshAgent
      self.nixosModules.pipewire
      self.nixosModules.mysql
      self.nixosModules.rsyslog
      self.nixosModules.devPackages
      self.nixosModules.devLanguages
      self.nixosModules.plasma
      self.nixosModules.docker
      self.nixosModules.work
      self.nixosModules.nixvim
      self.nixosModules.homeBase
      ({pkgs, ...}: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "vindicta";
        networking.networkmanager.enable = true;

        services.xserver.enable = true;
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        programs.firefox.enable = true;
        environment.systemPackages = with pkgs; [vim];

        home-manager.users.tatu.imports = [
          self.homeManagerModules.git
          self.homeManagerModules.fzf
          self.homeManagerModules.tmux
          self.homeManagerModules.zsh
          self.homeManagerModules.alacritty
          self.homeManagerModules.vscode
          self.homeManagerModules.bg
        ];
      })
    ];
  };
}
