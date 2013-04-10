#!/bin/bash

GITHUB=jblack248
DIR=$(pwd)

echo "Updating git repos that do not belong to $GITHUB"
echo "In folder $DIR"
FOLDERS=($(ls -d -- */))
for i in ${FOLDERS[*]}; do
    cd "$i"
    if [ -d ".git" ]; then
        # if repository is not mine then update it
        if ! grep -qF "${GITHUB}" .git/config; then
            git pull
        fi
    else
        echo "$i is not a git repository"
    fi
    cd ..
done
