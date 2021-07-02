alias watch-agora='cd ~/Documents/GitLab/umbrella && source .env && cd ./apps/agora && yarn watch'
alias watch-arachne='cd ~/Documents/GitLab/umbrella && source .env && cd ./apps/arachne && yarn watch'
alias start-ithaca='cd ~/Documents/GitLab/umbrella && source .env && cd ./apps/ithaca && yarn start'

alias lint-umbrella='cd ~/Documents/GitLab/umbrella && source .env && yarn lint'
alias test-umbrella='cd ~/Documents/GitLab/umbrella && source .env && yarn test'

alias dcu='docker-compose up'
alias dcb='docker-compose build'

alias website-go='cd ~/Documents/GitHub/website-source && npm run start:dev'
alias website-publish='cd ~/Documents/GitHub/website-source && npm run publish'

alias gcm='get checkout master 2>/dev/null || git checkout main'  # checkout default branch, regardless of name
alias gs='git stash'
alias gsp='git stash pop'
alias grim='git rebase -i --autosquash origin/master'
alias gamend='git add -A && git commit -a --amend -C HEAD'
alias gcom='git add -A && git commit -a -m'
# Delete a file and all history of it
alias gdestroy="git ls-files --ignored --exclude-standard | xargs -0 git rm -r"

alias be='bundle exec'

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
    echo 'Updating homebrew...\n'
    brew update
    echo ''
    brew outdated --cask --greedy
    while true; do
        echo -n "\nUpgrade outdated casks? [Y/n]: "
        read yn
        case $yn in
            [Nn]* ) break;;
            * ) echo '' && brew upgrade --cask --greedy;;
        esac
        yn=''
        break;
    done
    echo ''
    return 0;
}

alias bs='brew search'
alias bsc='brew search --casks'

# `bc` is already a command, don't overwrite it
alias bic='brew install --cask'
alias buc='brew upgrade --cask'
alias bucg='brew upgrade --cask --greedy'

alias please='sudo'
alias reload='source $HOME/.zshrc'

alias zshrc='code $HOME/Documents/GitHub/dotfiles/.zshrc'
alias aliases='code $HOME/Documents/GitHub/dotfiles/aliases.zsh'
alias tmuxconf='code $HOME/Documents/GitHub/dotfiles/.tmux.conf'

alias python='python3'
