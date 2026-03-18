{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Install Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    xivlauncher
    xpad
    lsfg-vk
  ];
}
