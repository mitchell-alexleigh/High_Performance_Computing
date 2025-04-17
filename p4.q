DROP TABLE IF EXISTS meta;

CREATE EXTERNAL TABLE IF NOT EXISTS meta(fund STRING, fname STRING, lname STRING, year INT, month INT, city STRING, STATE STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/metadata' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS etfs;

CREATE EXTERNAL TABLE etfs(fund STRING, year INT, month INT, day INT, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, openint INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/financial' tblproperties ("skip.header.line.count"="1");

--get max volumn for each state
CREATE VIEW etfs_details AS SELECT m.state, MAX(e.volume) max_state_volumn FROM meta m JOIN etfs e on m.fund = e.fund GROUP BY STATE;

--get state where the state max volumne is equal to the overall max volumn
SELECT ed.state FROM etfs_details ed JOIN (SELECT MAX(e.volume) overall_max_volume FROM etfs) e on ed.max_state_volumn = e.overall_max_volume;