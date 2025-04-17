DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS funds;

--create view to join and summarize tables 
CREATE VIEW funds AS SELECT m.fname first_name,m.lname last_name, AVG(e.close) avg_close FROM meta m JOIN etfs e on m.fund = e.fund GROUP BY m.fname, m.lname;

--order the average close from hightest to lowest and get the top value 
SELECT first_name,last_name FROM (SELECT funds.first_name, funds.last_name ,funds.avg_close FROM funds ORDER BY funds.avg_close DESC LIMIT 1) x;