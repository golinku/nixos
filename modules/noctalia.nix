{ pkgs, noctalia, ... }:
{
  # install package
  environment.systemPackages = with pkgs; [
    quickshell
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
