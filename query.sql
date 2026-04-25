SELECT
  location,
  latitude,
  longitude,
  -- 山火事期間中の平均PM2.5濃度
  AVG(value) AS avg_pm25_wildfire,
  -- 期間中の最大値（ピーク時）
  MAX(value) AS max_pm25
FROM
  `bigquery-public-data.openaq.global_air_quality`
WHERE
  country = 'US'
  AND pollutant = 'pm25'
  AND timestamp BETWEEN '2020-08-01' AND '2020-09-30'
  -- カリフォルニア州周辺の緯度経度範囲に限定
  AND latitude BETWEEN 32 AND 42
  AND longitude BETWEEN -124 AND -114
GROUP BY
  1, 2, 3
HAVING
  avg_pm25_wildfire > 0
ORDER BY
  avg_pm25_wildfire DESC
