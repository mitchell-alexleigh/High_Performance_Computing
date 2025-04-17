DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

--get fund for etfs with the most trade days 
SELECT fund from (SELECT e.fund, COUNT(CONCAT(e.year,'-',e.month,'-',e.day)) trade_days FROM etfs e WHERE low > 20 and high < 30 GROUP BY e.fund ORDER BY trade_days DESC LIMIT 1) x;