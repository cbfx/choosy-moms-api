#! /usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail


function errcho {
  echo "$@" 1>&2
}

# usage: error_exit <error message> <exit code>
function errxit {
    errcho "$1"
    exit "${2:-1}"  ## Return a code specified by $2 or 1 by default.
}

function _zip {
    # zip --show-files -1 --recurse-paths --update --test $@
    zip -1 --quiet --recurse-paths --update --test "$@"
}

function build_lambda_package {
  if [ -z "${1:-}" ] || [ "${2:-}" ]; then
    errxit 'Usage: build_lambda_package <name>';
  fi

  if [ ! -d "node_modules" ]; then
    errxit "Can't find node_modules dir"
  fi

  _lambda_package_name="$1";
  echo "Building '${_lambda_package_name}' lambda."
  _zip --junk-paths "${_lambda_package_name}".zip ../lambda/"${_lambda_package_name}"/* build.json
  _zip --grow "${_lambda_package_name}".zip node_modules
}

GITSHA=$(git rev-parse HEAD)
if [ -z "$GITSHA" ]  || [ ${#GITSHA} -ne 40 ]; then
  errxit 'Could not determine current git sha.'
fi

rm -rf build
mkdir -p build

if [ ! -f build.json ] || [ ! -s build.json ]; then
    echo "build.json not found, writing."
    echo '{}' > build/build.json
fi

echo "Build for version: ${GITSHA}"

CONTENT=$(jq -r --arg GITSHA "${GITSHA}" '.version=$GITSHA' build/build.json)


echo "${CONTENT}" > build/build.json

yarn install --frozen-lockfile
cp -R node_modules build/node_modules


# Perform the following inside the build/ dir
pushd build
"$(npm bin)"/modclean --run --modules-dir node_modules

# This writes build/hello.zip, build/version.zip, etc.
build_lambda_package giphy
build_lambda_package users

# back to where we were
popd
