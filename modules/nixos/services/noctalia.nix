{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      pkgs = pkgs.extend (_: _: {noctalia-shell = inputs.noctalia.packages.${pkgs.system}.default;});
      inherit
        ((builtins.fromJSON
          (builtins.readFile ./noctalia.json)))
        settings
        ;
    };
  };

  den.aspects.noctalia-shell = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.system}.myNoctalia
      ];
      services.upower.enable = true;

      # Make wallpaper available system-wide
      environment.etc."noctalia/wallpaper.jpg".source = ./wallpaper.jpg;

      environment.etc."noctalia/avatar.png".source = ./avatar.png;

      # Symlink wallpaper and avatar into user homes
      system.activationScripts.noctalia-wallpaper = ''
        for home in /home/*/; do
          user="$(basename "$home")"
          dir="$home/Pictures/Wallpapers"
          mkdir -p "$dir"
          ln -sf /etc/noctalia/wallpaper.jpg "$dir/wallpaper.jpg"
          ln -sf /etc/noctalia/avatar.png "$home/.face"
          chown -R "$user" "$home/Pictures"
          chown "$user" "$home/.face"
        done
      '';
    };
  };
}
