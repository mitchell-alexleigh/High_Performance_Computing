DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");


--create view for city, state, fund, trade_date, % difference where the % difference is greater than or equal to 20%
CREATE VIEW percent_diffs AS SELECT m.fund, m.city city, m.state state, CAST(CONCAT(e.year,'-',e.month,'-',e.day)AS DATE) trade_date, (e.high-e.low) diff, e.close ,((e.high-e.low)/e.close) percent_diff FROM meta m JOIN etfs e on m.fund = e.fund WHERE close != 0 AND close IS NOT NULL AND ((e.high-e.low)/e.close) >= 0.2;

--get city and state for efts with the most number of days from precent_diffs  
SELECT city, state FROM (SELECT pd.city, pd.state, COUNT(trade_date) trade_days FROM percent_diffs pd GROUP BY pd.city, pd.state ORDER BY trade_days DESC LIMIT 1)x;