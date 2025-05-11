{userConfig, ...}: {
  #home.file.".ssh/allowed_signers".text = "${userConfig.userEmail} ${builtins.readFile /home/${userConfig.userName}/.ssh/id_ed25519.pub}";
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.userEmail;

    extraConfig = {
      commit.gpgsign = true;
      #user.signingKey = "~/.ssh/id_ed25519.pub";
      gpg = {
        format = "ssh";
        #ssh = {
        #  allowedSignersFile = "~/.ssh/allowed_signers";
        #};
      };
    };
  };
}
