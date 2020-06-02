alias old-api-go='cd ~/Documents/GitHub/Node-API && make serve'
alias old-api-pqa='cd ~/Documents/GitHub/Node-API && make pqa'
alias old-wa-go='cd ~/Documents/GitHub/Node-Webadmin && trash public/js && nvm use 8 && npm run grunt && make serve'
alias old-wa-pqa='cd ~/Documents/GitHub/Node-Webadmin && make pqa'

alias cdn-build='cd ~/Documents/GitHub/CDN/global && nvm use 6.2.1 && make build'
alias cdn-go='cd ~/Documents/GitHub/CDN/global && nvm use 6.2.1 && grunt serve'
alias myaccount-go='cd ~/Documents/GitHub/cupcake && make serve'
alias myaccount-pqa='cd ~/Documents/GitHub/cupcake && make pqa'
alias cupcake-go='myaccount-go'
alias cupcake-pqa='myaccount-pqa'

alias signup-go='cd ~/Documents/GitHub/member-signup/member-signup && waf && wafexec npm run start:watch'
alias signup-pqa='cd ~/Documents/GitHub/member-signup/member-signup && waf && wafexec npm run test && npm run lint'
alias member-go='cd ~/Documents/GitHub/member/member && waf && wafexec npm run start:watch'
alias member-pqa='cd ~/Documents/GitHub/member/member && waf && wafexec npm run test && npm run lint'
alias billing-go='cd ~/Documents/GitHub/billing && waf && cd billing && wafexec npm run start:watch'
alias billing-pqa='cd ~/Documents/GitHub/billing && waf && cd billing && wafexec npm run test && npm run lint'
alias promotions-go='cd ~/Documents/GitHub/promotions && waf && cd promotions && wafexec npm run start:watch'
alias promotions-pqa='cd ~/Documents/GitHub/promotions && waf && cd promotions && wafexec npm run test && npm run lint'
alias product-catalog-go='cd ~/Documents/GitHub/product-catalog && waf && cd product-catalog && wafexec npm run start:watch'
alias product-catalog-pqa='cd ~/Documents/GitHub/product-catalog && waf && cd product-catalog && wafexec npm run test && npm run lint'

alias reporter-a-go='cd ~/Documents/GitHub/reporter && cd aggregator && wafexec npm run start:local'
alias reporter-r-go='cd ~/Documents/GitHub/reporter && cd reviewer && wafexec npm run start:local:local'
alias reporter-f-go='cd ~/Documents/GitHub/reporter && cd formatter && wafexec npm run start:local:local'
alias reporter-d-go='echo "This one doesnt work, but it seems unnecessary anyway"'
alias reporter-e-go='cd ~/Documents/GitHub/reporter/template_generators/email_foundation && nvm use 8 && wafexec npm run start:dev:local'
alias reporter-logs='cd ~/Documents/GitHub/reporter/aggregator && wafexec npm run pm2 logs'

alias wa-go='cd ~/Documents/GitHub/webadmin && waf && cd frontend && wafexec npm run serve && cd ../api && wafexec npm run serve'
alias wa-pqa='cd ~/Documents/GitHub/webadmin && waf && cd frontend && wafexec npm run pqa && npm run lint && cd ../api && wafexec npm run pqa && npm run lint'

alias pm2='./node_modules/pm2/bin/pm2'

alias dcu='docker-compose up'
alias dcb='docker-compose build'

alias website-go='cd ~/Documents/GitHub/website-source/dev && npm run build:dev'
alias website-publish='cd ~/Documents/GitHub/website-source/dev && npm run publish'

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

alias gs='git stash'
alias gsp='git stash pop'
alias grim='git rebase -i master'
alias gcom='git add . && git commit -m'

alias bup='brew update'
alias bs='brew search'
alias bsc='brew search --casks'

# `bc` is already a command, don't overwrite it
alias bci='brew cask install'
alias bcu='brew cask upgrade'
alias bcug='brew cask upgrade --greedy'
alias bco='brew cask outdated'
alias bcog='brew cask outdated --greedy'

alias please='sudo'
alias reload='source $HOME/Documents/GitHub/dotfiles/zshrc.zsh'
alias zshrc='code $HOME/Documents/GitHub/dotfiles/zshrc.zsh'
alias aliases='code $HOME/Documents/GitHub/dotfiles/aliases.zsh'
