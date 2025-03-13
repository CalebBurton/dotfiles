# Also defined in .zshrc, keep them synchronized
export GITHUB_DIR="$HOME/Code/GitHub"
export ALEDADE_DIR="$HOME/Code/Aledade"
if [[ "$(uname)" == "Darwin" ]]; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

if [[ "$(uname)" == "Darwin" ]]; then
  IS_MACOS=1
else
  IS_MACOS=0
fi

# Put these first so they're still available even if there's a syntax error in
# one of the other aliases or functions
alias reload="exec zsh"
alias zshrc="code $GITHUB_DIR/dotfiles/.zshrc"
alias aliases="code $GITHUB_DIR/dotfiles/aliases.zsh"

alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcp="docker-compose pull"
alias dcb="docker-compose build"
alias dsp="docker system prune --all --force"

alias website-go="cd $GITHUB_DIR/website-source && npm run start"
alias website-publish="cd $GITHUB_DIR/website-source && npm run publish"

# omz already includes $git_main_branch and $git_develop_branch
# https://kapeli.com/cheat_sheets/Oh-My-Zsh_Git.docset/Contents/Resources/Documents/index
alias gitdefault="git rev-parse --abbrev-ref origin/HEAD | cut -c8-"
alias gitcurrent="git rev-parse --abbrev-ref HEAD"
alias feature_branch_url='echo "https://app-$(gitcurrent | cut -c1-32).aledade.com"'

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
# # List gitignored files that were somehow committed
# git ls-files --ignored --exclude-standard
# Delete a file and all history of it
alias gdestroy="git rm -r"

# Single quotes are so the $(...) isn't evaluated until runtime
alias grid='git rebase -i --autosquash origin/$(git_develop_branch)'
alias grim="git rebase -i --autosquash origin/$(git_main_branch)"

function gfix() {
    git log --oneline --graph
    while true; do
        echo -n "Enter the commit SHA you want to amend or leave blank to cancel: "
        read sha
        if [[ -z "$sha" ]]; then
            echo "Empty SHA. Exiting."
            return 0
        fi
        git commit -a --fixup="$sha"
        sha=""
        break;
    done
    echo ""
    return 0;
}

# Overwrite oh-my-zsh versions with better defaults
alias gst="git status -s -b"
alias glog="glol"
alias gap="git add --patch"
alias gdc="git diff --cached"
alias gp="echo 'Error: \"gp\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"
alias gpu="echo 'Error: \"gpu\" is ambiguous. Use \"gpl\" to pull or \"gps\" to push.' && return 1"

# overwrite the `git restore` alias with my `git reset` function
unalias grst
function grst() {
    while true; do
        echo -n "Reset current branch to remote origin version? [Y/n]: "
        read yn
        case $yn in
            [Nn]* ) break;;
            * ) echo "" && git fetch && git reset --hard origin/$(gitcurrent);;
        esac
        yn=""
        break;
    done
    echo ""
    return 0;
}

alias update-npm-packages="npx npm-check-updates -i"

# https://www.stefanjudis.com/snippets/a-native-shell-alternative-to-the-trash-cli/
function trash() {
  echo "🗑️  Moving files to trash..."

  for var in "$@"
  do
    mv "$var" "$HOME/.trash"
    echo "Deleted $var"
  done
}

alias please="sudo"

