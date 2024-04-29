# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Don't add any github repos here, they need to be flake inputs

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

  networking = {
    # Define the hostname
    hostName = "f16";

    # Enable networking
    networkmanager.enable = true;

    # DNS queries use tailscale first, then Cloudflare
    nameservers = [ "100.100.100.100" "1.1.1.1" ];

    # Use tailscale magicDNS names
    search = [ "capybara-castor.ts.net" ];

    # IPv6 messes up everything...
    enableIPv6 = false;

    firewall = {
      # Open ports in the firewall.
      # enable = true;
      # allowedTCPPortRanges = [
      #   { from = 1714; to = 1764; } # KDE Connect
      # ];
      # allowedUDPPortRanges = [
      #   { from = 1714; to = 1764; } # KDE Connect
      # ];
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];

      # Or disable the firewall altogether.
      enable = false;
    };
  };

  # Set the regulatory domain so WiFi isn't throttled
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  # TODO: Bump up the TTL
  # https://infosec.exchange/@briankrebs/111434555426146154
  # sudo sysctl -w net.ipv4.ip_default_ttl=65

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
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";

  # Plasma 6
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # Any default KDE packages that should be skipped
  ];

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
    libinput.touchpad.disableWhileTyping = true;
  };

  # Enable support for Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        # Showing the battery % of connected devices is experimental
        Experimental = true;
      };
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

    # use the example session manager (no others are packaged yet so this is
    # enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs = {
    config = {
      # Required by github-desktop
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
      allowUnfree = true;
    };

    overlays = [
      # # Sweet Home 3D
      # (final: prev: {
      #   sweethome3d-patched = prev.sweethome3d.application.overrideAttrs {
      #     env.ANT_ARGS = "-DappletClassSource=8 -DappletClassTarget=8 -DclassSource=8 -DclassTarget=8";
      #   };
      # })

      # Pin chromium so it matches the path the markdownpdf vscode extension is
      # configured to use.
      # See https://lazamar.co.uk/nix-versions/?package=chromium for all
      # available versions.
      (final: prev: {
          chromium-pinned = prev.chromium.overrideAttrs (old: {
            src = builtins.fetchTarball {
              url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
              sha256 = "1q2fn8szx99narznglglsdpc6c4fj1mhrl42ig02abjqfikl723i";
            };
            # src = prev.fetchFromGitHub {
            #   owner = "NixOS";
            #   repo = "nixpkgs";
            #   rev = "336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
            #   sha256 = "";
            # };
          });
      })

      # Temporary fix until https://github.com/NixOS/nixpkgs/pull/298491 is
      # packaged in unstable
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
    name = "cburton";
    home = "/home/cburton";
    group = "users";
    extraGroups = [
      "docker"
      "lp" # Grants acess to printer/scanners
      "networkmanager"
      "scanner" # Grants acess to scanners
      "vboxusers" # Grants access to virtualbox
      "wheel"
    ];
    # MARK: User Packages
    packages = with pkgs; [
      audacity
      # chromium
      chromium-pinned
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
      krename # File renaming tool
      krita
      ktailctl
      libreoffice
      nextcloud-client
      pdfarranger
      protonmail-bridge
      protonvpn-gui # Turn this off once the erosanix version is usable
      qbittorrent
      # realvnc-vnc-viewer # Broken as of 4/6/24
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
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # Run the `get_sha` alias to get the correct sha256 value
          {
            # Sieve syntax highlighting
            name = "vscode-sievehighlight";
            publisher = "adzero";
            version = "1.0.6";
            sha256 = "f0e9a9bfbf76788da4207fb9f8a3cbf6301ff3cc6c30641ec07110c22f018684";
          }
          {
            # Markdown to PDF converter
            name = "markdown-pdf";
            publisher = "yzane";
            version = "1.5.0";
            sha256 = "6a289f6601d70b819411b90a01b2dcd29fe3519c69d6317f27563f288caf2c81";
          }
        ];
      })
      warp-terminal
      whatsapp-for-linux
      # # WINE >>>
      # wineWowPackages.stable # support both 32- and 64-bit applications
      # # wine # support 32-bit only
      # # (wine.override { wineBuild = "wine64"; }) # support 64-bit only
      # # wine64 # support 64-bit only
      # wineWowPackages.staging # wine-staging (version with experimental features)
      # winetricks # Additional DLLs needed for some software to work with WINE
      # wineWowPackages.waylandFull # native wayland support (unstable)
      # # <<< WINE
      # Allows non-Qt apps (like Firefox) to use native tools like the file picker
      xdg-desktop-portal # Not sure if this is really needed, but doesn't hurt
      yt-dlp
      zoom-us
    # ] ++ [
    #   pkgs23_11.chromium
    ];
  };

  # Set VS Code to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # MARK: System Packages
  # List packages installed in system profile. To search (e.g. for wget), run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    awscli
    bitwarden-cli
    ffmpeg
    git
    gnome.gucharmap # Unicode symbol selector
    gparted # For partitioning drives (GUI version)
    # home-manager
    jq
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

  # # Use zsh as the default shell. Additional config below.
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [
    bashInteractive
    # regular `sh` is included by default
    zsh
  ];

  programs = {
    # See https://linuxhint.com/how-to-instal-steam-on-nixos/
    steam.enable = true;
    kdeconnect.enable = true;

    zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        # See https://linux.die.net/man/1/zshoptions
        setOptions = [
          "AUTO_CD" # Allow omitting `cd` when trying to change directories
          "AUTO_PUSHD" # `cd` is silently replaced with `pushd`
          "EXTENDED_HISTORY" # Save timestamp with each history entry

          # nixOS Defaults
          "HIST_IGNORE_DUPS" # Don't save a history entry if it's already in the history file
          "SHARE_HISTORY" # Write each shell's history to the file when it exits
          # ^ Replace with INC_APPEND_HISTORY to write each line immediately instead
          "HIST_FCNTL_LOCK" # Improves performance when writing to history
        ];
        histSize = 10000;
        # initExtra = builtins.readFile(../../../aliases.zsh);

        ohMyZsh = {
            enable = true;
            plugins = [
                "git"
                "z"
            ];
            # theme = "robbyrussell";
        };
    };
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

    # AMD has better battery life with PPD over TLP:
    # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
    power-profiles-daemon.enable = true;

    # # TLP battery manager -- not recommended for AMD
    # tlp = {
    #   enable = true;
    #   settings = {$ iw reg get
    #     # # BAT0 doesn't show up in `/sys/class/power_supply/`...
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
    };

    # Fingerprint reader. Run sudo fprintd-enroll to enroll fingerprints
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
    #     # set these to false to require key auth for better security
    #     settings.PasswordAuthentication = true;
    #     settings.KbdInteractiveAuthentication = true;
    #   };

    # protonvpn = {
    #   enable = true;
    #   autostart = true;

    #   interface = {
    #     # The name of the Wireguard network interface to create. Go to
    #     # https://account.protonmail.com/u/0/vpn/WireGuard to create a Linux
    #     # Wireguard certificate and download it. You'll need it's content to
    #     # set the options for this module.
    #     name = "protonvpn";

    #     # The IP address of the interface. See your Wireguard certificate.
    #     ip = "10.2.0.2/32";

    #     # The port number of the interface
    #     port = 51820;

    #     # The path to a file containing the private key for this interface.
    #     # Only root should have access to the file. See your Wireguard
    #     # certificate.
    #     privateKeyFile = "/root/secrets/protonvpn";

    #     # Enable the DNS provided by the VPN
    #     dns = true;

    #     # The IP address of the DNS provider. See your Wireguard certificate.
    #     ip = "10.2.0.1";
    #   };
    # };

  };

  # users.users."user".openssh.authorizedKeys.keyFiles = [
  #   /etc/nixos/ssh/authorized_keys
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

