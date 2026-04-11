{den, ...}: {
  den.aspects.hm-programs = {
    includes = [
      den.aspects.hm-shell
    ];

    homeManager = _: {
      # Preserve user's custom tmux theme — disable stylix's tmux target
      stylix.targets.tmux.enable = false;

      # Dark window decorations for GTK CSD apps
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
