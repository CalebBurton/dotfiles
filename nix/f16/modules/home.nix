{ config, pkgs, ... }: {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    home.username = "cburton";
    home.homeDirectory = "/home/cburton";
    home.packages = with pkgs; [
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
      krename # File renaming tool
      krita
      ktailctl
      libreoffice
      nextcloud-client
      pdfarranger
      protonmail-bridge
      protonvpn-gui
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
          # yzane.markdown-pdf # md -> pdf
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            # Sieve syntax highlighting
            name = "vscode-sievehighlight";
            publisher = "adzero";
            version = "1.0.6";
            sha256 = "f0e9a9bfbf76788da4207fb9f8a3cbf6301ff3cc6c30641ec07110c22f018684";
          }
          # {
          #   name = "markdown-pdf";
          #   publisher = "yzane";
          #   version = "1.5.0";
          #   sha256 = "499e0247c2a3198232b2e0111839877291566af79ba8020185a956791aa1f42f";
          #   # Get this from python:
          #   # import base64
          #   # text = b'8Ompv792eI2kIH+5+KPL9jAf88xsMGQewHEQwi8BhoQ='
          #   # print(base64.decodebytes(text).hex())
          # }
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
            # update = "sudo nixos-rebuild switch";
        };
        history = {
            extended = true; # Save timestamp with each history entry
            # size = 10000;
            # path = "${config.xdg.dataHome}/zsh/history"; # Defaults to "$ZDOTDIR/.zsh_history"
        };

        # TODO: import this from ../../../aliases.zsh
        initExtra = ''
            FLAKE_LOCATION="/home/cburton/Code/GitHub/dotfiles/nix/f16"
            alias nixos-update="echo 'sudo nix flake update $FLAKE_LOCATION#' \
                && sudo nix flake update $FLAKE_LOCATION#"
            alias nixos-build="echo 'sudo nixos-rebuild build --flake $FLAKE_LOCATION#' \
                && sudo nixos-rebuild switch --flake $FLAKE_LOCATION#"
            alias nixos-switch="echo 'sudo nixos-rebuild switch --flake $FLAKE_LOCATION#' \
                && sudo nixos-rebuild switch --flake $FLAKE_LOCATION#"
            alias nixos-trim-dry="echo 'sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d --dry-run' \
                && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d --dry-run"
            alias nixos-trim="echo 'sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d' \
                && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d"
            alias nixos-history="echo 'sudo nix profile history --profile /nix/var/nix/profiles/system | sed ...' \
                && sudo nix profile history --profile /nix/var/nix/profiles/system | sed '/No changes\./d; s/://; /^$/d'"
            alias nixos-collect-garbage="echo 'You meant nix-collect-garbage. Running that now.' \
                && nix-collect-garbage"

            alias port-forwarding-check="echo natpmpc && natpmpc"
            function port-forwarding-start() {
                while true; do
                    date;
                    natpmpc -a 1 0 udp 60 -g 10.2.0.1 && \
                        natpmpc -a 1 0 tcp 60 -g 10.2.0.1 || \
                        { echo -e "ERROR with natpmpc command \a" ; break ; }
                    sleep 45
                done
            }


            function get_bw_status() {
                echo $(bw status | jq .status | cut -d '"' -f2)
            }

            BW_ORG_ID="e4f8f012-5485-44b4-ad15-ab2b012c56f4"

            # Need to see if this can work with kde wallet rather than
            # apple keychain
            #
            # function unlock_bitwarden() {
            #     if get_bw_status | grep "^locked$" ;then
            #         echo 'Unlocking vault...'
            #         success_msg=$(
            #             BW_PASSWORD=$(security find-generic-password -a bitwarden_api_password -w) \
            #                 bw unlock --passwordenv BW_PASSWORD && unset BW_PASSWORD
            #         )
            #         export BW_SESSION=$(echo $success_msg | grep -o -m 1 '".*"' | tr -d '"')
            #         echo 'Successfully unlocked vault'
            #     else
            #         echo "(vault cannot be unlocked. \`get_bw_status\` returns \"$(get_bw_status)\")"
            #     fi
            # }

            alias gpl="git pull"
            alias gps="git push"
            alias gpsh="git push"
            alias gs="git stash"
            alias gsp="git stash pop"
            alias gri="git rebase -i"
            alias grc="git rebase --continue"
            alias gamend="git add -A && git commit -a --amend -C HEAD"
            alias gamend_staged="git commit --amend -C HEAD"
            alias gcom="git commit -m"
        '';

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