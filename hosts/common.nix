{ config, pkgs, lib, ... }:
let
  proton-ge-custom = pkgs.callPackage ../packages/proton-ge-custom { };
in
{

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
  services = {
    xserver = {
      # Enable X11 windowing system
      enable = true;

      # Set X11 keymap
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable KDE Plasma Desktop Enviornment
    # displayManager.cosmic-greeter.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.autoNumlock = true;
    desktopManager.plasma6.enable = true;
    desktopManager.cosmic.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable ZSH here so we can set it as the default shell
  programs.zsh.enable = true;

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

  # Allow unfree packages (for nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Set vidio driver to nvidia
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

  services.rpcbind.enable = true;

  environment = {
    systemPackages = with pkgs; [ nfs-utils proton-ge-custom ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeBinPath [ proton-ge-custom ];
      NIXOS_OZONE_WL = "1";
    };
  };

  boot = {
    initrd = {
      supportedFilesystems = [ "nfs" ];
      kernelModules = [ "nfs" ];
    };

    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
    '';

    kernelParams = [ "nvidia_drm.fbdev=1" ];
  };

  systemd = {
    mounts = [{
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "192.168.1.100:/mnt/user/games";
      where = "/opt/games_share";
    }];

    automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/opt/games_share";
    }];
  };
}

