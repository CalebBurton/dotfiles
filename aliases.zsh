alias watch-agora="cd ~/Documents/GitLab/umbrella/apps/agora && source ../../.env && echo 'yarn watch' && yarn watch"
alias watch-arachne="cd ~/Documents/GitLab/umbrella/apps/arachne && source ../../.env && source .env && echo 'make db_start' && make db_start && echo 'yarn watch' && yarn watch"
alias build-arachne="cd ~/Documents/GitLab/umbrella/apps/arachne && source ../../.env && source .env && echo 'yarn build' && yarn build"
alias start-ithaca="cd ~/Documents/GitLab/umbrella/apps/ithaca && source ../../.env && source .env && echo 'yarn start' && yarn start"
alias start-styleguide="cd ~/Documents/GitLab/umbrella/apps/styleguide && source ../../.env && echo 'yarn start' && yarn start"

alias lint-umbrella="cd ~/Documents/GitLab/umbrella && source .env && echo 'yarn lint' && yarn lint"
alias test-umbrella="cd ~/Documents/GitLab/umbrella && source .env && echo 'yarn test' && yarn test"

alias start-specialist="cd ~/Documents/GitLab/specialist && echo 'nix-shell (\"make server\" starts things)' && nix-shell"
alias test-specialist="cd ~/Documents/GitLab/specialist && echo 'bundle exec guard (\"rspec\" command runs all tests)' && bundle exec guard"

alias start-navigator="cd ~/Documents/GitLab/navigator && echo 'bundle exec rails s -p 3001 (I hope specialist is running)' && bundle exec rails s -p 3001"
alias start-papuros="cd ~/Documents/GitLab/papuros && echo 'yarn start -p 3002' && yarn start -p 3002"

alias dcu="docker-compose up"
alias dcb="docker-compose build"

alias sad="say -v karen 'all done'"

alias website-go="cd ~/Documents/GitHub/website-source && npm run start"
alias website-publish="cd ~/Documents/GitHub/website-source && npm run publish"

alias gpl="git pull"
alias gps="git push"
alias gpsh="git push"
alias gs="git stash"
alias gsp="git stash pop"
alias grim="git rebase -i --autosquash origin/master"
alias gamend="git add -A && git commit -a --amend -C HEAD"
alias gcom="git commit -m"
# List gitignored files that were somehow committed
# git ls-files --ignored --exclude-standard
# Delete a file and all history of it
alias gdestroy="git rm -r"

# Overwrite oh-my-zsh versions with better defaults
alias gst="git status -s -b"
alias glog="glol"
alias gap="git add --patch"
alias gdc="git diff --cached"
alias gp="echo 'Error: \"gp\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"
alias gpu="echo 'Error: \"gpu\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"

alias ssh-start="eval \"$(ssh-agent -s)\" && ssh-add --apple-load-keychain"

alias be="bundle exec"

alias update-packages="npx npm-check-updates -i"

function eod() {
    cd ~/Documents/GitHub/personal
    git add -p
    echo $(date '+%B %_d') | awk '{print "feat(worklog): end of day -",tolower($0)}' | git commit -F -
}

function bup() {
    ## NEW VERSION?
    #
    # echo 'Deep fetching the cask repository...\n'
    # git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
    # echo 'Fetched. Updating homebrew...'
    # brew update
    # echo 'Updated. Listing outdated casks:\n'
    #
    ## OLD VERSION
    #
    echo "Updating homebrew...\n"
    brew update
    echo ""
    brew outdated --cask --greedy
    while true; do
        echo -n "\nUpgrade outdated casks? [Y/n]: "
        read yn
        case $yn in
            [Nn]* ) break;;
            * ) echo "" && brew upgrade --cask --greedy;;
        esac
        yn=""
        break;
    done
    echo ""
    return 0;
}

alias bs="brew search"
alias bsc="brew search --casks"

# `bc` is already a command, don"t overwrite it
alias bic="brew install --cask"
alias buc="brew upgrade --cask"
alias bucg="brew upgrade --cask --greedy"

alias please="sudo"
alias reload="source $HOME/.zshrc"

alias zshrc="code $HOME/Documents/GitHub/dotfiles/.zshrc"
alias aliases="code $HOME/Documents/GitHub/dotfiles/aliases.zsh"
alias tmuxconf="code $HOME/Documents/GitHub/dotfiles/.tmux.conf"

alias python="python3"
