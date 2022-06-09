{ system, nixpkgs, home-manager, ... }:

let
  username = "npalmer";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    configs.xdg.configHome = configHome;
  };

  mkHome = conf: (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs system username homeDirectory;

      stateVersion = "22.05";
      configuration = conf;
    }
  );

  desktopConf = import ./desktop {
    inherit pkgs;
    inherit (pkgs) config lib stdenv;
  };
in
{
  npalmer-desktop = mkHome desktopConf;
}
