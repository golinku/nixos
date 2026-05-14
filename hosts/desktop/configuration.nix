#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2; # number of generations shown
  boot.loader.efi.canTouchEfiVariables = true;

  # Set CPU to Performance
  powerManagement.cpuFreqGovernor = "performance";

  # Garbage Collection on generations
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 45d";
  };

  # Set Hardware Clock to Local Time
  time.hardwareClockInLocalTime = true;

  # Network Setup
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Push locale to systemd
  systemd.settings.Manager.DefaultEnvironment = "LANG=en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Systemd service to pipe to headphones from Sampler capture
  systemd.user.services.headphones = {
    description = "Pipe sampler into headphones";
    after = [ "graphical-session.target" "pipewire.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      Environment = "PATH=/run/current-system/sw/bin";
      ExecStart = "${config.users.users.aaron.home}/.local/bin/headphones.sh";
    };
  };

  # Create groups
  users.groups.realtime = {}; # Needed for realtime audio
  users.groups.i2c = {}; #For monitor control
  users.groups.plugdev = {}; #For usb cam access

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aaron = {
    isNormalUser = true;
    description = "aaron";
    extraGroups = [ "networkmanager" "wheel" "realtime" "i2c" "plugdev" "video" "input"];
    packages = with pkgs; [
      ddcutil
      ffmpeg
      pulseaudio
      pavucontrol
    ];
  };

  # PAM permissions to run audio threads up to 95
  security.pam.loginLimits = [
    { domain = "@realtime"; type = "hard"; item = "rtprio"; value = "95"; }
    { domain = "@realtime"; type = "soft"; item = "rtprio"; value = "95"; }
  ];

  # Install goxlr utility
  services.goxlr-utility.enable = true;

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.xpadneo
    crosspipe
    streamcontroller
  ];

  # List services that you want to enable:

  systemd.user.services.streamcontroller = {
    description = "StreamController Autostart";
    # starting before pactl
    after = [ "graphical-session.target" "pipewire-pulse.service" ];
    wants = [ "pipewire-pulse.service" ];
    wantedBy = [ "default.target" ];  

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.streamcontroller}/bin/streamcontroller";
      Restart = "on-failure";
      RestartSec = 2;
      StandardOutput = "null";
      StandardError = "null";
    };
  };

  # Additonal UDEV Rules
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", ATTR{idProduct}=="0002", MODE="0660", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="082d", MODE="0660", GROUP="plugdev"
  '';

  # Additional security Rules

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
