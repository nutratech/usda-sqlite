#!/bin/bash -e

# nt-sqlite, an sqlite3 database for nutratracker clients
# Copyright (C) 2020  Shane Jaroch <mathmuncher11@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# cd to script's directory
cd "$(dirname "$0")"

# Create tmp dir
mkdir -p tmp
cd tmp


# -----------------
# Download and unzip
# -----------------
curl -O "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR-Legacy/SR-Leg_DB.zip"
unzip SR-Leg_DB.zip SR_Legacy.accdb
curl -L "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/Flav/FDB-EXP_R01-1.accdb" -o FDB-EXP_R01-1.accdb


# -----------------
# Run access2csv
# -----------------
# git clone git@github.com:AccelerationNet/access2csv.git

# cd access2csv
# mvn clean install -Dmaven.test.skip=true  # handled automatically by command
cd ../access2csv
./access2csv --schema --with-header --quote-all false --input ../tmp/SR_Legacy.accdb --output ../tmp/usda
./access2csv --schema --with-header --quote-all false --input ../tmp/FDB-EXP_R01-1.accdb --output ../tmp/usda/fdb-exp
cd ..


# --------------------------------------
# Move to permanent home and clean up
# --------------------------------------
rm -rf SR-Leg_DB

mkdir -p SR-Leg_DB
cd SR-Leg_DB

mv ../tmp/usda/* .

rm -rf ../tmp
# mv fdb-exp/FLAV_DAT/NUT_DATA.csv
