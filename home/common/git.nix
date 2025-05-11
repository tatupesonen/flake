{userConfig, ...}: {
  #home.file.".ssh/allowed_signers".text = "${userConfig.userEmail} ${builtins.readFile /home/${userConfig.userName}/.ssh/id_ed25519.pub}";
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.userEmail;
  };
}
