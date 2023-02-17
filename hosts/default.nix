#
# This adds all of the host profiles for nixOS
#

{ nixpkgs, inputs, system, ... }:

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