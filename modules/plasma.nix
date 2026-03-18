# Nixos configuration for plasma KDE 

{ config, pkgs, ... }:

{
  # Enable SDDM display manager and plasma DE.
  services.displayManager.sddm = {
    enable = true;
  };
  services.desktopManager.plasma6.enable = true;
 
  environment.systemPackages = with pkgs; [
    kdePackages.kate
  ];
}

