DROP TABLE IF EXISTS recommendations;

CREATE EXTERNAL TABLE IF NOT EXISTS recommendations(app_id INT, helpful INT,funny INT,review_date STRING, is_recommended BOOLEAN, hours INT, user_id INT, review_id INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/steam/recommendations' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS user_groups;

CREATE VIEW user_groups AS
SELECT 
	u.user_id
	,(CASE WHEN u.products > AVG(u.products) OVER (PARTITION BY 1) THEN 'TRUE' ELSE 'FALSE' END) AS over_average
FROM users u
;

DROP VIEW IF EXISTS recommendations_100000;

CREATE VIEW recommendations_100000 AS
SELECT r.app_id, SUM(hours) total_hours, COUNT(user_id) total_users 
FROM recommendations r
GROUP BY r.app_id
HAVING COUNT(CASE WHEN r.is_recommended = TRUE THEN 1 END) > 100000
;

SELECT sum(total_hours) / sum(total_users)
FROM recommendations_100000
;


