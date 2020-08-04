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

import csv
import os
import shutil
import sys

# Check Python version
if sys.version_info < (3, 7, 0):
    ver = ".".join([str(x) for x in sys.version_info[0:3]])
    print("ERROR: this requires Python 3.7.0 or later to run")
    print("HINT: You're running Python " + ver)
    exit(1)

# change to script's dir
os.chdir(os.path.dirname(os.path.abspath(__file__)))
shutil.rmtree("nt", True)
os.makedirs("nt", 0o755, True)


# --------------------
# io dict
# --------------------
output_files = {
    "SR-Leg_DB/FD_GROUP.csv": "nt/fdgrp.csv",
    "SR-Leg_DB/SRC_CD.csv": "nt/src_cd.csv",
    "SR-Leg_DB/DERIV_CD.csv": "nt/deriv_cd.csv",
    "SR-Leg_DB/LANGDESC.csv": "nt/lang_desc.csv",
    "SR-Leg_DB/LANGUAL.csv": "nt/langual.csv",
    "SR-Leg_DB/FOOTNOTE.csv": "nt/footnote.csv",
    "SR-Leg_DB/WEIGHT.csv": None,
}

special_interests_dirs = [
    "SR-Leg_DB/isoflav",
    "SR-Leg_DB/proanth",
    "SR-Leg_DB/flav",
]

# --------------------
# RDAs
# --------------------
rdas = {}
with open("rda.csv") as file:
    reader = csv.DictReader(file)
    rdas = list(reader)
    rdas = {int(x["id"]): x for x in rdas}


"""
# --------------------
# main method
# --------------------
"""


def main(args):
    """ Processes the USDA data to get ready for ntdb """

    # -----------------
    # Process USDA csv
    # -----------------
    print("==> Process CSV")
    process_nutr_def()
    process_food_des()
    process_data_srcs()
    process_nut_data()

    for fname in output_files:
        print(fname)
        # Open the CSV file
        with open(fname) as file:
            reader = csv.reader(file)
            rows = list(reader)
        #########################
        # Process and write out
        if fname == "SR-Leg_DB/WEIGHT.csv":
            process_weight(rows, fname)
        else:
            process(rows, fname)


