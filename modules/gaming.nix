{ config, pkgs, ... }:

{
  # Install Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    xivlauncher
    xpad
  ];
}
