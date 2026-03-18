# Nixos configuration for hyprland compositor

{ config, pkgs, ... }:

{
  # Setup Hyprland
  programs.hyprland.enable = true;
 
  environment.systemPackages = with pkgs; [
    wofi
  ];
}
