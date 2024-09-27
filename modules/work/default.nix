{
  config,
  pkgs,
  userConfig,
  pkgs-unstable,
  ...
}: {
	programs._1password.enable = true;
	programs._1password-gui = {
		enable = true;
		polkitPolicyOwners = [ 
			"${userConfig.userName}"
		];
	};

	services.tailscale = {
		enable = true;
		package = pkgs-unstable.tailscale;
	};
	networking.firewall.checkReversePath = "loose";

	environment.systemPackages = with pkgs; [
		vscode.fhs
		ansible
		slack
	];
}
