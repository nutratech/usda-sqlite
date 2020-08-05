.mode csv

.import '| tail -n +2 nt/nutr_def.csv' nutr_def
.import '| tail -n +2 nt/fdgrp.csv' fdgrp
.import '| tail -n +2 nt/food_des.csv' food_des


.import '| tail -n +2 nt/src_cd.csv' src_cd
.import '| tail -n +2 nt/deriv_cd.csv' deriv_cd
.import '| tail -n +2 nt/nut_data.csv' nut_data


.import '| tail -n +2 nt/lang_desc.csv' lang_desc
.import '| tail -n +2 nt/langual.csv' langual

.import '| tail -n +2 nt/data_src.csv' data_src
.import '| tail -n +2 nt/datsrcln.csv' datsrcln

.import '| tail -n +2 nt/serv_desc.csv' serv_desc
.import '| tail -n +2 nt/serving.csv' serving

.import '| tail -n +2 nt/footnote.csv' footnote

.header on
.mode column
