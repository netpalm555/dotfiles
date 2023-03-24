{ system, config, lib, pkgs, pkgs-stable, ... }:

let
  inherit (pkgs.vscode-utils) extensionsFromVscodeMarketplace;
in
{
  imports = [
    ../common.nix
  ];

  fonts.fontconfig.enable = true;

  # ZSH Shell
  programs.zsh = {
    # Enable ZSH
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    defaultKeymap = "emacs";

    history = {
      save = 1000;
      size = 1000;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../../configs/p10k-config;
        file = "p10k.zsh";
      }
    ];

    initExtra = ''
      ## Keybindings section
      bindkey -e
      bindkey '^[[7~' beginning-of-line                               # Home key
      bindkey '^[[H' beginning-of-line                                # Home key
      if [[ "''${terminfo[khome]}" != "" ]]; then
      bindkey "''${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
      fi
      bindkey '^[[8~' end-of-line                                     # End key
      bindkey '^[[F' end-of-line                                     # End key
      if [[ "''${terminfo[kend]}" != "" ]]; then
      bindkey "''${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
      fi
      bindkey '^[[2~' overwrite-mode                                  # Insert key
      bindkey '^[[3~' delete-char                                     # Delete key
      bindkey '^[[C'  forward-char                                    # Right key
      bindkey '^[[D'  backward-char                                   # Left key
      bindkey '^[[5~' history-beginning-search-backward               # Page up key
      bindkey '^[[6~' history-beginning-search-forward                # Page down key
      # Navigate words with ctrl+arrow keys
      bindkey '^[Oc' forward-word                                     #
      bindkey '^[Od' backward-word                                    #
      bindkey '^[[1;5D' backward-word                                 #
      bindkey '^[[1;5C' forward-word                                  #
      bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "netpalm555";
    userEmail = "netpalm555@gmail.com";
  };

  programs.bat = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    package = pkgs-stable.wezterm;
  };

  home.packages = with pkgs;
    [
      firefox
      discord
      google-chrome
      plasma-browser-integration
      nixpkgs-fmt
      ripgrep
      zsh-powerlevel10k
      git
      lutris
      exa
      zellij
      rust-bin.stable.latest.default
      qalculate-gtk
      htop
      prismlauncher
      ark
      kicad
      cura
      (pkgs.nerdfonts.override {
        fonts = [ "Hasklig" "JetBrainsMono" ];
      })
    ];

  home.file."jdks/openjdk8".source = pkgs.jdk8;
  home.file."jdks/openjdk17".source = pkgs.jdk17;

  xdg.configFile."wezterm/" = {
    source = ../../configs/wezterm;
    recursive = true;
  };
}
