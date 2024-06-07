#
# This adds all of the host profiles for nixOS
#

{ nixpkgs, inputs, system, nixos-cosmic, ... }:

let
  pkgs = import nixpkgs {
    inherit system;

    # Allow proprietary software
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
    };
    modules = [
      {
        nix.settings = {
          substituters = [ "https://cosmic.cachix.org/" ];
          trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
        };
      }
      nixos-cosmic.nixosModules.default
      ./desktop
    ];
  };
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
    };
    modules = [
      ./laptop
    ];
  };
}
