{
  description = "Personal NixOS Flake Configuration";

  nixConfig = {
    trusted-substituters = [
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Use Home-Manger for dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cosmic
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust Overlay
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Discord Overlay
    discord-overlay.url = "github:InternetUnexplorer/discord-overlay";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-cosmic, rust-overlay, discord-overlay, ... }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./profiles {
          inherit system nixpkgs home-manager rust-overlay discord-overlay;
        }
      );

      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs inputs system nixos-cosmic;
        }
      );
    };
}
