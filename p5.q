
DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

SELECT year, month FROM (SELECT year, month, day_count, DENSE_RANK() OVER (ORDER BY x.day_count) rank FROM (SELECT year, month, count(DISTINCT day) day_count FROM etfs GROUP BY year,month)x)y WHERE rank = 3;