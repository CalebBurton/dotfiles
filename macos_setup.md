# macOS Setup

- Install XCode command line tools
    - `xcode-select --install`
    - or try to use a command like `git --version` and it will prompt you

- Install homebrew
    <!-- iterm2 - better to do this one manually -->
    <!-- firefox - better to do browsers manually -->
    <!-- google-chrome -->
    <!-- homebrew/cask-versions/firefox-developer-edition -->
    <!-- homebrew/cask-versions/google-chrome-canary -->
    <!-- microsoft-edge -->
    <!-- spotify (updates itself too often, better to do manually) -->
    - slack
    - github
    - keepingyouawake
    - jumpcut
    - signal
    - bartender
        - License Name: Caleb Burton
        - License Key: GAWQE-F9ASZ-X8PWH-8BEC9-NZ5J8-R8DJ8-AHDU7-RQWL6-A9KH2-CXEJS-BVCRW-QY9RN-WG5XR-534KT-HTA6M-A
    - coconutbattery
        - License email: ccburton4@gmail.com
        - License key: GAWAE-FA5KK-QSYVR-NGZQ5-8G4FH-DMKDQ-LB7VC-26BQC-CRPCQ-NJ579-F8E5K-3JBM6-NED3C-GRKE9-9BYU
        - Format: %p% (%r)
        - Chart icon: Right
    - visual-studio-code
    - shellcheck
    - dbeaver-community
        - required prerequisite cask: adoptopenjdk (can be fiddly...)
    - docker
    - gimp
    - vlc
    - nextcloud
    - logitech-options
        - required prerequisite: `brew tap homebrew/cask-drivers`
    - virtualbox
    - libreoffice
    - zoom
    - notunes
        - requires configuration: https://github.com/tombonez/noTunes
    - protonvpn
    - the-unarchiver
    - licecap
    - protonmail-bridge
    - thunderbird
        - In config editor modify the following:
            - mailnews.default_sort_type = 18 (date)
            - mailnews.default_sort_order = 2 (descending)
            - mailnews.default_view_flags = 1 (threaded)

- Homebrew maybes
    - anki
    - inkscape
    - android-studio
    - another-redis-desktop-manager
    - elgato-thunderbolt-dock
        - requires `brew tap homebrew/cask-drivers`
    - vnc-viewer
    - adobe-acrobat-reader
    - skype
    - postman
    - flux

- Install non-homebrew apps
    actual
    logi options? might be in homebrew

- Install global npm packages
    <!-- cypress (https://docs.cypress.io/guides/getting-started/installing-cypress.html) -->
    <!-- trash-cli (https://github.com/sindresorhus/trash-cli) -->

- Install mac app store apps
    imovie
    xcode

- Upgrade `git` instead of using the old built in macOS version

    ```sh
    brew install git
    brew link --force git
    ```

- Install & configure stretchly

    ```sh
    brew install --cask stretchly
    rm -rf ~/Library/Application\ Support/Stretchly/config.json
    ln -sf ~/Nextcloud/Settings\ Backups/stretchly.json ~/Library/Application\ Support/Stretchly/config.json
    ```

- Install & configure day-o

    ```sh
    brew install --cask day-o
    rm -rf ~/Library/Preferences/com.shauninman.Day-O.plist
    ln -sf ~/Nextcloud/Settings\ Backups/com.shauninman.Day-O.plist ~/Library/Preferences/com.shauninman.Day-O.plist
    ```

- Install fonts

    ```sh
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
    ```

- Set up terminal
    - Install go-cats theme

        ```sh
        git clone https://github.com/CalebBurton/terminal-themes.git
        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts
        ./install.sh
        cd ..
        rm -rf fonts
        cp ~/Code/GitHub/terminal-themes/go-cats.zsh-theme ~/.oh-my-zsh/themes/
        # MANUAL: import all iterm preferences from the terminal-themes directory
        brew install z
        # MANUAL: install oh-my-zsh: https://ohmyz.sh/#install
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```

    - Enable shell integration
        - https://iterm2.com/documentation-shell-integration.html

    - Allow using touchID for `sudo`: https://it.digitaino.com/use-touchid-to-authenticate-sudo-on-macos/

- Link vscode dictionary
    - `ln -sf ~/Nextcloud/Settings\ Backups/vscode/spellright.dict ~/Library/Application\ Support/Code/User/spellright.dict`

## macOS Settings

- Run the `./install` file in this directory
- Settings that need manual changes:
    - Keyboard > Modifier keys > change caps lock to escape (needs to be changed on each keyboard you use)
- Displays
    - update display arrangement
    - change scaling to 1440x900 if it defaulted to higher than that
- Spotlight
    - add git folders to "privacy" section so they are not indexed
- Finder
    - Set the default folder to open when Finder opens:

    ```sh
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    ```
