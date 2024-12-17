{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # need clang for linking
    clang
  ];
}
