-- NOTE: need to first run: fetch.sh
.load ./extensions/stats
-- Saves time intensive query in new table
CREATE TABLE nutrients_overview AS
SELECT
  id,
  rda,
  unit,
  tagname,
  nutr_desc,
  CAST(COUNT(nut_data.nutr_id) AS INTEGER) AS n_foods,
  CAST(ROUND(avg(nut_data.nutr_val), 3) AS real) AS avg_val,
  CAST(ROUND(stddev(nut_data.nutr_val), 2) AS real) AS std_dev
FROM
  nutr_def
  INNER JOIN nut_data ON nut_data.nutr_id = id
GROUP BY
  id
ORDER BY
  id;
