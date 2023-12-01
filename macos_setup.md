# macOS Setup

- Install XCode command line tools
    - `xcode-select --install`
    - or try to use a command like `git --version` and it will prompt you

- Install homebrew
    - If on an M1, also install the intel version:

        ```sh
        arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        ```
    <!--
        These ones are better to install manually:
            - iterm2
            - visual-studio-code (make sure to use the arm64 version if needed)
            - browsers
                - firefox
                - google-chrome
                - homebrew/cask-versions/firefox-developer-edition
                - homebrew/cask-versions/google-chrome-canary
                - microsoft-edge
            - spotify
    -->
    - slack
    - github
    - keepingyouawake
    - jumpcut
        - open the macOS system preferences and set this to launch at startup
    - background-music (doesn't work with bluetooth, but nice to have anyway)
    - signal
    - bartender
        - search bitwarden for "Bartender License" for license info
    - coconutbattery
        - search bitwarden for "CoconutBattery License" for license info
        - Format: %p% (%r)
        - Chart icon: Right
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
    - actual

- Install global npm packages
    - N/A

- Install mac app store apps
    - imovie
    - xcode

- Upgrade `git` instead of using the old built in macOS version

    ```sh
    brew install git
    brew link --force git
    ```

- Install & configure stretchly

    ```sh
    brew install --cask stretchly
    rm -rf ~/Library/Application\ Support/Stretchly/config.json
    ln -sf ~/Nextcloud/Backups\ and\ Archives/stretchly.json ~/Library/Application\ Support/Stretchly/config.json
    ```

- Install & configure day-o

    ```sh
    brew install --cask day-o
    rm -rf ~/Library/Preferences/com.shauninman.Day-O.plist
    ln -sf ~/Nextcloud/Backups\ and\ Archives/com.shauninman.Day-O.plist ~/Library/Preferences/com.shauninman.Day-O.plist
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
        # MANUAL: System Preferences > Keyboard > Shortcuts > Services, check "New iTerm2 Tab Here" and "New iTerm2 Window Here"
        brew install z
        # MANUAL: install oh-my-zsh: https://ohmyz.sh/#install
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```

    - Enable shell integration
        - https://iterm2.com/documentation-shell-integration.html

    - Allow using touchID for `sudo`: https://it.digitaino.com/use-touchid-to-authenticate-sudo-on-macos/

- Link vscode dictionary
    - `ln -sf ~/Nextcloud/Backups\ and\ Archives/vscode/spellright.dict ~/Library/Application\ Support/Code/User/spellright.dict`

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

## Additional Notes

- <https://github.com/Homebrew/homebrew-bundle>
- Show the "allow apps from anywhere" setting: `sudo spctl --master-disable`
    - Turn off the "app downloaded from the internet" warning: `defaults write com.apple.LaunchServices LSQuarantine -bool NO`
- Change default screenshot location: `defaults write com.apple.screencapture location $HOME/Documents/Screenshots` (follow up with `killall SystemUIServer` to refresh)
- Show hidden files: `defaults write com.apple.finder AppleShowAllFiles YES` (relaunch finder to see change: Alt+RightClick on finder dock icon, click "relaunch")
- Allow vim key repeat in VSCode: `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`

<!--
- Remove all default dock items: `defaults delete com.apple.dock persistent-apps` (follow it up with `killall dock` to refresh)
- Show file extensions: `defaults write NSGlobalDomain AppleShowAllExtensions -bool true` (follow it up with `killall Finder` to refresh)
- Set textedit to plain text: `defaults write com.apple.TextEdit RichText -int 0`
- Freeze virtual desktop locations instead of reordering based on use: `defaults write com.apple.dock mru-spaces -bool false`
- Turn off 2-finger swipe between browser pages: `defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE`
- Add message to login screen: `sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Your Message"`
- Expand the save/print dialogs:
    ```bash
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    ```
-->

- Turn off startup chime on pre-2017 devices:
    - `sudo nvram SystemAudioVolume=%80` or `sudo nvram SystemAudioVolume=%01` or `sudo nvram SystemAudioVolume=%00` or `sudo nvram SystemAudioVolume=" "`
- Add "Copy Path" to right click menu: <http://osxdaily.com/2013/06/19/copy-file-folder-path-mac-os-x/> (**Services** have been renamed to **Quick Actions**)
- Add some [quick look plugins](https://github.com/sindresorhus/quick-look-plugins)
    - `brew install --cask qlcolorcode` (add code syntax coloring)
    - `brew install --cask qlstephen` (text files with no extension)
    - `brew install --cask qlmarkdown` (markdown files)
    - `brew install --cask quicklook-json` (json files)
