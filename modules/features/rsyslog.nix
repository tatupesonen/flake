_: {
  flake.nixosModules.rsyslog = {pkgs, ...}: {
    services.rsyslogd.enable = true;
    services.rsyslogd.extraConfig = ''
      *.*  @127.0.0.1:8002
      *.* /var/log/all.log
    '';
    environment.systemPackages = with pkgs; [rsyslog];
  };
}
