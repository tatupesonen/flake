{den, ...}: {
  den.aspects.hm-programs = {
    includes = [
      den.aspects.hm-shell
    ];

    homeManager = {...}: {
      # Preserve user's custom tmux theme — disable stylix's tmux target
      stylix.targets.tmux.enable = false;

      # Alacritty — colors handled by stylix
      programs.alacritty = {
        enable = true;
        settings.window.padding = {
          x = 5;
          y = 0;
        };
      };
    };
  };
}