if [[ $IS_MACOS == "1" ]]; then
    # macOS Commands

    alias flush-dns="echo 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder' \
        && sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

    alias sad="say -v karen 'all done'"

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
    # Hacking this together... zsh is annoying about shell expansion https://superuser.com/a/1731518
    alias ss='ssh-start && echo "${(z)history[(r)*]}" && "${(z)history[(r)*]}"'

    function get_current_mac() {
        ifconfig en0 ether | grep -oE '(.{2}:){5}.{2}'
    }

    function spoof_mac(){
        OLD_MAC="$(get_current_mac)"
        RANDOM_MAC=$(openssl rand -hex 6 | sed -E 's/(..)/\1:/g; s/.$//')

        # These have to run as root in quick succession.
        # The first line turns off wifi, the second line sets the new MAC.
        sudo sh -c "\
            /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z ; \
            ifconfig en0 lladdr $RANDOM_MAC"

        # Confirm it worked
        NEW_MAC="$(get_current_mac)"
        if [[ $NEW_MAC == $RANDOM_MAC ]] ;then
            echo 'Success? yes!'
            echo '(The wifi should reboot automatically, but it might take a second)'
        else
            echo 'Success? no... Trying again sometimes works though.'
        fi
        echo -e "  Old:    $OLD_MAC\n  Random: $RANDOM_MAC\n  New:    $NEW_MAC"

        # Turn wifi back on
        networksetup -detectnewhardware
    }

    # Restart the logi options daemon
    function logi-restart() {
        kill $(ps aux | grep "[L]ogiMgrDaemon" | awk '{print $2}')
        echo 'Logi options daemon restarting. It may take a few seconds to take effect.'
    }

    function bup() {
        echo "Updating homebrew...\n"
        brew update
        echo ""
        brew outdated --cask --greedy
        while true; do
            echo -n "\nUpgrade outdated casks and packages? [Y/n]: "
            read yn
            case $yn in
                [Nn]* ) break;;
                * ) brew upgrade --cask --greedy && \
                    brew upgrade;;
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
    alias buc="brew upgrade --cask --greedy && brew upgrade"

    function get_bw_status() {
        echo $(bw status | jq .status | cut -d '"' -f2)
    }

    function unlock_bitwarden() {
        if get_bw_status | grep "^locked$" ;then
            echo 'Unlocking vault...'
            success_msg=$(
                BW_PASSWORD=$(security find-generic-password -a bitwarden_api_password -w) \
                    bw unlock --passwordenv BW_PASSWORD && unset BW_PASSWORD
            )
            export BW_SESSION=$(echo $success_msg | grep -o -m 1 '".*"' | tr -d '"')
            echo 'Successfully unlocked vault'
        else
            echo "(vault cannot be unlocked. \`get_bw_status\` returns \"$(get_bw_status)\")"
        fi
    }

    function login_to_bitwarden() {
        if [[ $(get_bw_status) = "unlocked" ]]; then
            # Already logged in, nothing to do
            return 0
        elif [[ $(get_bw_status) = "locked" ]]; then
            unlock_bitwarden
        elif [[ $(get_bw_status) = "unauthenticated" ]]; then
            echo 'Logging in...'
            login_msg=$(
                BW_CLIENTID=$(security find-generic-password -a bitwarden_api_client_id -w) \
                    BW_CLIENTSECRET=$(security find-generic-password -a bitwarden_api_client_secret -w) \
                    bw login --apikey && \
                    unset BW_CLIENTID && \
                    unset BW_CLIENTSECRET
            )
            echo 'Successfully logged in'
            unlock_bitwarden
        else
            echo "Unrecognized status. \`get_bw_status\` returns: $(get_bw_status)"
            return 1
        fi
    }

else
    # NixOS Commands
    FLAKE_LOCATION="/home/cburton/Code/GitHub/dotfiles/nix/f16"
    alias nixos-update="echo 'sudo nix flake update --flake $FLAKE_LOCATION#' \
        && sudo nix flake update --flake $FLAKE_LOCATION#"
    alias nixos-build="pushd $FLAKE_LOCATION; \
        echo 'sudo nixos-rebuild build --flake $FLAKE_LOCATION#'; \
        sudo nixos-rebuild build --flake $FLAKE_LOCATION#; \
        popd"
    alias nixos-switch="echo 'sudo nixos-rebuild switch --flake $FLAKE_LOCATION#' \
        && sudo nixos-rebuild switch --flake $FLAKE_LOCATION#"
    alias nixos-boot="echo 'sudo nixos-rebuild boot --flake $FLAKE_LOCATION#' \
        && sudo nixos-rebuild boot --flake $FLAKE_LOCATION#"
    alias nixos-rollback="echo 'sudo nixos-rebuild switch --rollback --flake $FLAKE_LOCATION#' \
        && sudo nixos-rebuild switch --rollback --flake $FLAKE_LOCATION#"
    alias nixos-trim-dry="echo 'sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d --dry-run' \
        && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d --dry-run"
    alias nixos-trim="echo 'sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d' \
        && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d"
    alias nixos-history="echo 'sudo nix profile history --profile /nix/var/nix/profiles/system | sed '\''/No changes\./d; s/://; /^$/d'\''' \
        && sudo nix profile history --profile /nix/var/nix/profiles/system | sed '/No changes\./d; s/://; /^$/d'"
    alias nixos-collect-garbage="echo 'You meant nix-collect-garbage. Running that now.' \
        && nix-collect-garbage"

    alias get_sha="python '$GITHUB_DIR/dotfiles/nix/get_sha.py'"
    alias port-forwarding-check="echo natpmpc && natpmpc"
    function port-forwarding-start() {
        while true; do
            date;
            natpmpc -a 1 0 udp 60 -g 10.2.0.1 && \
                natpmpc -a 1 0 tcp 60 -g 10.2.0.1 || \
                { echo -e "ERROR with natpmpc command \a" ; break ; }
            sleep 50;
        done
    }

    alias flush-dns="echo 'sudo systemctl restart nscd' && sudo systemctl restart nscd"
