{ config, pkgs, ... }:

{
  # Enable Flatpak system service
  services.flatpak.enable = true;

  # Enable portals so Flatpak apps integrate with your desktop
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Declarative Flatpak installs
  system.activationScripts.flatpakApps.text = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ${pkgs.flatpak}/bin/flatpak install -y flathub com.spotify.Client
  '';
}
