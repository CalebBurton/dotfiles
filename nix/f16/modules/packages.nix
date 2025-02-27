{ pkgs, ... }:
{
  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        # Required by github-desktop
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

      # For wayland support
      (final: prev: {
        warp-terminal-patched = prev.warp-terminal.override {
          waylandSupport = true;
        };
      })
    ];
  };

  # Set VS Code to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    # Fixes non-Qt apps (like Firefox) running in wayland
    dconf.enable = true;
    kdeconnect.enable = true;
    # See https://linuxhint.com/how-to-instal-steam-on-nixos/
    steam.enable = true;
  };


  # MARK: User Packages
  users.users.cburton.packages = with pkgs; [
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
    gucharmap # Unicode symbol selector
    # handbrake
    inkscape-with-extensions
    kdePackages.filelight # Disk usage visualizer
    kdePackages.kdenlive
    kdePackages.partitionmanager
    kdePackages.plasma-nm # Network manager
    kdePackages.skanpage # Needs an override to allow OCR
    # kdePackages.skanpage.override { tesseractLanguages = [ "eng" ]; }
    krename # File renaming tool
    krita
    ktailctl
    libreoffice
    losslesscut-bin # Video trimmer
    nextcloud-client
    okteta # KDE hex editor
    pdfarranger
    # protonmail-bridge # Backend only...
    protonmail-bridge-gui
    # unstable.protonvpn-gui
    protonvpn-gui
    # unstable.qbittorrent
    qbittorrent
    realvnc-vnc-viewer
    rpi-imager
    # rustdesk # HUGELY increases build times
    signal-desktop
    # skypeforlinux
    spotify
    sweethome3d.application # Excludes the textures and furniture editors
    thunderbird
    tor-browser-bundle-bin
    unetbootin # USB ISO writer, like Etcher on macOS. Run it from a terminal.
    vlc
    # See https://nixos.wiki/wiki/Visual_Studio_Code
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix              # Nix syntax highlighting
        eamodio.gitlens           # Gitlens
        ms-python.python          # Python language support
        ms-python.black-formatter # Python Black formatter
        ms-python.vscode-pylance  # Pylance python language server
        usernamehw.errorlens      # ErrorLens
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
        {
          # Code Spell Checker
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "4.0.16";
          sha256 = "sha256-1GH3liiExURy5e6owSRr5UJ7UXa8KUgglIzfGsSPARg=";
        }
      ];
    })
    # warp-terminal
    warp-terminal-patched
    whatsapp-for-linux
    # XDG allows non-Qt apps (like Firefox) to use native tools like the file
    # picker: https://wiki.archlinux.org/title/Firefox#KDE_integration
    xdg-desktop-portal # Might already be included by Plasma, but can't hurt
    xdg-desktop-portal-kde # ^ Ditto
    pkgs-24-05.xournalpp # Fix for a memory bug in a dependency (cairo)
    # xournalpp
    yt-dlp
    # Screen sharing is broken on Wayland. Used a pinned version.
    # See https://github.com/NixOS/nixpkgs/issues/322970
    # zoom-us
    pkgs-24-05.zoom-us
  ];

  # MARK: System Packages
  environment.systemPackages = with pkgs; [
    awscli
    bitwarden-cli
    dig
    exfatprogs # For partitioning exFAT drives with gparted
    ffmpeg
    # fontforge # Broken in Qt 6, use the gtk version
    fontforge-gtk
    git
    gparted # For partitioning drives (GUI version)
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
    yt-dlp
    zip
  ];
}