fi

# Add Aledade-specific aliases
if command -v scutil &> /dev/null && [[ "$(scutil --get ComputerName)" == Aledade* ]]; then
    alias ol='aws sso login'
    alias rotate_pgpass="python $GITHUB_DIR/aledade-personal/rotate_pgpass.py"

    alias test-outreach-f="cd $ALEDADE_DIR/outreach \
        && echo 'npm run test aledade/static/js/...'"
    alias test-outreach-b="cd $ALEDADE_DIR/outreach \
        && echo 'make only=api/test_api_core.py::ApiCoreTests python-test' \
        && echo '          ^ remove \`aledade/tests/\` from the file path' \
        && echo '' \
        && echo 'Be sure to run \`make up-dev\` in another tab first!' \
        "
    alias start-outreach-b="cd $ALEDADE_DIR/outreach && echo 'make up-dev'"
    alias start-outreach-f="cd $ALEDADE_DIR/outreach && echo 'npm run watch'"

    alias start-dbt="cd $ALEDADE_DIR/dbt \
        && echo 'make ozy-dev (run \`set_dbt_vars\` if needed)'"

    alias start-event-cli-step-1="cd $ALEDADE_DIR/ingestion-biz-logic \
        && echo '  git checkout develop \' \
        && echo '  && git pull \' \
        && echo '  && poetry env use 3.8 \' \
        && echo '  && poetry install \' \
        && echo '  && set_db_vars\n' \
            && git checkout develop \
            && git pull \
            && poetry env use 3.8 \
            && poetry install \
            && set_db_vars"
    alias start-event-cli-step-2="cd $ALEDADE_DIR/ingestion-biz-logic \
        && echo '  Run \`start-event-cli-step-1\` first, then paste & modify the following:' \
        && echo '  (if you start the command with a space it is not saved to history)' \
        && echo '    DB_URL=postgresql://cburton:\$(echo \$DB_PASSWORD)@db-dev.aledade.com:5432/aledade poetry run event-cli -i ../toil/ARCH-X\ description/ARCH-X.jsonl -d'"

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

    migrate-to-github() {
        REPO="$(basename "$(git rev-parse --show-toplevel)")"
        CURRENT_REMOTE="$(git remote get-url --push origin)"
        NEW_REMOTE="git@github.com:aledade-org/$REPO.git"
        while true; do
            echo -n "Change remote origin?\n  Old: '$CURRENT_REMOTE'\n  New: '$NEW_REMOTE'\n[Y/n]: "
            read -r yn
            case $yn in
                [Nn]* ) echo "Cancelled. Run 'git remote set-url origin NEW_GIT_URL_GOES_HERE' to update the URL manually" && break;;
                * ) echo "" \
                    && git remote set-url origin "$NEW_REMOTE" \
                    && echo "Remote origin set. Current remote:" \
                    && git remote get-url --push origin
            esac
            yn=""
            break;
        done
        echo ""
        return 0;
    }

    function eod() {
        pushd "$GITHUB_DIR/worklog"
        git add -p
        echo $(date '+%B %_d') | awk '{print "feat(worklog): end of day -",tolower($0)}' | git commit -F -
    }

    function rebuild_biz_logic() {
        echo 'docker compose down biz-logic && docker compose build biz-logic && docker compose up -d biz-logic'
        docker compose down biz-logic
        docker compose build biz-logic
        docker compose up -d biz-logic
    }

    function open_ibl_container() {
        echo '(Remember to rebuild the biz-logic container first!)'
        CONTAINER_ID=ingestion-biz-logic-biz-logic-1
        docker exec -it $CONTAINER_ID /bin/bash -c "export SNOWFLAKE_USER=$SNOWFLAKE_USER && \
            export SNOWFLAKE_PASS=$DB_PASSWORD && \
            export SNOWFLAKE_ACCT=$SNOWFLAKE_ACCT && \
            export DB_URL=$DB_URL && \
            bash"
    }
fi
