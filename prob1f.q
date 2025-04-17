DROP TABLE IF EXISTS oshWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS oshWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/Oshkosh' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS iowaWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS iowaWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/IowaCity' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS monthTimeTemp;

CREATE VIEW monthTimeTemp AS
SELECT
	'Osh' AS city
	,month
	,from_unixtime(unix_timestamp(CONCAT(year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a') AS hour
	,AVG(ABS(CAST(windSpeed AS INT))) avgWind
	,AVG(tempF) AS avgTemp
	,ABS(50 - AVG(tempF)) AS FiftyMinusTemp
FROM oshWeather 
WHERE tempF >= -100
GROUP BY 
	month
	,from_unixtime(unix_timestamp(CONCAT(year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a')

UNION

SELECT
	'Iowa' AS city
	,month
	,from_unixtime(unix_timestamp(CONCAT(year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a') AS hour
	,AVG(ABS(CAST(windSpeed AS INT))) avgWind
	,AVG(tempF) AS avgTemp
	,ABS(50 - AVG(tempF)) AS FiftyMinusTemp
FROM iowaWeather 
WHERE tempF >= -100
GROUP BY 
	month
	,from_unixtime(unix_timestamp(CONCAT(year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a')
;


DROP VIEW IF EXISTS monthTempRank;

CREATE VIEW monthTempRank AS
SELECT
	City
	,month
	,hour
	,avgTemp
	,avgWind
	,FiftyMinusTemp
	,DENSE_RANK() OVER (PARTITION BY city,month ORDER BY FiftyMinusTemp) tempRank
FROM monthTimeTemp
;
DROP VIEW IF EXISTS finalRank;

CREATE VIEW finalRank as
SELECT
	City
	,Month
	,hour
	,avgTemp
	,avgWind
	,FiftyMinusTemp
	,DENSE_RANK() OVER (ORDER BY FiftyMinusTemp,avgWind) overall_rank
FROM monthTempRank
WHERE tempRank = 1
;

SELECT 
	City
	,Month
	,hour
FROM finalRank
WHERE overall_rank = 1
;


