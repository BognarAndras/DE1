--  Analytical Layer 1: Peaks reached with group leaders avaliable

SELECT p.peak_id, p.peak_name, p.height_metres, p.first_ascent_country, e.highpoint_date, e.members, e.hired_staff, e.member_deaths, m.age, m.citizenship
FROM peaks_fixed AS p
INNER JOIN expeditions AS e
ON p.first_ascent_expedition_id = e.expedition_id
AND p.climbing_status = 'Climbed'
INNER JOIN members_fixed AS m
ON e.expedition_id = m.expedition_id 
AND m.expedition_role = 'Leader';
--  468 peaks
SELECT *
FROM peaks_fixed AS p;
-- 333 with expedition_id 
SELECT p.peak_name, p.height_metres, p.first_ascent_country
FROM peaks_fixed AS p
INNER JOIN expeditions AS e
ON p.first_ascent_expedition_id = e.expedition_id;





DROP PROCEDURE IF EXISTS CreatePeaksReached;

DELIMITER $$

CREATE PROCEDURE CreatePeaksReached()
BEGIN

	DROP TABLE IF EXISTS peaks_reached;

	CREATE TABLE peaks_reached AS
	SELECT 	p.peak_id,
			p.peak_name, 
			p.height_metres AS peak_height, 
            p.first_ascent_country AS expedition_countries, 
            e.highpoint_date AS date_of_reach, 
            e.members AS expedition_size, 
            e.hired_staff AS supporting_staff_size, 
            e.member_deaths AS expedition_deaths, 
            m.age AS leader_age, 
            REPLACE(m.citizenship,' ','_') AS leader_country
	FROM 
		peaks_fixed AS p
	INNER JOIN 
		expeditions AS e
	ON 
		p.first_ascent_expedition_id = e.expedition_id
	AND 
		p.climbing_status = 'Climbed'
	INNER JOIN 
		members_fixed AS m
	ON 
		e.expedition_id = m.expedition_id 
	AND 
		m.expedition_role = 'Leader'
	ORDER BY 
		p.peak_name;

END $$
DELIMITER ;


CALL CreatePeaksReached();
SELECT * FROM peaks_reached;



DROP TRIGGER IF EXISTS Peak_Reached; 

DELIMITER $$

CREATE TRIGGER Peak_Reached
AFTER UPDATE
ON peaks_fixed FOR EACH ROW
BEGIN

	-- archive the order and assosiated table entries to product_sales
    INSERT INTO peaks_reached
	SELECT 	p.peak_id,
			p.peak_name, 
			p.height_metres AS peak_height, 
            p.first_ascent_country AS expedition_countries, 
            e.highpoint_date AS date_of_reach, 
            e.members AS expedition_size, 
            e.hired_staff AS supporting_staff_size, 
            e.member_deaths AS expedition_deaths, 
            m.age AS leader_age, 
            REPLACE(m.citizenship,' ','_') AS leader_country
	FROM 
		peaks_fixed AS p
	INNER JOIN 
		expeditions AS e
	ON 
		p.first_ascent_expedition_id = e.expedition_id
	AND 
		p.climbing_status = 'Climbed'
	INNER JOIN 
		members_fixed AS m
	ON 
		e.expedition_id = m.expedition_id 
	WHERE p.peak_id = NEW.peak_id
	AND 
		m.expedition_role = 'Leader'
	ORDER BY 
		p.peak_name;
        
END $$

DELIMITER ;

-- Testing 
SHOW TRIGGERS;
SELECT * FROM peaks_reached;
--  324 ROWS!
-- Neccessary information added: Dhaulagiri   https://explorersweb.com/2020/06/09/a-brief-climbing-history-of-nepals-highest-peaks/
-- 1960, May 13, by the Swiss Austrian Expedition 

INSERT INTO expeditions VALUES('DGAR00001','DGAR','Dhaulagiri',1960,'Spring','1900-01-01','1960-05-13','1900-01-01','Success (main peak)',6638,1,0,6,0,0,'Unknown');
INSERT INTO members_fixed VALUES('DGAR00001','DGAR00001-01','DGAR','Dhaulagiri',1960,'Spring','M',9999999,'Swiss','Leader',6,6638,1,0,0,0,'Unknown',9999999,0,'Unknown',9999999);
-- Update made:
UPDATE peaks_fixed
SET 
climbing_status = 'Climbed',
first_ascent_year = 1960,
first_ascent_expedition_id = 'DGAR00001'
WHERE peak_id = 'DGAR';

SELECT * FROM peaks_reached;
-- 325 Rows!
-- To replicate revert change, call table and update again.

UPDATE peaks_fixed
SET 
climbing_status = 'Climbed',
first_ascent_expedition_id = 'Unknown'
WHERE peak_id = 'DGAR';
CALL CreatePeaksReached();