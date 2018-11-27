#!/bin/bash

# If you don't want to deploy the latest version, you can just specify the SHA
# of an older revision as the only argument to this script.

set -e

NPM_PACKAGE_VERSION=$(cat package.json \
                      | grep version \
                      | head -1 \
                      | awk -F: '{ print $2 }' \
                      | sed 's/[",]//g' \
                      | tr -d '[[:space:]]')

SHA1=$1
# Choose an explicit "remote" alias for the `git push`.
# The default behavior is "origin". This entirely depends
# on your personal git remote config.
# See .git/config and `git remote -v` for more info.
REMOTE=$2

if [ -z $1 ]; then
    # If no SHA1 specified, we have to make sure that we'll deploy from the
    # master branch.
    BRANCH_NAME=`git symbolic-ref HEAD | cut -d"/" -f3`
    if [[ "${BRANCH_NAME}" != "master" ]]; then
        echo "Production deploys only allowed from the master branch."
        exit 1
    fi

    SHA1=`git rev-parse HEAD`
fi

if [ -z $2 ]; then
    REMOTE=origin
fi

git commit --amend -m "release v$NPM_PACKAGE_VERSION at $(date -u +%Y-%m-%d:%H:%M:%S) UTC && [skip ci]"

git push
git push $REMOTE
git push $REMOTE --tags
