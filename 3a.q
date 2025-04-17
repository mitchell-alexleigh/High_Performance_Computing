DROP TABLE IF EXISTS games;

CREATE EXTERNAL TABLE IF NOT EXISTS games(app_id INT, title STRING, date_release STRING, win BOOLEAN, mac BOOLEAN, linux BOOLEAN, rating STRING, positive_ratio INT, user_reviews INT, price_final FLOAT, price_original FLOAT, discount FLOAT, steam_deck BOOLEAN) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/steam/games' tblproperties ("skip.header.line.count"="1");

SELECT 
  ROUND(COUNT(CASE WHEN games.win = TRUE AND games.rating IN ('Very Positive','Positive') THEN games.app_id END) / COUNT(CASE WHEN games.win = TRUE THEN games.app_id END) , 4) * 100 AS windows
  ,ROUND(COUNT(CASE WHEN games.mac = TRUE AND games.rating IN ('Very Positive','Positive') THEN games.app_id END) / COUNT(CASE WHEN games.mac = TRUE THEN games.app_id END), 4) * 100 AS mac
  ,ROUND(COUNT(CASE WHEN games.linux = TRUE AND games.rating IN ('Very Positive','Positive') THEN games.app_id END) / COUNT(CASE WHEN games.linux = TRUE THEN games.app_id END), 4) * 100 AS linux
FROM games
;