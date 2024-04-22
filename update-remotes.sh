#!/bin/zsh

OLD_PREFIX="git@github.com:"
NEW_PREFIX="git@gh-personal:"
RED='\033[0;31m'
NC='\033[0m' # No Color

for d in */ ; do
    cd "$d" || exit
    REMOTE=$(git config --get remote.origin.url)
    if [[ $REMOTE =~ ^"$OLD_PREFIX" ]]; then
        NEW_REMOTE=${REMOTE/"$OLD_PREFIX"/"$NEW_PREFIX"}
        echo "$d remote set to $NEW_REMOTE from $REMOTE"
        git remote set-url origin "$NEW_REMOTE"
    else
        echo "${RED}The repo in $d does not match the pattern (Remote: '$REMOTE') so it was not converted${NC}"
    fi
    cd ..
done