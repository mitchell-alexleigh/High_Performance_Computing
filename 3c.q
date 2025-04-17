DROP TABLE IF EXISTS games;

CREATE EXTERNAL TABLE IF NOT EXISTS games(app_id INT, title STRING, date_release DATE, win BOOLEAN, mac BOOLEAN, linux BOOLEAN, rating STRING, positive_ratio INT, user_reviews INT, price_final FLOAT, price_original FLOAT, discount FLOAT, steam_deck BOOLEAN) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/steam/games' tblproperties ("skip.header.line.count"="1");

SELECT 
    YEAR(date_release) AS year_released
    ,COUNT(CASE WHEN games.rating IN ('Very Positive','Positive') THEN 1 END)/ COUNT (1) * 100 AS Positive_Percent
FROM games
WHERE YEAR(date_release) >= 2013
GROUP BY YEAR(date_release)
ORDER BY year_released DESC
;