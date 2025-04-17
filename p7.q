DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

--get the fund and the year from fund, year, avgerage closing price from Jan through Jun for lowest average closing 

SELECT fund, year FROM (SELECT fund, year, AVG(close), DENSE_RANK() OVER (ORDER BY AVG(close)) rank FROM etfs WHERE month <=6 GROUP BY fund,year) x WHERE x.rank >=5;