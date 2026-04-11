{den, ...}: {
  den.aspects.desktop-base = {
    includes = [
      den.aspects.locale
      den.aspects.pipewire
      den.aspects.niri
      den.aspects.noctalia-shell
      den.aspects.stylix
      den.aspects.xdg-portal
      den.aspects.cli-tools
      den.aspects.browser
      den.aspects.ssh-agent
      den.aspects.hm-programs
    ];

    nixos = {
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;

      # GNOME Keyring for browser passwords, Signal, etc.
      services.gnome.gnome-keyring.enable = true;

      # USB auto-mounting
      services.udisks2.enable = true;
      services.gvfs.enable = true;
    };
  };
}
