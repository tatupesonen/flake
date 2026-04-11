{...}: {
  den.aspects.hm-alacritty.homeManager = {
    programs.alacritty = {
      enable = true;
      settings.window.padding = {
        x = 5;
        y = 0;
      };
    };
  };
}
