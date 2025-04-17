DROP TABLE IF EXISTS oshWeather;

CREATE EXTERNAL TABLE IF NOT EXISTS oshWeather(year INT, month INT, day INT, timeCST STRING, tempF FLOAT, dewPoint FLOAT, humidity INT, seaLevel FLOAT, visibilityMPH INT, windDirection STRING, windSpeed STRING, gustSpeed STRING, precipitation STRING, events STRING, conditions STRING, windDirDegrees INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/final/Oshkosh' tblproperties ("skip.header.line.count"="1");

DROP VIEW IF EXISTS oshWeatherDays;

CREATE VIEW oshWeatherDays AS SELECT CONCAT(year,'-',month,'-',day) AS weatherDate, tempF FROM oshWeather WHERE tempF >= -100;

SELECT COUNT(DISTINCT CASE WHEN tempF <=-10 THEN weatherDate END) AS cold_days, COUNT(DISTINCT CASE WHEN tempF >=95 THEN weatherDate END) AS hot_days FROM oshweatherdays;
