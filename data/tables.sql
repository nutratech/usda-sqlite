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