# ----------------------
# Handle general file
# ----------------------
def process(rows, fname):
    """ Processes FD_GRP only :O """

    with open(output_files[fname], "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(rows)


# -----------------
# Nutrient defs
# -----------------
def process_nutr_def():
    """ Process nutr_def """

    def process_main(rows):
        result = []
        for row in rows:
            id = int(row["Nutr_no"])

            # Adjust && Insert
            row["id"] = row.pop("Nutr_no")
            row["rda"] = rdas[id]["rda"]
            row["unit"] = row.pop("Units")
            row["tagname"] = row.pop("Tagname")
            row["tagname"] = (
                rdas[id]["tagname"] if not row["tagname"] else row["tagname"]
            )
            row["nutr_desc"] = row.pop("NutrDesc")
            row["anti_nutrient"] = rdas[id]["anti_nutrient"]
            row["num_dec"] = row.pop("Num_Dec")
            row["sr_order"] = row.pop("SR_Order")
            row["flav_class"] = None
            # Add to list
            result.append(row.copy())
        return result

    def process_si(rows):
        result = []
        for row in rows:
            if "Nutr_No" in row:
                row["Nutr_no"] = row.pop("Nutr_No")
            if "Units" in row:
                row["Unit"] = row.pop("Units")
            if "Nutrient name" in row:
                row["NutrDesc"] = row.pop("Nutrient name")
            id = int(row["Nutr_no"])

            # Adjust && Insert
            row["id"] = row.pop("Nutr_no")
            row["rda"] = rdas[id]["rda"]
            row["unit"] = row.pop("Unit")
            row["tagname"] = (
                row.pop("Tagname") if "Tagname" in row else rdas[id]["tagname"]
            )
            row["tagname"] = (
                rdas[id]["tagname"] if not row["tagname"] else row["tagname"]
            )
            row["nutr_desc"] = row.pop("NutrDesc")
            row["anti_nutrient"] = rdas[id]["anti_nutrient"]
            row["num_dec"] = row.pop("Num_Dec") if "Num_Dec" in row else None
            row["sr_order"] = row.pop("SR_Order") if "SR_Order" in row else None
            row["flav_class"] = row.pop("Flav_Class") if "Flav_Class" in row else None
            # Add to list
            result.append(row)
        return result

    #########################
    # Prepare the rows
    result = []

    # Main USDA files
    main_nutr = "SR-Leg_DB/NUTR_DEF.csv"
    print(main_nutr)
    with open(main_nutr) as file:
        reader = csv.DictReader(file)
        rows = list(reader)
        rows = process_main(rows)
        # Add to final solution
        result.extend(rows)

    # Special interests DB
    for dir in special_interests_dirs:
        sub_nutr = f"{dir}/NUTR_DEF.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.DictReader(file)
            rows = list(reader)
            rows = process_si(rows)
            # Add to final solution
            result.extend(rows)

    #########################
    # Write out result
    with open("nt/nutr_def.csv", "w+") as file:
        fieldnames = list(result[0].keys())
        writer = csv.DictWriter(file, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(result)


# -----------------
# Nutrient data
# -----------------
def process_nut_data():
    #
    # Prepare the rows
    result = []

    # Main USDA files
    main_nutr = "SR-Leg_DB/NUT_DATA.csv"
    print(main_nutr)
    with open(main_nutr) as file:
        reader = csv.reader(file)
        rows = list(reader)
        # Add to final solution
        for row in rows:
            result.append(row)

    # Special interests DB
    for dir in special_interests_dirs:
        sub_nutr = f"{dir}/NUT_DATA.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.reader(file)
            rows = list(reader)
            # Add to final solution
            for row in rows[1:]:
                _row = None * 17
                _row[0] = row[0]  # food_id
                _row[1] = row[1]  # nutr_id
                _row[2] = row[2]  # nutr_val
                _row[3] = row[4]  # num_data_pts
                _row[4] = row[3]  # std_err / std_dev
                _row[5] = row[8]  # data_src_id
                _row[10] = row[5]  # min
                _row[11] = row[6]  # max
                _row[?] = row[7]  # CC
                result.append(_row)

    #########################
    # Write out result
    with open("nt/nut_data.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(result)


# -----------------
# Food description
# -----------------
def process_food_des():
    #
    # Prepare the rows
    result = []
    food_ids = set()

    # Main USDA files
    main_nutr = "SR-Leg_DB/FOOD_DES.csv"
    print(main_nutr)
    with open(main_nutr) as file:
        reader = csv.reader(file)
        rows = list(reader)
        # Add to final solution
        for i, row in enumerate(rows):
            if i > 0:
                food_ids.add(int(row[0]))
            result.append(row)

    # Special interests DB
    for dir in special_interests_dirs:
        sub_nutr = f"{dir}/FOOD_DES.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.reader(file)
            rows = list(reader)
            # Add to final solution
            for _row in rows[1:]:
                food_id = int(_row[0])

                # Don't add dupes
                if food_id not in food_ids:
                    print(f"new food: {food_id} {_row[2]}")
                    food_ids.add(food_id)
                    # Set new row
                    row = [None] * 14
                    row[0] = food_id
                    row[1] = _row[1]  # Food group
                    row[2] = _row[2]  # Long Desc
                    if len(_row) > 3:
                        row[4] = _row[3]  # Comm/sci name
                    result.append(row)

    #########################
    # Write out result
    with open("nt/food_des.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(result)


# -----------------
# Data sources
# -----------------
def process_data_srcs():
    #
    # Prepare the rows
    data_src = []
    datsrcln = []

    # Main USDA files
    main_data_src = "SR-Leg_DB/DATA_SRC.csv"
    main_datsrcln = "SR-Leg_DB/DATSRCLN.csv"
    print(main_data_src)
    print(main_datsrcln)
    with open(main_data_src) as file_src, open(main_datsrcln) as file_ln:
        reader_src = csv.reader(file_src)
        data_src_rows = list(reader_src)
        reader_ln = csv.reader(file_ln)
        datsrcln_rows = list(reader_ln)

        # Add to final solution
        for row in data_src_rows:
            data_src.append(row)
        for row in datsrcln_rows:
            datsrcln.append(row)

    # Special interests DB
    for dir in special_interests_dirs:
        # DATA_SRC.csv
        sub_nutr = f"{dir}/DATA_SRC.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.reader(file)
            rows = list(reader)
            # Add to final solution
            for _row in rows[1:]:
                # Special rules
                if sub_nutr == "SR-Leg_DB/isoflav/DATA_SRC.csv":
                    _row.insert(0, _row.pop())  # isoflav has DataSrc_ID at end
                    _row.insert(6, None)  # Issue_State
                # Add to final solution
                data_src.append(_row)

        # DATASRCLN.csv
        sub_nutr = f"{dir}/DATSRCLN.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.reader(file)
            rows = list(reader)
            # Add to final solution
            for _row in rows[1:]:
                datsrcln.append(_row)

    ##################################################
    # Write serv_desc and serving tables
    with open("nt/data_src.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(data_src)
    with open("nt/datsrcln.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(datsrcln)


# -----------------
# Weight
# -----------------
def process_weight(rows, fname):

    # Unique qualifiers
    msre_ids = {}
    servings_set = set()

    # CSV rows
    serv_desc = [["id", "msre_desc"]]
    serving = [["food_id", "msre_id", "grams", "num_data_pts", "std_dev"]]

    #
    # Main logic
    id = 1
    for row in rows[1:]:
        # Process row
        food_id = int(row[0])
        amount = float(row[2])
        if amount <= 0:
            continue
        msre_desc = row[3]
        grams = float(row[4])
        grams /= amount
        num_data_pts = row[5]
        std_dev = row[6]

        # Get key if used previously
        if msre_desc not in msre_ids:
            serv_desc.append([id, msre_desc])
            msre_ids[msre_desc] = id
            id += 1
        msre_id = msre_ids[msre_desc]

        # Handles some weird duplicates, e.g.
        # ERROR:  duplicate key value violates unique constraint "servings_pkey"
        # DETAIL:  Key (food_id, msre_id)=(1036, 3) already exists.
        prim_key = (food_id, msre_id)
        if prim_key not in servings_set:
            serving.append([food_id, msre_id, grams, num_data_pts, std_dev])
            servings_set.add(prim_key)

    ##################################################
    # Write serv_desc and serving tables
    with open("nt/serv_desc.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(serv_desc)
    with open("nt/serving.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(serving)


#
# Make script executable
if __name__ == "__main__":
    main(sys.argv[1:])
