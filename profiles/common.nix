{ config, lib, pkgs, stdenv, ... }:

let
  inherit (pkgs.vscode-utils) extensionsFromVscodeMarketplace;
in
{
  programs = {
    home-manager.enable = true;

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        jnoortheen.nix-ide
        pkief.material-icon-theme
        zhuangtongfa.material-theme
        rust-lang.rust-analyzer
        asciidoctor.asciidoctor-vscode
      ] ++ extensionsFromVscodeMarketplace [
        {
          name = "lua";
          publisher = "sumneko";
          version = "3.2.5";
          sha256 = "sha256-hCmIRlo1lf+cNlldY7feLvJ3P14c+uICHgHgWr9neQE=";
        }
      ];
    };
  };
}
