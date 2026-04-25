# California-Wildfire-AQ-Analysis
### 〜サバイバルDX：BigQueryとQGISで紐解く、火災と気流の相関分析〜

![Thumbnail](https://via.placeholder.com/1280x720.png?text=California+Wildfire+x+Air+Quality+Analysis) ## 1. 概要
本プロジェクトは、Google Cloud Platform (BigQuery) の公開データセットを活用し、2020年に発生したカリフォルニア史上最大規模の山火事が大気質（PM2.5）に与えた影響を可視化・分析したものです。

単なるデータのプロットに留まらず、気象データ（Windy）を組み合わせることで、「汚染物質が気流に乗ってどのように移動し、どこに滞留したか」という**移流リスク**を浮き彫りにすることを目的としています。

### コンセプト：サバイバルDX
「限られた装備（低スペックPC / Chromebook）で、いかにプロフェッショナルな知略を導き出すか」をテーマに、リソースを最小限に抑えた分析ワークフローを実践しています。

## 2. 使用ツール
- **Google Cloud BigQuery**: 数百万件の公開データ（OpenAQ）からの高速抽出
- **QGIS (Linux on ChromeOS)**: 地理空間データの可視化・階層化分析
- **Windy**: 気流・低気圧の挙動解析による仮説検証

## 3. 分析データとSQLクエリ
2020年8月〜9月の山火事ピーク期間に絞り、カリフォルニア沿岸部から内陸にかけてのPM2.5濃度を抽出します。

```sql
SELECT
  location,
  latitude,
  longitude,
  -- 2020年8月〜9月の平均PM2.5濃度
  AVG(value) AS avg_pm25_wildfire,
  -- 最大値（ピーク時）
  MAX(value) AS max_pm25
FROM
  `bigquery-public-data.openaq.global_air_quality`
WHERE
  country = 'US'
  AND pollutant = 'pm25'
  AND timestamp BETWEEN '2020-08-01' AND '2020-09-30'
  -- カリフォルニア州をカバーする緯度経度範囲
  AND latitude BETWEEN 32 AND 42
  AND longitude BETWEEN -124 AND -114
GROUP BY
  1, 2, 3
HAVING
  avg_pm25_wildfire > 0
ORDER BY
  avg_pm25_wildfire DESC
