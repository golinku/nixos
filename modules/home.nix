{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    discord
    tmux
    kitty
    brave
    firefox
    spotify
    zed-editor
    htop
    fastfetch
    tree
    bitwarden-cli
    gcc
    thunderbird
    remmina
    nerd-fonts.dejavu-sans-mono
    swaylock-effects #lock with screenshot of desktop
    swayidle
    mpv
    jq
    libinput
  ];

  home.sessionVariables = {
    GIT_COMPLETION_SCRIPT = "${pkgs.git}/share/git/contrib/completion/git-completion.bash";
    GIT_PROMPT_SCRIPT = "${pkgs.git}/share/bash-completion/completions/git-prompt.sh";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ne="nvim";
      # TODO bwo alias for script to unlock bw and export
    };
    # TODO have a way to pull scripts from Github for full automation
    initExtra = ''
      # Source Git completion and prompt scripts
      . $GIT_COMPLETION_SCRIPT 
      . $GIT_PROMPT_SCRIPT 
      source ~/.local/bin/prompt.sh

    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ -z "$NIRI_LOADED" ]; then
      export NIRI_LOADED=1
      if command -v niri &> /dev/null; then
          exec niri-session
      else
          exit 1
      fi
    fi   
    '';
  };
  # TODO pull all config folders from github

  programs.git = {
    enable = true;
    settings = {
      user.name = "golinku";
      credential.helper = "!~/.local/bin/git-credential-bw";
    };
  };

  # Idle service for screensaver and sleeping, script uses input group
  systemd.user.services.idle-orchestrator = {
    Unit = {
      Description = "Custom Idle Orchestrator (libinput-only idle detection)";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.local/bin/idle-orchestrator.sh";
      Restart = "on-failure";
      RestartSec = 2;

      # Make sure it inherits your session environment
      Environment = "PATH=/home/aaron/.local/bin:/etc/profiles/per-user/aaron/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin";
      PassEnvironment = [ "WAYLAND_DISPLAY" "XDG_RUNTIME_DIR" "DISPLAY" "DBUS_SESSION_BUS_ADDRESS" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

# bashrc, tmux config, kitty config, prompt config, git files for prompt, nvim config
  # Optional: Import dotfiles from Git
  # home.file.".config/nvim/init.lua".source = builtins.fetchGit {
  #   url = "https://github.com/yourusername/your-dotfiles";
  #   rev = "commit-or-branch";
  # } + "/nvim/init.lua";

  home.stateVersion = "25.05";
}
