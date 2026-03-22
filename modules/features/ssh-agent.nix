_: {
  flake.nixosModules.sshAgent = _: {
    programs.ssh.startAgent = true;
  };
}
