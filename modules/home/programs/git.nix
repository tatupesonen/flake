{
  config,
  pkgs,
  ...
}: {
  programs.git.enable = true;
  programs.git = {
  userName  = "Tatu Pesonen";
    userEmail = "tatu@narigon.dev";
	};
}
