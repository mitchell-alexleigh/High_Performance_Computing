DROP TABLE IF EXISTS oshWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS oshWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/Oshkosh' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS iowaWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS iowaWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/IowaCity' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS OshSummary;

CREATE VIEW OshSummary AS SELECT CASE WHEN month IN (12,1,2) THEN 'W' WHEN month IN (3,4,5) THEN 'Sp' WHEN month IN (6,7,8) THEN 'Su' WHEN month IN (9,10,11) THEN 'F' END season, sum(tempf)/count(timecst) avg_temp FROM oshWeather WHERE tempF >= -100 GROUP BY CASE WHEN month IN (12,1,2) THEN 'W' WHEN month IN (3,4,5) THEN 'Sp' WHEN month IN (6,7,8) THEN 'Su' WHEN month IN (9,10,11) THEN 'F' END; 

DROP VIEW IF EXISTS iowaSummary;

CREATE VIEW iowaSummary AS SELECT CASE WHEN month IN (12,1,2) THEN 'W' WHEN month IN (3,4,5) THEN 'Sp' WHEN month IN (6,7,8) THEN 'Su' WHEN month IN (9,10,11) THEN 'F' END season, sum(tempf)/count(timecst) avg_temp FROM iowaWeather WHERE tempF >= -100 GROUP BY CASE WHEN month IN (12,1,2) THEN 'W' WHEN month IN (3,4,5) THEN 'Sp' WHEN month IN (6,7,8) THEN 'Su' WHEN month IN (9,10,11) THEN 'F' END; 

SELECT o.season, o.avg_temp-i.avg_temp temp_diff FROM OshSummary o JOIN IowaSummary i on i.season = o.season;
