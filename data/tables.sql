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

CREATE TABLE nutr_def (
  id integer PRIMARY KEY AUTOINCREMENT,
  rda float,
  unit text NOT NULL,
  tagname text,
  nutr_desc text,
  anti_nutrient boolean,
  num_dec int,
  sr_order int,
  flav_class text
);

CREATE TABLE fdgrp (
  id integer PRIMARY KEY AUTOINCREMENT,
  fdgrp_desc text NOT NULL
);

CREATE TABLE food_des (
  id integer PRIMARY KEY AUTOINCREMENT,
  fdgrp_id int,
  long_desc text,
  shrt_desc text,
  com_name text,
  manufac_name text,
  survey text,
  ref_desc text,
  refuse int,
  sci_name text,
  n_factor FLOAT,
  pro_factor_ FLOAT,
  fat_factor_ FLOAT,
  cho_factor FLOAT,
  FOREIGN KEY (fdgrp_id) REFERENCES fdgrp (id)
);

CREATE TABLE src_cd (
  id text PRIMARY KEY,
  description text NOT NULL
);

CREATE TABLE deriv_cd (
  id text PRIMARY KEY,
  description text NOT NULL
);

CREATE TABLE nut_data (
  NDB_No text,
  Nutr_No text,
  Nutr_Val double,
  Num_Data_Pts int,
  Std_Error double,
  Src_Cd text,
  Deriv_Cd text,
  Ref_NDB_No text,
  Add_Nutr_Mark text,
  Num_Studies LONG,
  Min double,
  Max double,
  DF LONG,
  Low_EB double,
  Up_EB double,
  Stat_Cmt text,
  AddMod_Date text
);

CREATE TABLE lang_desc (
  id text PRIMARY KEY,
  description text
);

CREATE TABLE langual (
  food_id int NOT NULL,
  factor_id text NOT NULL,
  FOREIGN KEY (food_id) REFERENCES food_des (id),
  FOREIGN KEY (factor_id) REFERENCES lang_desc (id)
);

CREATE TABLE data_src (
  id text PRIMARY KEY,
  authors text,
  title text,
  year text,
  journal text,
  vol_city text,
  issue_state text,
  start_page text,
  end_page text
);

CREATE TABLE datsrcln (
  food_id int NOT NULL,
  nutr_id int NOT NULL,
  data_src_id text NOT NULL,
  FOREIGN KEY (food_id) REFERENCES food_des (id),
  FOREIGN KEY (nutr_id) REFERENCES nutr_def (id),
  FOREIGN KEY (data_src_id) REFERENCES data_src (id)
);

CREATE TABLE footnote (
  food_id int NOT NULL,
  footnt_no int NOT NULL,
  footnt_typ text NOT NULL,
  nutr_id int,
  footnt_txt text NOT NULL,
  FOREIGN KEY (food_id) REFERENCES food_des (id),
  FOREIGN KEY (nutr_id) REFERENCES nutr_def (id)
);

CREATE TABLE serv_desc (
  id integer PRIMARY KEY AUTOINCREMENT,
  msre_desc text NOT NULL
);

CREATE TABLE serving (
  food_id int NOT NULL,
  msre_id int NOT NULL,
  grams float NOT NULL,
  num_data_pts int,
  st_dev float,
  FOREIGN KEY (msre_id) REFERENCES serv_desc (id)
);

