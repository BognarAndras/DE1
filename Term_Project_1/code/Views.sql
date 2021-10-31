USE peak;
SELECT * FROM peaks_reached;

DROP VIEW IF EXISTS Fatal_Expeditions;

CREATE VIEW `Fatal_Expeditions` AS
SELECT * FROM peaks_reached WHERE expedition_deaths != 0
ORDER BY expedition_deaths DESC;

SELECT * FROM Fatal_Expeditions;
SELECT SUM(expedition_deaths) AS Total_Fatalities FROM Fatal_Expeditions;
SELECT COUNT(expedition_deaths) AS Fatal_Expeditions FROM Fatal_Expeditions;

DROP VIEW IF EXISTS 21_Century;

CREATE VIEW `21_Century` AS
SELECT * FROM peaks_reached WHERE YEAR(date_of_reach) >= 2000
ORDER BY date_of_reach DESC;

SELECT * FROM 21_Century;
SELECT COUNT(date_of_reach) AS Number_of_Records_In_21_Cen FROM 21_Century;
