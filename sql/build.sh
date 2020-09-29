#!/bin/bash -e

VERSION=$1
if [[ $VERSION == '' ]]
then
    echo Error: NEED TO SPECIFY VERSION, e.g. 0.0.3
    exit
fi

cd "$(dirname "$0")"
# printf "\\n\e[1;31m\e[0m\\n"

rm_cmd="rm -f usda.sqlite"
printf "\\n\e[1;31m${rm_cmd}\e[0m\\n\n"
$rm_cmd

pack_msg="==> Pack usda.sqlite-$VERSION"
printf "\\n\\x1b[32m${pack_msg}\x1b[0m\n\n"

# Create SQL file
pack_cmd="sqlite3 usda.sqlite \".read init.sql\""
printf "\\n\e[1;31m${pack_cmd}\e[0m\\n"
bash -exec "$pack_cmd"

# Compress xzip
tar_cmd="tar cJvf usda.sqlite-$VERSION.tar.xz usda.sqlite"
printf "\\n\e[1;31m${tar_cmd}\e[0m\\n"
$tar_cmd

# Clean up
# printf "\\n\e[1;31m${rm_cmd}\e[0m\\n"
# $rm_cmd

mv_cmd="mv usda.sqlite-$VERSION.tar.xz dist"
printf "\\n\e[1;31m${mv_cmd}\e[0m\\n\n"
$mv_cmd
