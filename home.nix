{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    discord
    tmux
    kitty
    brave
    spotify
    zed-editor
    htop
    neofetch
    tree
    bitwarden-cli
    gcc
  ];

  home.sessionVariables = {
    GIT_COMPLETION_SCRIPT = "${pkgs.git}/share/git/contrib/completion/git-completion.bash";
    GIT_PROMPT_SCRIPT = "${pkgs.git}/share/bash-completion/completions/git-prompt.sh";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ne="nvim";
    };
    initExtra = ''
      # Source Git completion and prompt scripts
      . $GIT_COMPLETION_SCRIPT 
      . $GIT_PROMPT_SCRIPT 
      source ~/.local/bin/prompt.sh
    '';
  };

  programs.git = {
    enable = true;
    userName = "golinku";
    extraConfig = {
      credential.helper = "!~/.local/bin/git-credential-bw";
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
