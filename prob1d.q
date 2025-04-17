DROP TABLE IF EXISTS oshWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS oshWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/Oshkosh' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS datetimeTemp;

CREATE VIEW datetimeTemp AS
SELECT
	CAST(CONCAT(o.year,'-',month,'-',day) AS DATE) AS weatherDate
	,from_unixtime(unix_timestamp(CONCAT(o.year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a') AS hour
	,AVG(tempF) avg_temp
FROM oshWeather o
WHERE tempF >= -100
GROUP BY 
	CAST(CONCAT(o.year,'-',month,'-',day) AS DATE)
	,from_unixtime(unix_timestamp(CONCAT(o.year,'-',month,'-',day, ' ', timeCST),'yyyy-MM-dd hh:mm a'), 'hh a')
;

DROP VIEW IF EXISTS timeTempRank;

CREATE VIEW timeTempRank AS
SELECT 
	weatherDate
	,hour
	,avg_temp
	,DENSE_RANK() OVER (PARTITION BY weatherDate ORDER BY avg_temp) tempRank
FROM datetimeTemp
;

SELECT 
	hour
	,count(hour) AS hourFrequency
FROM timeTempRank
WHERE tempRank = 1
GROUP BY hour
ORDER BY hourFrequency DESC
LIMIT 1
;

