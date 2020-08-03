#!/bin/bash -e

# nutra-db, a database for nutratracker clients
# Copyright (C) 2020  Nutra, LLC. [Shane & Kyle] <nutratracker@gmail.com>

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
curl -L "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/Flav/Flav_R03-2.accdb" -o Flav_R03-3.accdb
curl -L "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/isoflav/Isoflav_R2-1.accdb" -o Isoflav_R2-1.accdb
curl -L "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/PA/PA02.accdb" -o PA02.accdb


# -----------------
# Run access2csv
# -----------------
# git clone git@github.com:AccelerationNet/access2csv.git

# cd access2csv
# mvn clean install -Dmaven.test.skip=true
cd ../access2csv
./access2csv --schema --quote-all false --input ../tmp/SR_Legacy.accdb --output ../tmp/usda --with-header
./access2csv --schema --quote-all false --input ../tmp/Flav_R03-3.accdb --output ../tmp/usda/flav --with-header
./access2csv --schema --quote-all false --input ../tmp/Isoflav_R2-1.accdb --output ../tmp/usda/isoflav --with-header
./access2csv --schema --quote-all false --input ../tmp/PA02.accdb --output ../tmp/usda/proanth --with-header
cd ..


# -----------------
# Move to permanent home
# -----------------
mkdir -p sr28-csv
cd sr28-csv
mv ../tmp/usda/* .


# -----------------
# Clean up
# -----------------
rm -rf ../tmp
# cd usda

# rm DATSRCLN.csv
# rm LANGUAL.csv
# rm DATA_SRC.csv
# rm FOOTNOTE.csv
# rm LANGDESC.csv
# rm DERIV_CD.csv
# rm SRC_CD.csv

cd flav
# rm DATA_SRC.csv
# rm DATSRCLN.csv
# rm FD_GROUP.csv
# rm FLAV_IND.csv
mv FLAV_DAT.csv NUT_DATA.csv

cd ../isoflav
# rm DATA_SRC.csv
# rm DATSRCLN.csv
# rm SYBN_DTL.csv
# mv ISFL_DAT.csv NUT_DATA.csv

cd ../proanth
# rm DATA_SRC.csv
# rm DATSRCLN.csv
# rm FD_GROUP.csv
mv PA_DAT.csv NUT_DATA.csv
