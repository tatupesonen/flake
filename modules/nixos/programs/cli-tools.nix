{...}: {
  den.aspects.cli-tools.nixos = {pkgs, ...}: {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      neofetch

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep
      jq
      yq-go
      eza

      # networking
      mtr
      iperf3
      dnsutils
      ldns
      aria2
      socat
      nmap
      ipcalc

      # misc
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg

      # nix
      nix-output-monitor

      # monitoring
      btop
      iotop
      iftop

      # debugging
      strace
      ltrace
      lsof
    ];
  };
}
