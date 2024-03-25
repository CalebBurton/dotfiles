# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Don't add any github repos here, they need to be put in the flake inputs

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Turn on flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # # Home Manager settings
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;

  # Define the hostname
  networking.hostName = "f16";

  # Enable networking
  networking.networkmanager.enable = true;
  # DNS queries use tailscale first, then Cloudflare
  networking.nameservers = [ "100.100.100.100" "1.1.1.1" ];
  # Use tailscale magicDNS names
  networking.search = [ "capybara-castor.ts.net" ];

  # Set the regulatory domain so WiFi isn't throttled
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  hardware.enableAllFirmware = true;

  # Configure internationalization properties
  time.timeZone = "America/New_York";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Fixes non-Qt apps (like Firefox) running in wayland
  programs.dconf.enable = true;
  # Set Firefox as the default browser
  xdg.mime.enable = true;
  xdg.mime.addedAssociations = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;

  # Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";

  # For use with RDP (see below)
  services.xrdp.defaultWindowManager = "startplasma-x11";

  ###############################
  ###############################

  # # Enable GNOME (doesn't work with xrdp)
  # services.xserver.displayManager.gdm.autoSuspend = false;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xrdp.defaultWindowManager = "gnome-session";

  # # Enable XFCE
  # services.xserver.displayManager.gdm.autoSuspend = false;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xrdp.defaultWindowManager = "xfce4-session";

  ###############################
  ###############################
  # XRDP server

  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  ###############################
  ###############################

  security.pam.services.login.fprintAuth = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable support for Bluetooth
  hardware.bluetooth.enable = true;
  # Power up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      # Showing the battery % of connected devices is experimental
      Experimental = true;
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs ={
    config = {
      # Required by github-desktop
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];

      # Supposed to be managed in the flake now... but apparently it's not?
      allowUnfree = true;
    };

    overlays = [
      # # Sweet Home 3D
      # (final: prev: {
      #   sweethome3d-patched = prev.sweethome3d.application.overrideAttrs {
      #     env.ANT_ARGS = "-DappletClassSource=8 -DappletClassTarget=8 -DclassSource=8 -DclassTarget=8";
      #   };
      # })

      # Temporary fix until https://github.com/NixOS/nixpkgs/pull/298491 is in unstable
      (final: prev: {
        fprintd = prev.fprintd.overrideAttrs (_: {
          mesonCheckFlags = [
            "--no-suite" "fprintd:TestPamFprintd"
          ];
        });
      })
    ];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cburton = {
    isNormalUser = true;
    description = "Caleb Burton";
    extraGroups = [
      "docker"
      "lp" # Grants acess to printer/scanners
      "networkmanager"
      "scanner" # Grants acess to scanners
      "vboxusers" # Grants access to virtualbox
      "wheel"
    ];
    packages = with pkgs; [
      audacity
      # cyberduck -- macos/windows only
      docker
      firefox
      github-desktop
      gimp
      # gimp-with-plugins
      google-chrome
      # handbrake
      inkscape-with-extensions
      kdePackages.filelight # Disk usage visualizer
      kdePackages.kdenlive
      kdePackages.plasma-nm # Network manager
      kdePackages.skanpage
      krita
      ktailctl
      libreoffice
      nextcloud-client
      pdfarranger
      protonmail-bridge
      protonvpn-gui
      qbittorrent
      realvnc-vnc-viewer
      # rustdesk
      signal-desktop
      spotify
      sweethome3d.application # Excludes the textures and furniture editors
      thunderbird
      tor-browser-bundle-bin
      vlc
      # See https://nixos.wiki/wiki/Visual_Studio_Code
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix # Nix syntax highlighting
          # yzane.markdown-pdf # md -> pdf
        ];  # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #   {
        #     name = "markdown-pdf";
        #     publisher = "yzane";
        #     version = "1.5.0";
        #     sha256 = "499e0247c2a3198232b2e0111839877291566af79ba8020185a956791aa1f42f";
        #     # Get this from python:
        #     # import base64
        #     # text = b'SZ4CR8KjGYIysuARGDmHcpFWavebqAIBhalWeRqh9C8='
        #     # print(base64.decodebytes(text).hex())
        #   }
        # ];
      })
      warp-terminal
      # # WINE >>>
      # wineWowPackages.stable # support both 32- and 64-bit applications
      # # wine # support 32-bit only
      # # (wine.override { wineBuild = "wine64"; }) # support 64-bit only
      # # wine64 # support 64-bit only
      # wineWowPackages.staging # wine-staging (version with experimental features)
      # winetricks # Additional DLLs needed for some software to work with WINE
      # wineWowPackages.waylandFull # native wayland support (unstable)
      # # <<< WINE
      yt-dlp
      zoom-us
    ];
  };

  # Set VS Code to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List packages installed in system profile. To search (e.g. for wget), run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    awscli
    ffmpeg
    git
    gparted # For partitioning drives (GUI version)
    # home-manager
    killall
    libnatpmp # Allows using Bonjour
    lsof
    man
    nmap
    parted # For partioning drives (CLI version)
    python312
    python312Packages.pip
    s3fs
    tailscale
    tesseract # OCR
    unzip
    vim
    zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Docker daemon
  virtualisation.docker.enable = true;

  # Virtualbox: https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;

  programs = {
    # See https://linuxhint.com/how-to-instal-steam-on-nixos/
    steam.enable = true;
    kdeconnect.enable = true;
  };

  # Enable support for SANE scanners
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.hplipWithPlugin # HP
      pkgs.sane-airscan # Various
    ];
    # If escl is enabled some scanners will show up multiple times
    disabledDefaultBackends = [ "escl" ];
  };

  services = {

    # Enable CUPS to print documents
    printing = {
      enable = true;
      drivers = [
        pkgs.hplipWithPlugin # HP
        pkgs.brlaser # Brother
        pkgs.gutenprint # Various
        pkgs.gutenprintBin # Various
      ];
      # # Share with entire network
      # listenAddresses = [ "*:631" ];
      # allowFrom = [ "all" ];
      # browsing = true;
      # defaultShared = true;
      # openFirewall = true;
      # # /Sharing
    };
    # Enable IPP everywhere printers (Apple compatible WiFi printers)
    avahi = {
      enable = true;
      # nssmdns = true; # Renamed in 24.05
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    # Allow printing over USB
    ipp-usb.enable=true;

    # Until TLP is supported -- Or forever? Might be the preferred AMD option.
    power-profiles-daemon.enable = true;

    # # TLP battery manager -- not recommended for AMD?
    # tlp = {
    #   enable = true;
    #   settings = {$ iw reg get
    #     # # BAT0 doesn't show up in `/sys/class/power_supply/` but including it anyway
    #     # START_CHARGE_THRESH_BAT0=75;
    #     # STOP_CHARGE_THRESH_BAT0=80;

    #     START_CHARGE_THRESH_BAT1=75;
    #     STOP_CHARGE_THRESH_BAT1=80;
    #   };
    # };

    tailscale.enable = true;

    # For firmware updates. To apply updates, run:
    #   fwupdmgr refresh
    #   fwupdmgr get-updates
    #   sudo fwupdmgr update
    fwupd = {
      enable = true;
      # extraRemotes = [
      #   "lvfs-testing" # Careful with this... might not be good for AMD
      # ];
    };

    # Fingerprint reader. Run sudo fprintd-enroll to actually enroll fingerprints
    fprintd = {
      enable = true;
      # tod = {
      #   enable = true;
      #   driver = pkgs.libfprint-2-tod1-goodix;
      #   # driver = pkgs.libfprint-2-tod1-goodix-550a;
      # };

      # # Semi-permanent fix for https://github.com/NixOS/nixpkgs/issues/298150
      # package = pkgs.fprintd.overrideAttrs {
      #   mesonCheckFlags = [
      #     "--no-suite"
      #     "fprintd:TestPamFprintd"
      #   ];
      # };
    };


    #   openssh = {
    #     enable = true;
    #     # set these to false to require public key authentication for better security
    #     settings.PasswordAuthentication = true;
    #     settings.KbdInteractiveAuthentication = true;
    #   };
  };

  # users.users."user".openssh.authorizedKeys.keyFiles = [
  #   /etc/nixos/ssh/authorized_keys
  # ];

  # # Open ports in the firewall.
  # networking.firewall = { 
  #   enable = true;
  #   allowedTCPPortRanges = [ 
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];  
  #   allowedUDPPortRanges = [ 
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];  
  # };  
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

