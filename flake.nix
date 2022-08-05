{
  description = "Personal NixOS Flake Configuration";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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

    # Rust Overlay
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, rust-overlay, ... }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./profiles {
          inherit system nixpkgs home-manager rust-overlay;
        }
      );

      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs inputs system;
        }
      );
    };
}
