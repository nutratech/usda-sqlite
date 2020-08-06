#!/bin/bash -e

# cd to script's directory
cd "$(dirname "$0")"
cd ../sql

sqleton -o ../docs/nutra.svg nutra.db
