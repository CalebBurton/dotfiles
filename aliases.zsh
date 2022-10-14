# alias start-outreach-b="cd $BITBUCKET_DIR/outreach && echo 'make up-dev' && make up-dev"
# alias start-outreach-f="cd $BITBUCKET_DIR/outreach && echo 'npm run watch:fast' && npm run watch:fast"

# alias lint-umbrella="cd $GITLAB_DIR/umbrella && echo 'yarn lint' && yarn lint"
# alias test-umbrella="cd $GITLAB_DIR/umbrella && echo 'yarn test' && yarn test"

alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcp="docker-compose pull"
alias dcb="docker-compose build"

alias sad="say -v karen 'all done'"

alias website-go="cd $GITHUB_DIR/website-source && npm run start"
alias website-publish="cd $GITHUB_DIR/website-source && npm run publish"

alias gitdefault="git rev-parse --abbrev-ref origin/HEAD | cut -c8-"
alias gitcurrent="git rev-parse --abbrev-ref HEAD"
alias feature_branch_url='echo "https://app-$(gitcurrent | cut -c1-32).aledade.com"'

alias gpl="git pull"
alias gps="git push"
alias gpsh="git push"
alias gs="git stash"
alias gsp="git stash pop"
alias gri="git rebase -i"
alias gamend="git add -A && git commit -a --amend -C HEAD"
alias gcom="git commit -m"
# # List gitignored files that were somehow committed
# git ls-files --ignored --exclude-standard
# Delete a file and all history of it
alias gdestroy="git rm -r"

# Single quotes are so the $(...) isn't evaluated until runtime
alias grd='git rebase origin/$(gitdefault)'
alias grid='git rebase -i --autosquash origin/$(gitdefault)'
alias grim="echo 'Renamed to \`grid\`' && grid"

gcomt() {
    echo 'test'
    PREF="$(gitcurrent | grep -oE '[aApPrRcChH]{3,4}-(\d{4,6})' | tr aprch APRCH)"
    if [ -z $PREF ] && [[ "$PREF" == "" ]]; then
      MSG="${1}"
    else
          MSG="${PREF}: ${1}"
    fi
    printf "
    Committing locally with message \`\`$MSG\`\`\n
    "
    git commit -m $MSG
}

# Overwrite oh-my-zsh versions with better defaults
alias gst="git status -s -b"
alias glog="glol"
alias gap="git add --patch"
alias gdc="git diff --cached"
alias gp="echo 'Error: \"gp\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"
alias gpu="echo 'Error: \"gpu\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"

# # Use `gsw` or `git switch`
# unalias gco
# alias gco="echo 'Use \"gsw\" or \"git switch\" instead' && return 1"
# # Use `gswc` or `git switch -c`
# unalias gcb
# alias gcb="echo 'Use \"gswc\" or \"git switch -c\" instead' && return 1"

# alias ssh-start="eval \"$(ssh-agent -s)\" && ssh-add --apple-load-keychain"
function ssh-start() {
    eval `ssh-agent -s`
    find "$HOME/.ssh" -type f -iname "id_*" ! -iname "*.pub" | \
    while read line; do ssh-add $line ; done
}
function ssh-stop() {
    kill $(ps aux | grep 'ssh-agent' | awk '{print $2}') &> /dev/null
    echo "all 'ssh-agent' processes killed"
}

alias be="bundle exec"

alias update-npm-packages="npx npm-check-updates -i"

function eod() {
    cd ~/Code/GitHub/personal
    git add -p
    echo $(date '+%B %_d') | awk '{print "feat(worklog): end of day -",tolower($0)}' | git commit -F -
}

function login_to_bitwarden() {
    if [ -z "$BW_SESSION" ]; then
        echo 'Logging in...'
        login_msg=$(
            BW_CLIENTID=$(security find-generic-password -a bitwarden_api_client_id -w) \
                BW_CLIENTSECRET=$(security find-generic-password -a bitwarden_api_client_secret -w) \
                bw login --apikey && \
                unset BW_CLIENTID && \
                unset BW_CLIENTSECRET
        )
        echo 'Successfully logged in'

        echo 'Unlocking vault...'
        success_msg=$(
            BW_PASSWORD=$(security find-generic-password -a bitwarden_api_password -w) \
                bw unlock --passwordenv BW_PASSWORD && unset BW_PASSWORD
        )
        export BW_SESSION=$(echo $success_msg | grep -o -m 1 '".*"' | tr -d '"')
        echo 'Successfully unlocked vault'
    else
        echo '(already logged in)'
    fi
}

# Restart the logi options daemon
function logi-restart() {
    kill $(ps aux | grep "[L]ogiMgrDaemon" | awk '{print $2}')
    echo 'Logi options daemon restarting. It may take a few seconds to take effect.'
}

# Allow using the intel version of homebrew, even on M1 hardware
if [[ $IS_M1 == 1 ]]; then
    alias ibrew='arch -x86_64 /usr/local/bin/brew'
    alias mbrew='arch -arm64e /opt/homebrew/bin/brew'
    # alias brew=ibrew
fi

function bup() {
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
alias reload="exec zsh"

alias zshrc="code $GITHUB_DIR/dotfiles/.zshrc"
alias aliases="code $GITHUB_DIR/dotfiles/aliases.zsh"

# Add Aledade-specific aliases
if [ "$(scutil --get ComputerName)" = "Aledade-M3680" ]; then
    alias ol='aws sso login'

    function set_dbt_vars() {
        if [ -z "$BW_SESSION" ]; then
            login_to_bitwarden
        fi
        echo 'Setting dbt vars'
        export DBT_PROFILES_DIR="$BITBUCKET_DIR/dbt"

        # I don't have these yet. Submit a devops ticket if I need them.
        export DBT_SNOWFLAKE_USER='cburton'
        export DBT_SNOWFLAKE_PASSWORD=$(bw get password "[Aledade] db-dev password")
        export DBT_SNOWFLAKE_DB='ARCHIVE'

        # defaults to DATAVELOCITY but DEV is better for engineers
        export DBT_ROLE='DEV'

        export DBT_POSTGRES_USER='cburton'
        export DBT_POSTGRES_PASSWORD=$(bw get password "[Aledade] db-dev password")

        # Just use the defaults for these
        # export DBT_SNOWFLAKE_WAREHOUSE='wh_datavelocity'
        # export DBT_SCHEMA='public'
        # export DBT_PORT='5432'

        echo 'Successfully set dbt vars'
        bw lock
    }

    function set_db_vars() {
        if [ -z "$BW_SESSION" ]; then
            login_to_bitwarden
        fi
        echo 'Setting db vars'
        export DB_USER='cburton'
        export DB_PASSWORD=$(bw get password "[Aledade] db-dev password")
        echo 'Successfully set db vars'
        bw lock
    }
fi

