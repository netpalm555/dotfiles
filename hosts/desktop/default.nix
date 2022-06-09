# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader = {
    # Use systemd-boot
    systemd-boot.enable = true;

    # EFI settings
    efi = {
      # Enable the modification of EFI boot variables
      canTouchEfiVariables = true;

      # Set mount point of EFI System Partition
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Networking
  networking = {
    # Set hostname
    hostName = "npalmer-nixos-tower";

    # Use network manager for networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # GUI Setup
  services.xserver = {
    # Enable X11 windowing system
    enable = true;

    # Set X11 keymap
    layout = "us";
    xkbVariant = "";

    # Enable KDE Plasma Desktop Enviornment
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Accounts
  users = {
    # Set default shell to ZSH
    defaultUserShell = pkgs.zsh;

    # Create User Account
    users.npalmer = {
      # Non-root user
      isNormalUser = true;

      # User Account Description
      description = "Nathan Palmer";

      # Allow to change network settings and use sudo
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Set a higher DPI so everything isn't quite so large
  services.xserver.dpi = 96;

  # Create X11 font directory so VSCode can find new fonts
  # https://nixos.wiki/wiki/Fonts#What_font_names_can_be_used_in_fonts.fontconfig.defaultFonts.monospace.3F
  fonts.fontDir.enable = true;
}
