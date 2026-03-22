{self, ...}: {
  flake.nixosConfigurations.vm = self.lib.mkHost {
    modules = [
      self.nixosModules.vmHardware
      self.nixosModules.system
      self.nixosModules.sshAgent
      self.nixosModules.pipewire
      self.nixosModules.rsyslog
      self.nixosModules.devPackages
      self.nixosModules.devLanguages
      self.nixosModules.plasma
      self.nixosModules.vmware
      self.nixosModules.nixvim
      self.nixosModules.homeBase
      ({
        pkgs,
        userConfig,
        ...
      }: {
        networking.hostName = "vm";
        boot.extraModprobeConfig = "options kvm_intel nested=1";

        services.xserver.enable = true;
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        virtualisation.libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
          };
        };

        users.users.${userConfig.userName}.packages = with pkgs; [
          firefox
          kdePackages.kate
        ];

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
