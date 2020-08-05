#!/bin/bash -e

# cd to script's directory
cd "$(dirname "$0")"
cd ../data

sqleton -o ../docs/nutra.svg nutra.db
