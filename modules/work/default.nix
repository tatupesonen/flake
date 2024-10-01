{
  config,
  pkgs,
  userConfig,
  lib,
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
    dbeaver-bin
    jetbrains.phpstorm
    k9s
    kubectl
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
  ];

  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;

    sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);

    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
}
