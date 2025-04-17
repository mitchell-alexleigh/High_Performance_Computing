DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

--select fund where the average difference between high and low is greates and the founding year is greater than 1920
SELECT fund FROM (SELECT m.fund fund, AVG(e.high-e.low) avg_diff FROM meta m JOIN etfs e on m.fund = e.fund WHERE m.year > 1920 GROUP BY m.fund ORDER BY avg_diff DESC LIMIT 1)x;
