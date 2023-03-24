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
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # GUI Setup
  services.xserver = {
    # Enable X11 windowing system
    enable = true;

    # Set X11 keymap
    layout = "us";
    xkbVariant = "";

    # Enable KDE Plasma Desktop Enviornment
    displayManager.sddm.enable = true;
    displayManager.sddm.autoNumlock = true;
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
    jack.enable = true;
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
      extraGroups = [ "networkmanager" "wheel" "davfs2" ];
    };
  };

  nix = {
    # Nix Package Manager settings
    settings = {
      # Optimise syslinks
      auto-optimise-store = true;
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Enable nixFlakes on system
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

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

  # Add Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Games SMB Share
  # fileSystems."/opt/games_share" = {
  #   device = "//192.168.1.100/games";
  #   fsType = "cifs";
  #   options =
  #     let
  #       # this line prevents hanging on network split
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,nofail,_netdev";
  #     in
  #     [ "${automount_opts},credentials=/etc/nixos/smb-secrets,rw,user,users,auto,exec,uid=npalmer,gid=100" ];
  # };
  services.rpcbind.enable = true;

  environment.systemPackages = with pkgs; [ nfs-utils proton-ge-custom ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeBinPath [ proton-ge-custom ];
  };

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


  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "192.168.1.100:/mnt/user/games";
    where = "/opt/games_share";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "600";
    };
    where = "/opt/games_share";
  }];

  # Nextcloud WebDAV
  services.davfs2.enable = true;
  fileSystems."/mnt/nextcloud" = {
    device = "https://nc.netpalm.tk/remote.php/dav/files/npalmer";
    fsType = "davfs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},uid=1000" ];
  };
}
