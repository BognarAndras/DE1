USE peak;
SELECT * FROM peaks_reached;

--  Create a view to see if succesful expeditions had any deaths among members.
DROP VIEW IF EXISTS Fatal_Expeditions;

CREATE VIEW `Fatal_Expeditions` AS
SELECT expedition_deaths, peak_name, peak_height, date_of_reach, expedition_size, supporting_staff_size, leader_age FROM peaks_reached WHERE expedition_deaths != 0
ORDER BY expedition_deaths DESC;

SELECT * FROM Fatal_Expeditions;
SELECT SUM(expedition_deaths) AS Total_Fatalities FROM Fatal_Expeditions;
SELECT COUNT(expedition_deaths) AS Fatal_Expeditions FROM Fatal_Expeditions;
-- See how many peaks were first reached in this century.
DROP VIEW IF EXISTS 21_Century;

CREATE VIEW `21_Century` AS
SELECT date_of_reach, peak_name, peak_height, expedition_countries, leader_country FROM peaks_reached WHERE YEAR(date_of_reach) >= 2000
ORDER BY date_of_reach DESC;

SELECT * FROM 21_Century;
SELECT COUNT(date_of_reach) AS Number_of_Records_In_21_Cen FROM 21_Century;
-- Answer: 129 out of 325.
-- Finally, see how many of the peaks conquered are above 8.5 km. 
DROP VIEW IF EXISTS Heights;

CREATE VIEW `Heights` AS
SELECT peak_name, peak_height,
	CASE WHEN 8500 < peak_height THEN 'Highest Peaks'
	WHEN 6500 < peak_height <= 8500 THEN 'Tall Peaks'
    ELSE 'Elevated Peaks'
	END
    AS Height_category
FROM peaks_reached 
ORDER BY peak_height DESC;

SELECT * FROM Heights;
SELECT COUNT(Height_category) AS Heighest_Peak_Count FROM Heights WHERE Height_category = 'Highest Peaks';
-- Answer: 4.

-- Finally which country produced the most succesful leaders? 
DROP VIEW IF EXISTS Leaders;

CREATE VIEW `Leaders` AS
SELECT leader_country, leader_age, peak_name, expedition_countries
FROM peaks_reached 
ORDER BY leader_country;

SELECT * FROM Leaders;
SELECT leader_country, COUNT(leader_country) AS Number_of_Success
FROM peaks_reached 
GROUP BY leader_country 
ORDER BY Number_of_Success DESC;
SELECT leader_country, AVG(leader_age) AS AVG_Age 
FROM peaks_reached 
WHERE leader_age != 9999999
GROUP BY leader_country 
ORDER BY AVG_Age;
-- 100 successful missions lead by Japan solely.