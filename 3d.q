DROP TABLE IF EXISTS games;

CREATE EXTERNAL TABLE IF NOT EXISTS games(app_id INT, title STRING, date_release STRING, win BOOLEAN, mac BOOLEAN, linux BOOLEAN, rating STRING, positive_ratio INT, user_reviews INT, price_final FLOAT, price_original FLOAT, discount FLOAT, steam_deck BOOLEAN) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/steam/games' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS recommendations;

CREATE EXTERNAL TABLE IF NOT EXISTS recommendations(app_id INT, helpful INT,funny INT,review_date DATE, is_recommended BOOLEAN, hours INT, user_id INT, review_id INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/steam/recommendations' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS game_price_group;

CREATE VIEW game_price_group AS 
SELECT app_id, ROUND((price_final/10),0)*10 AS price_group
FROM games
;

DROP VIEW IF EXISTS app_reviews_2022;

CREATE VIEW app_reviews_2022 AS 
SELECT app_id, count(review_id) reviews
FROM recommendations
WHERE YEAR(review_date) = 2022
GROUP BY app_id
;

SELECT g.price_group, sum(a.reviews)/count(a.app_id) AS reviews_per_app
FROM game_price_group g
JOIN app_reviews_2022 a on a.app_id = g.app_id
GROUP BY g.price_group
;