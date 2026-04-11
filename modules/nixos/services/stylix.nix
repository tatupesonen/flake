_: {
  den.aspects.stylix.nixos = {pkgs, ...}: {
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";

      image = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1511300636408-a63a89df3482?w=3840&q=95";
        hash = "sha256-7absiQQronVA1L5ZKZQ/O75TBjm2D+5GVWAA5NNdMKY=";
      };

      base16Scheme = {
        base00 = "24283B";
        base01 = "414868";
        base02 = "4C5479";
        base03 = "565F89";
        base04 = "9AA5CE";
        base05 = "C0CAF5";
        base06 = "C0CAF5";
        base07 = "D5D6DB";
        base08 = "F7768E";
        base09 = "FF9E64";
        base0A = "E0AF68";
        base0B = "9ECE6A";
        base0C = "73DACA";
        base0D = "91BEF5";
        base0E = "BB9AF7";
        base0F = "2AC3DE";
      };

      fonts = {
        sansSerif = {
          package = pkgs.inter;
          name = "Inter Variable";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          terminal = 11;
          applications = 11;
        };
      };

      cursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
      };
    };

    # HM module is imported via den.default.homeManager, not auto-injected
    stylix.homeManagerIntegration.autoImport = false;
  };
}
