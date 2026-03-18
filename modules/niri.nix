{ config, pkgs, ... }:

{

  # Boot to TTY (no SDDM/LightDM)
  services.xserver.enable = false;
  services.displayManager.enable = false;

  # Wayland + Niri
  programs.niri.enable = true;

  # Ensure systemd user session is correct
  systemd.user.services.niri-session = {
    description = "Niri session";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.niri}/bin/niri --session";
      Restart = "on-failure";
    };
  };

  # Basic packages
  environment.systemPackages = with pkgs; [
    fuzzel
    waybar
  ];
}

