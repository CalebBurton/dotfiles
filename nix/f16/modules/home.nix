{ config, pkgs, ... }: {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    home.username = "cburton";
    home.homeDirectory = "/home/cburton";
    home.packages = with pkgs; [
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
    # ] ++ [
    #   pkgs23_11.chromium
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager
    # release introduces backwards incompatible changes.
    home.stateVersion = "24.05";
    # home.stateVersion = ""; # Uncomment this line to see available options

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autocd = true; # Entering a directory is interpeted as "cd $directory"
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            ll = "ls -l";
        };
        history = {
            extended = true; # Save timestamp with each history entry
            # size = 10000;
        };
        initExtra = builtins.readFile(../../../aliases.zsh);

        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
                "z"
            ];
            # theme = "robbyrussell";
        };
    };
}