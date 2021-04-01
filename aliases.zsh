alias old-api-go='cd ~/Documents/GitHub/Node-API && make serve'
alias old-api-pqa='cd ~/Documents/GitHub/Node-API && make pqa'
alias old-wa-go='cd ~/Documents/GitHub/Node-Webadmin && trash public/js && nvm use 8 && npm run grunt && make serve'
alias old-wa-pqa='cd ~/Documents/GitHub/Node-Webadmin && make pqa'

alias cdn-build='cd ~/Documents/GitHub/CDN/global && nvm use 6.2.1 && make build'
alias cdn-go='cd ~/Documents/GitHub/CDN/global && nvm use 6.2.1 && grunt serve'
alias cupcake-go='cd ~/Documents/GitHub/cupcake && make serve'
alias cupcake-pqa='cd ~/Documents/GitHub/cupcake && make pqa'
alias myaccount-go='cupcake-go'
alias myaccount-pqa='cupcake-pqa'

alias ma19-go='cd ~/Documents/GitHub/myaccount19/myaccount19 && wafexec npm run start:watch'
alias ma19-pqa='cd ~/Documents/GitHub/myaccount19/myaccount19 && wafexec npm run test'
alias ma19-build='cd ~/Documents/GitHub/myaccount19/myaccount19 && wafexec npm install && wafexec npm run start:watch'
alias ma-go='ma19-go'
alias ma-pqa='ma19-pqa'
alias ma-build='ma19-build'

alias dcl-go='cd ~/Documents/GitHub/dcl/dcl && wafexec npm run dev'
alias dcl-build='cd ~/Documents/GitHub/dcl/dcl && wafexec npm install && wafexec npm run start:watch'

alias signup-go='cd ~/Documents/GitHub/member-signup/member-signup && waf && wafexec npm run start:watch'
alias signup-pqa='cd ~/Documents/GitHub/member-signup/member-signup && waf && wafexec npm run test && npm run lint'
alias member-go='cd ~/Documents/GitHub/member/member && waf && wafexec npm run start:watch'
alias member-pqa='cd ~/Documents/GitHub/member/member && waf && wafexec npm run test && npm run lint'
alias billing-go='cd ~/Documents/GitHub/billing/billing && wafexec npm run start:watch'
alias billing-pqa='cd ~/Documents/GitHub/billing/billing && wafexec npm run test && npm run lint'
alias promotions-go='cd ~/Documents/GitHub/promotions/promotions && wafexec npm run start:watch'
alias promotions-pqa='cd ~/Documents/GitHub/promotions/promotions && wafexec npm run test && npm run lint'
alias product-catalog-go='cd ~/Documents/GitHub/product-catalog/product-catalog && wafexec npm run start:watch'
alias product-catalog-pqa='cd ~/Documents/GitHub/product-catalog/product-catalog && wafexec npm run test && npm run lint'

alias reporter-help='echo "
-------------------------
|     a     |     r     |
-------------------------
|     f     |  d (opt)  |
-------------------------
|     e     |    logs   |
-------------------------
"'
alias reporter-a-go='cd ~/Documents/GitHub/reporter/aggregator && nvm use 14 && wafexec npm run start:local'
alias reporter-r-go='cd ~/Documents/GitHub/reporter/reviewer && nvm use 14 && wafexec npm run start:local:local'
alias reporter-f-go='cd ~/Documents/GitHub/reporter/formatter && nvm use 14 && wafexec npm run start:local:local'
alias reporter-d-go='cd ~/Documents/GitHub/reporter/detailedViewer && nvm use 14 && wafexec npm run start:local:local'
alias reporter-e-go='cd ~/Documents/GitHub/reporter/template_generators/email_foundation && nvm use 14 && wafexec npm run start:dev:production'
alias reporter-logs='cd ~/Documents/GitHub/reporter/aggregator && wafexec npm run pm2 logs'

alias wa-go='cd ~/Documents/GitHub/webadmin/frontend && wafexec npm run serve && cd ../api && wafexec npm run serve'
alias wa-pqa='cd ~/Documents/GitHub/webadmin/frontend && wafexec npm run pqa && npm run lint && cd ../api && wafexec npm run pqa && npm run lint'

alias pm2='./node_modules/pm2/bin/pm2'

alias dcu='docker-compose up'
alias dcb='docker-compose build'

alias wnpm='wafexec npm'
alias nrl='wnpm run lint'

alias website-go='cd ~/Documents/GitHub/website-source && npm run start:dev'
alias website-publish='cd ~/Documents/GitHub/website-source && npm run publish'

function api-token () {
    json=$(curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d 'username=qa1&password=qa1&ttl=1200000000' "http://0.0.0.0:3000/api/tech/login?u")
    id=$(echo $json | grep -o '[^"]\{64\}')
    RED='\033[0;31m'
    NOCOLOR='\033[0m'
    echo -e "\n\t${RED}$id${NOCOLOR}\n"
}

function stop-all () {
    pm2 kill
    kill -9 $(ps -aucaleb.burton | grep "[g]runt" | awk '{print $2}')
    echo "\nAll pm2 and grunt processes killed.\n"
}

# extract any kind of compressed file - from https://coderwall.com/p/arwifq/extracting-archives-from-the-terminal-easily
function extract () {
    echo Extracting $1 ...
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1  ;;
            *.tar.gz)    tar xzf $1  ;;
            *.bz2)       bunzip2 $1  ;;
            *.rar)       rar x $1    ;;
            *.gz)        gunzip $1   ;;
            *.tar)       tar xf $1   ;;
            *.tbz2)      tar xjf $1  ;;
            *.tgz)       tar xzf $1  ;;
            *.zip)       unzip $1   ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1  ;;
            *)        echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias gcm='get checkout master 2>/dev/null || git checkout main'  # checkout default branch, regardless of name
alias gs='git stash'
alias gsp='git stash pop'
alias grim='git rebase -i --autosquash origin/master'
alias gamend='git add -A && git commit -a --amend -C HEAD'
alias gcom='git add -A && git commit -a -m'
#Delete a file and all history of it
alias gdestroy="git ls-files --ignored --exclude-standard | xargs -0 git rm -r"

function eod() {
    cd ~/Documents/GitHub/personal
    git add -p
    echo $(date '+%B %_d') | awk '{print "(worklog): end of day -",tolower($0)}' | git commit -F -
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
