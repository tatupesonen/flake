_: let
  noctaliaSettings = (builtins.fromJSON (builtins.readFile ../../nixos/services/noctalia.json)).settings;
in {
  den.aspects.hm-noctalia.homeManager = {config, ...}: {
    programs.noctalia-shell = {
      enable = true;
      settings = noctaliaSettings;
    };

    home.file."Pictures/Wallpapers/wallpaper.jpg".source = ../../nixos/services/wallpaper.jpg;

    home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
      defaultWallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/wallpaper.jpg";
    };
  };
}
