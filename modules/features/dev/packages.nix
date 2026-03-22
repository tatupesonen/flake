_: {
  flake.nixosModules.devPackages = {pkgs, ...}: {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      neofetch
      # archives
      zip
      xz
      unzip
      p7zip
      perf

      # utils
      ripgrep
      jq
      yq-go
      eza

      # networking tools
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

      # nix related
      nix-output-monitor

      # productivity
      glow

      btop
      iotop
      iftop

      # system call monitoring
      strace
      ltrace
      lsof
    ];
  };
}
