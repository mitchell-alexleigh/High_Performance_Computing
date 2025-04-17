DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

SELECT fund FROM (SELECT x.fund, x.avg_volume, DENSE_RANK() OVER (ORDER BY x.avg_volume DESC) rank FROM (SELECT fund, AVG(volume) avg_volume FROM etfs where year = 2013 GROUP BY fund)x ) y WHERE RANK = 3; 
