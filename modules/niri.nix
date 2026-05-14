{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # commented out because we're running noctalia
    # fuzzel
    # waybar
    # mako
    networkmanager
    # pywal
    # killall # pywal needs it, though its not listed
    feh
    # swaybg
    kdePackages.dolphin
    xwayland-satellite #needed for x11 apps, disc steam
    # playerctl
  ];

}

