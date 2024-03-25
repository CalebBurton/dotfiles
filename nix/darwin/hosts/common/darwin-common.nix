{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  users.users.calebburton.home = "/Users/calebburton";
  # darwin-rebuild switch --flake ~/Code/GitHub/dotfiles/nix/
  # nix run nix-darwin -- switch --flake ~/Code/GitHub/dotfiles/nix
  # darwin-rebuild switch --flake .#Calebs2015MBP2
  # (^ hash syntax needs to be run from ~/Code/GitHub/dotfiles)

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # warn-dirty = true;
    };
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.ffmpeg
      pkgs.vim
    ];

  homebrew = {
    enable = true;
    # updates homebrew packages on activation
    onActivation.upgrade = true;
    taps = [
      #
    ];
    brews = [
      # Before putting anything here, see if there's a nix pkg available
    ];
    casks = [
      # jumpcut
      #   - open the macOS system preferences and set this to launch at startup
      # background-music (doesn't work with bluetooth, but nice to have anyway)
      # coconutbattery
      #   - search bitwarden for "CoconutBattery License" for license info
      #   - Format: %p% (%r)
      #   - Chart icon: Right
      # notunes
      #   - requires configuration: https://github.com/tombonez/noTunes
      # thunderbird
      #   - In config editor modify the following:
      #       - mailnews.default_sort_type = 18 (date)
      #       - mailnews.default_sort_order = 2 (descending)
      #       - mailnews.default_view_flags = 1 (threaded)
      "bartender" # search bitwarden for "Bartender License"
      "day-o"
      "github"
      "gimp"
      "keepingyouawake"
      "logitech-options"
      "microsoft-remote-desktop"
      "nextcloud"
      "protonmail-bridge"
      "protonvpn"
      "signal"
      "the-unarchiver"
      "vlc"
      "vnc-viewer"
      "zoom"

      # Personal only
      "cyberduck"
      "disk-inventory-x"
      "handbrake"
      "musescore"
      "tor-browser"
      "qbittorrent"

      # # Work only
      # "dbeaver-community" # required prerequisite cask: adoptopenjdk (can be fiddly...)
      # "slack"

      # # Heavy
      # "docker"
      # "libreoffice"
      # "virtualbox"
    ];
    masApps = {
        # "imovie" = 1;
        # "xcode" = 1;
      # "iA Writer" = 775737590;
      # "Reeder" = 1529448980;
      # "Resize Master" = 1025306797;
      # "Tailscale" = 1475387142;
      # "Wireguard" = 1451685025;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # promptInit = (builtins.readFile /Users/calebburton/.zshrc);
    # promptInit = ''
    #   . /nix/store/zgz87qspyip4ls6srcm0qkxj4kzj0rkw-set-environment
    # '';
    # interactiveShellInit = ''
    #   . /nix/store/zgz87qspyip4ls6srcm0qkxj4kzj0rkw-set-environment
    #   return;
    # '';
    # shellInit = ''
    #   # Work around multi-user Nix.
    #   # export __NIX_DARWIN_SET_ENVIRONMENT_DONE=1
    #   # if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    #   #     # As far as Nix is concerned, with all we set here, this is true.
    #   # fi
    #   export __NIX_DARWIN_SET_ENVIRONMENT_DONE=0
    # '';
  };

  # # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
