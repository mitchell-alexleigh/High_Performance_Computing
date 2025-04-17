DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

--get first name, last name, fund, date, and if the day was profiable 
CREATE VIEW profit_days AS SELECT CONCAT(m.fname,' ',m.lname) full_name, m.fund, CONCAT(e.year,'-',e.month,'-',e.day)trade_date, CASE WHEN close > open then 1 else 0 END profitable FROM meta m JOIN etfs e ON m.fund = e.fund;  

--get name for fund with most trading days  
SELECT full_name FROM (SELECT full_name, fund, COUNT(DISTINCT trade_date) trade_days, DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT trade_date) DESC) rank FROM profit_days WHERE profitable = 1 GROUP BY full_name,fund)x WHERE x.rank = 1;