# Saves time intensive query in new table
CREATE TABLE nutrients_overview AS
SELECT
  id,
  rda,
  unit,
  tagname,
  nutr_desc,
  COUNT(nut_data.nutr_id) AS n_foods,
  ROUND(avg(nut_data.nutr_val), 3) AS avg_val
FROM
  nutr_def
  INNER JOIN nut_data ON nut_data.nutr_id = id
GROUP BY
  id
ORDER BY
  id;
