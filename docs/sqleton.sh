#!/bin/bash -e

# cd to script's directory
cd "$(dirname "$0")"
cd ../usda

sqleton -o ../docs/usda.svg usda.db
