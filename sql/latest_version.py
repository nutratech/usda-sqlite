#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar  2 12:32:45 2024

@author: shane
"""

import csv
import os

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))

try:
    version_csv_path = os.path.join(
        SCRIPT_DIR, "version.csv"
    )

    rows = []
    with open(version_csv_path, "r", encoding="utf-8") as _r_file:
        reader = csv.reader(_r_file)
        rows = list(reader)

    print(rows[-1][15], end="")
except Exception as exc:
    # Failed, so we return empty version
    pass
