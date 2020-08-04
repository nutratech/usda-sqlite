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

import csv
import os
import sys

# change to script's dir
os.chdir(os.path.dirname(os.path.abspath(__file__)))
os.makedirs("nt", 0o755, True)


# --------------------
# io dict
# --------------------
output_files = {
    "SR-Leg_DB/FD_GROUP.csv": "nt/fdgrp.csv",
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
    process_nut_data()
    process_food_des()

    for fname in output_files:
        print(fname)
        # Open the CSV file
        with open(fname) as file:
            reader = csv.reader(file)
            rows = list(reader)
        #
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
            result.append(row[:3])

    # Special interests DB
    for dir in special_interests_dirs:
        sub_nutr = f"{dir}/NUT_DATA.csv"
        print(sub_nutr)
        with open(sub_nutr) as file:
            reader = csv.reader(file)
            rows = list(reader)
            # Add to final solution
            for row in rows[1:]:
                result.append(row[:3])

    #
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
        for i, _row in enumerate(rows):
            if i > 0:
                food_ids.add(int(_row[0]))
            row = _row[:10]
            del row[6]
            row.insert(2, 1)  # Data src
            row.append(None)  # user_id
            row.append(True)  # is_shared
            result.append(row)
            # result.append(row[:3])

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
                    row = [None] * 12
                    row[0] = food_id
                    row[1] = _row[1]  # Food group
                    row[2] = 2  # Data src
                    row[3] = _row[2]  # Long Desc
                    if len(_row) > 3:
                        row[5] = _row[3]  # Sci name
                    row[11] = True  # is_shared
                    result.append(row)

    #
    # Write out result
    with open("nt/food_des.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(result)


# -----------------
# Weight
# -----------------
def process_weight(rows, fname):

    # Unique qualifiers
    msre_ids = {}
    servings_set = set()

    # CSV rows
    serving_id = [["id", "msre_desc"]]
    servings = [["food_id", "msre_id", "grams"]]

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

        # Get key if used previously
        if msre_desc not in msre_ids:
            serving_id.append([id, msre_desc])
            msre_ids[msre_desc] = id
            id += 1
        msre_id = msre_ids[msre_desc]

        # Handles some weird duplicates, e.g.
        # ERROR:  duplicate key value violates unique constraint "servings_pkey"
        # DETAIL:  Key (food_id, msre_id)=(1036, 3) already exists.
        prim_key = (food_id, msre_id)
        if prim_key not in servings_set:
            servings.append([food_id, msre_id, grams])
            servings_set.add(prim_key)

    #
    # Write serving_id and servings tables
    with open("nt/serving_id.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(serving_id)
    with open("nt/servings.csv", "w+") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerows(servings)


#
# Make script executable
if __name__ == "__main__":
    main(sys.argv[1:])
