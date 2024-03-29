{ system, nixpkgs, home-manager, rust-overlay, discord-overlay, ... }:

let
  username = "npalmer";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      discord-overlay.overlay
      rust-overlay.overlays.default
    ];

    config.allowUnfree = true;
    configs.xdg.configHome = configHome;
  };

  mkHome = conf: (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;

      modules = [
        conf
        {
          home = {
            inherit username homeDirectory;
            stateVersion = "22.05";
          };
        }
      ];
    }
  );

  desktopConf = import ./desktop {
    inherit system pkgs;
    inherit (pkgs) config lib stdenv;
  };

  laptopConf = import ./laptop {
    inherit system pkgs;
    inherit (pkgs) config lib stdenv;
  };
in
{
  npalmer-desktop = mkHome desktopConf;
  npalmer-laptop = mkHome laptopConf;
}
