# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Don't add any github repos here, those need to be flake inputs
      ./hardware-configuration.nix # Results of the automatic hardware scan
      ./packages.nix
      ./shell.nix
    ];

  # Turn on flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Here's the syntax for downgrading the kernel, if needed
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;

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

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Set Firefox as the default URL handler
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

  # Enable KDE Plasma
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
  };

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
  virtualisation.virtualbox = {
    host = {
      enable = true;
      # # Required for USB devices on the guest OS, but causes long rebuilds.
      # enableExtensionPack = true;

      # Workaround for virtualbox issue in kernel 6.12
      # https://discourse.nixos.org/t/issue-with-virtualbox-in-24-11/57607
      enableKvm = true;
      addNetworkInterface = false;
    };

    # # Guest additions
    # guest = {
    #   enable = true;
    # };
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

    libinput.touchpad.disableWhileTyping = true;

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

    tailscale.enable = true;

    # For firmware updates. To apply updates, run:
    #   fwupdmgr refresh     # fetches new updates
    #   fwupdmgr get-updates # optional, just gives extra detail
    #   sudo fwupdmgr update # shows available updates & installs them
    fwupd = {
      enable = true;
    };

    # Fingerprint reader
    # Enroll fingerprints: `sudo fprintd-enroll`
    # Verify things are working: `fprintd-verify`
    # List all enrolled prints: `fprintd-list $(whoami)`
    fprintd = {
      enable = true;
    };


    #   openssh = {
    #     enable = true;
    #     # set these to false to require key auth for better security
    #     settings.PasswordAuthentication = true;
    #     settings.KbdInteractiveAuthentication = true;
    #   };
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

