{ config, lib, pkgs, ... }:

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
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    # Use powerlevel10k theme
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  programs = {
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        jnoortheen.nix-ide
        pkief.material-icon-theme
        zhuangtongfa.material-theme
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    firefox
    discord
    google-chrome
    wezterm
    plasma-browser-integration
    nixpkgs-fmt
    ripgrep
    zsh-powerlevel10k
    git
    (pkgs.nerdfonts.override {
      fonts = [ Hasklug JetBrainsMono ];
    })
  ];
}
