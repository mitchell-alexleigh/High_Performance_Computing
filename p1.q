DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

SELECT COUNT(DISTINCT city) as distinctCities FROM meta;
