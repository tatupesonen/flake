_: {
  den.aspects.ssh-agent.nixos = {
    programs.ssh.startAgent = true;
    # Disable GNOME's SSH agent to avoid conflict
    services.gnome.gcr-ssh-agent.enable = false;
  };
}
