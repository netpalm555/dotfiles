{
  description = "Personal NixOS Flake Configuration";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  # Dependencies necessary for the flake
  inputs = {
    # Use NixOS Unstable as the base
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Use Home-Manger for dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./profiles {
          inherit system nixpkgs home-manager;
        }
      );

      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs inputs system;
        }
      );
    };
}
