#!/bin/bash -ex

VERSION=$1
if [ -z $VERSION ]
then
    echo Error: NEED TO SPECIFY VERSION, e.g. build.sh 0.0.3
    exit
fi

cd "$(dirname "$0")"
# lives in sql/

# Remove existing
rm -f usda.sqlite

printf "\\n\\x1b[32m%s\x1b[0m\n\n" "==> Pack usda.sqlite v$VERSION"

# Create sqlite db
sqlite3 usda.sqlite ".read init.sql"

# Compress xzip
tar cJf usda.sqlite-$VERSION.tar.xz usda.sqlite

# Clean up
# rm ???
# overwrite existing?
mkdir -p dist
mv usda.sqlite-$VERSION.tar.xz dist
