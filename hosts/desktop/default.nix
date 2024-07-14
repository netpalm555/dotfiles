# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  proton-ge-custom = pkgs.callPackage ../../packages/proton-ge-custom { };
in
{
  imports =
    [
      # Shared config file
      ../common.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Networking
  networking = {
    # Set hostname
    hostName = "npalmer-nixos-tower";

    # Use network manager for networking
    networkmanager.enable = true;
  };

  # Enable setting necessary to get wayland working with Nvidia
  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  networking.firewall.allowedTCPPorts = [ 3389 ];

  services.openssh = {
    enable = true;
    extraConfig = ''
      PubkeyAcceptedAlgorithms=+ssh-rsa
      HostKeyAlgorithms +ssh-rsa
    '';
  };
}
