#!/bin/bash

set -e

PRODUCT_NAME='element'

if [ -n "$DIST_VERSION" ]; then
    version=$DIST_VERSION
else
    version=`git describe --dirty --tags || echo unknown`
fi

yarn clean
VERSION=$version yarn build:scalingo

# Tchap : create a config file by copying the sample config.
cp config.sample.json webapp/config.json

mkdir -p dist
cp -r webapp $PRODUCT_NAME-$version

$(dirname $0)/normalize-version.sh ${version} > $PRODUCT_NAME-$version/version

# Tchap: Do not make a tar file. Just copy the files in /dist, ready to be served.
cp -r $PRODUCT_NAME-$version/* dist/
rm -r $PRODUCT_NAME-$version

echo
echo "Packaged dist/ - $PRODUCT_NAME-$version"
