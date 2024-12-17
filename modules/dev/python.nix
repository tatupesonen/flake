{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python312Full
    python312Packages.pip
    python312Packages.virtualenv
  ];
}
