{ system, nixpkgs, home-manager, rust-overlay, ... }:

let
  username = "npalmer";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
            };
          }
        );
      })
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
    inherit system pkgs rust-overlay;
    inherit (pkgs) config lib stdenv;
  };
in
{
  npalmer-desktop = mkHome desktopConf;
}
