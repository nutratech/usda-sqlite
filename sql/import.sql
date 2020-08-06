.mode csv

.import '| tail -n +2 nt_ver.csv' nt_ver

.import '| tail -n +2 ../data/nt/nutr_def.csv' nutr_def
.import '| tail -n +2 ../data/nt/fdgrp.csv' fdgrp
.import '| tail -n +2 ../data/nt/food_des.csv' food_des


.import '| tail -n +2 ../data/nt/src_cd.csv' src_cd
.import '| tail -n +2 ../data/nt/deriv_cd.csv' deriv_cd
.import '| tail -n +2 ../data/nt/nut_data.csv' nut_data


.import '| tail -n +2 ../data/nt/lang_desc.csv' lang_desc
.import '| tail -n +2 ../data/nt/langual.csv' langual

.import '| tail -n +2 ../data/nt/data_src.csv' data_src
.import '| tail -n +2 ../data/nt/datsrcln.csv' datsrcln

.import '| tail -n +2 ../data/nt/serv_desc.csv' serv_desc
.import '| tail -n +2 ../data/nt/serving.csv' serving

.import '| tail -n +2 ../data/nt/footnote.csv' footnote

.header on
.mode column
