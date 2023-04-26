{ config, lib, pkgs, stdenv, ... }:

let
  inherit (pkgs.vscode-utils) extensionsFromVscodeMarketplace;
in
{
  # Enable using fonts specified by Home-Manager
  fonts.fontconfig.enable = true;

  programs = {
    # Enable Home-Manager
    home-manager.enable = true;

    # ZSH Shell
    zsh = {
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
          src = lib.cleanSource ../configs/p10k-config;
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

    # Nicer shell history search
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Basic Git settings
    git = {
      enable = true;
      userName = "netpalm555";
      userEmail = "netpalm555@gmail.com";
    };

    # Nicer cat alternative
    bat = {
      enable = true;
    };

    # GPU accelerated terminal
    wezterm = {
      enable = true;
    };

    # Code editor with a bunch of extensions
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        jnoortheen.nix-ide
        pkief.material-icon-theme
        zhuangtongfa.material-theme
        rust-lang.rust-analyzer
        asciidoctor.asciidoctor-vscode
        sumneko.lua
      ] ++ extensionsFromVscodeMarketplace [
      ];
    };
  };

  # Packages that don't require extra configuration
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
      ferdium
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
      heroic
      (pkgs.nerdfonts.override {
        fonts = [ "Hasklig" "JetBrainsMono" ];
      })
    ];

  home.file."jdks/openjdk8".source = pkgs.jdk8;
  home.file."jdks/openjdk17".source = pkgs.jdk17;

  xdg.configFile."wezterm/" = {
    source = ../configs/wezterm;
    recursive = true;
  };
}
