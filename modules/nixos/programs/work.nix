_: {
  den.aspects.work = {
    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = ["tatu"];
      };

      services.tailscale.enable = true;
      # Required by Tailscale for asymmetric routing
      networking.firewall.checkReversePath = "loose";

      environment.systemPackages = with pkgs; [
        vscode.fhs
        ansible
        slack
        dbeaver-bin
        jetbrains.phpstorm
        k9s
        kubectl
        kubernetes-helm
        kustomize
        (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      ];

      environment.etc."current-system-packages".text = let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      in
        builtins.concatStringsSep "\n" sortedUnique;
    };
  };
}
