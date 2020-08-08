-- nt-sqlite, an sqlite3 database for nutratracker clients
-- Copyright (C) 2020  Shane Jaroch <nutratracker@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
