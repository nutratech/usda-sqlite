.mode csv

.import '| tail -n +2 nt/nutr_def.csv' nutr_def
.import '| tail -n +2 nt/fdgrp.csv' fdgrp
.import '| tail -n +2 nt/food_des.csv' food_des

.header on
.mode column
