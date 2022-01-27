#!/bin/bash

set -e

if [ -n "$DIST_VERSION" ]; then
    version=$DIST_VERSION
else
    version=`git describe --dirty --tags || echo unknown`
fi

yarn clean
VERSION=$version yarn build:scalingo

# include the sample config in the tarball. Arguably this should be done by
# `yarn build`, but it's just too painful.
cp config.sample.json webapp/

mkdir -p dist
cp -r webapp element-$version

# Just in case you have a local config, remove it before packaging
rm element-$version/config.json || true

$(dirname $0)/normalize-version.sh ${version} > element-$version/version

# Tchap: Do not make a tar file. Just copy the files in /dist, ready to be served.
cp -r element-$version/* dist/
rm -r element-$version

echo
echo "Packaged dist/element-$version"
