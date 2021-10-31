USE peak;

SELECT * FROM peaks; 
SELECT * FROM members;
SELECT * FROM expeditions;

-- comments 
SELECT distinct first_ascent_country FROM peaks;

SELECT DISTINCT termination_reason FROM expeditions;
-- clear () from here and simplify 


-- clear () from here and simplify to /

DROP PROCEDURE IF EXISTS Separate_Asecnt_Counties; 

DELIMITER $$

CREATE PROCEDURE Separate_Asecnt_Counties ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE first_ascent_country varchar(50) DEFAULT "x";
	DECLARE peak_id varchar(4) DEFAULT 0;

	-- declare cursor for customer
	DECLARE curPeakCounty
		CURSOR FOR 
            		SELECT peaks.peak_id, peaks.first_ascent_country 
				FROM peak.peaks;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPeakCounty;
    
    	-- create a copy of the customer table 
	DROP TABLE IF EXISTS peak.peaks_fixed;
	CREATE TABLE peak.peaks_fixed LIKE peak.peaks;
	INSERT peaks_fixed SELECT * FROM peak.peaks;

	fixPeak_Country: LOOP
		FETCH curPeakCounty INTO peak_id,first_ascent_country;
		IF finished = 1 THEN 
			LEAVE fixPeak_Country;
		END IF;
		 
		-- insert into messages select concat('country is: ', country, ' and phone is: ', phone);
         
			IF first_ascent_country LIKE '%W Germany%' THEN
					SET  first_ascent_country = CONCAT( LEFT(first_ascent_country, LOCATE('W Germany',first_ascent_country) - 1 ) , 'W_Germany' , RIGHT(first_ascent_country , length(first_ascent_country) - (LOCATE('W Germany',first_ascent_country) + 8)) );
					UPDATE peak.peaks_fixed 
						SET peaks_fixed.first_ascent_country=first_ascent_country 
							WHERE peaks_fixed.peak_id = peak_id;
						END IF;   
							IF first_ascent_country LIKE '%S Korea%' THEN
								SET  first_ascent_country = CONCAT( LEFT(first_ascent_country, LOCATE('S Korea',first_ascent_country) - 1 ) , 'S_Korea' , RIGHT(first_ascent_country , length(first_ascent_country) - (LOCATE('S Korea',first_ascent_country) + 6)) );
									UPDATE peak.peaks_fixed 
										SET peaks_fixed.first_ascent_country=first_ascent_country 
									WHERE peaks_fixed.peak_id = peak_id;
							END IF;  
								IF first_ascent_country LIKE '%New Zealand%' THEN
									SET  first_ascent_country = CONCAT( LEFT(first_ascent_country, LOCATE('New Zealand',first_ascent_country) - 1 ) , 'New_Zealand' , RIGHT(first_ascent_country , length(first_ascent_country) - (LOCATE('New Zealand',first_ascent_country) + 10)) );
										UPDATE peak.peaks_fixed 
											SET peaks_fixed.first_ascent_country=first_ascent_country 
										WHERE peaks_fixed.peak_id = peak_id;
								END IF;   
									IF LOCATE(' ',first_ascent_country) != 0 THEN
										SET  first_ascent_country = REPLACE(first_ascent_country,' ', '/');
											UPDATE peak.peaks_fixed 
												SET peaks_fixed.first_ascent_country=first_ascent_country 
											WHERE peaks_fixed.peak_id = peak_id;
									END IF; 
	END LOOP fixPeak_Country;
	CLOSE curPeakCounty;

END$$
DELIMITER ;

CALL Separate_Asecnt_Counties();
-- S Korea, New Zealand 
SELECT * FROM peaks_fixed;
SELECT distinct first_ascent_country FROM peaks_fixed WHERE first_ascent_country LIKE '%Germany%';

SELECT first_ascent_country, length(first_ascent_country) AS LEN,
LOCATE(' ',first_ascent_country) AS NUM,
  REPLACE(first_ascent_country,' ', '/') AS correct
	FROM peaks
	WHERE first_ascent_country LIKE '%New Zealand%';

-- substring lcate 



SELECT count(expedition_role) FROM members WHERE expedition_role = 'Leader';
SELECT count(expedition_id) FROM expeditions;
-- 10036 leaders, 10363 expeditions, try to clarify

SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%/%';
-- these can be changed:
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader%/%';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'CHOY06313';
--  + are good
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%+%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader%+%';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'ANN188304';
--  & 'Leader & Exp Doctor' good
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%&%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader & Exp Doctor';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'BHRI02301';
--  () good:  'Leader (nomimal)' ,  'Leader (Admin)'
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%(%)%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE  'Commander General'  ;
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'EVER73301';
--  good: 'Commander General' ,    'Leader?' 
--  testing
SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role LIKE 'Leader%/%';

SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role LIKE 'Leader%+%';

SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role IN ('Leader & Exp Doctor' , 'Leader (nomimal)' ,  'Leader (Admin)' , 'Commander General' ,    'Leader?' );
--  testing end
DROP PROCEDURE IF EXISTS Correct_Leader_Titles; 

DELIMITER $$

CREATE PROCEDURE Correct_Leader_Titles ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE expedition_role varchar(50) DEFAULT "x";
	DECLARE member_id varchar(12) DEFAULT 0;

	-- declare cursor for customer
	DECLARE curLeadRole
		CURSOR FOR 
            		SELECT members.member_id, members.expedition_role 
				FROM peak.members;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curLeadRole;
    
    	-- create a copy of the customer table 
	DROP TABLE IF EXISTS peak.members_fixed;
	CREATE TABLE peak.members_fixed LIKE peak.members;
	INSERT members_fixed SELECT * FROM peak.members;

	fixLead_Role: LOOP
		FETCH curLeadRole INTO member_id,expedition_role;
		IF finished = 1 THEN 
			LEAVE fixLead_Role;
		END IF;
		 
			IF expedition_role LIKE 'Leader%/%' THEN
					SET  expedition_role = REPLACE(  expedition_role , expedition_role , 'Leader' );
					UPDATE peak.members_fixed 
						SET members_fixed.expedition_role=expedition_role 
							WHERE members_fixed.member_id = member_id;
						END IF;   
				IF expedition_role LIKE 'Leader%+%' THEN
						SET  expedition_role = REPLACE(  expedition_role , expedition_role , 'Leader' );
						UPDATE peak.members_fixed 
							SET members_fixed.expedition_role=expedition_role 
								WHERE members_fixed.member_id = member_id;
							END IF;  
					IF expedition_role IN ('Leader & Exp Doctor' , 'Leader (nomimal)' ,  'Leader (Admin)' , 'Commander General' ,    'Leader?' ) THEN
							SET  expedition_role = REPLACE(  expedition_role , expedition_role , 'Leader' );
							UPDATE peak.members_fixed 
								SET members_fixed.expedition_role=expedition_role 
									WHERE members_fixed.member_id = member_id;
								END IF;  
						IF member_id IN ('AMAD16302-01','AMAD16302-02','AMAD79301-01','AMAD79301-02','AMAD95304-01','AMAD95304-02','ANN102104-01','ANN102104-02','ANN184401-01','ANN184401-02','ANN199101-01','ANN199101-02','ANN386302-01','ANN386302-02','ANN486301-01','ANN486301-02','BARU01308-01','BARU01308-02','CHEO91301-01','CHEO91301-02','CHOY02328-01','CHOY02328-02','CHOY81101-01','CHOY81101-02','CHOY81101-03','CHOY95108-01','CHOY95108-02','DHA117107-01','DHA117107-02','DHA189402-01','DHA189402-02','DHA198303-01','DHA198303-02','EVER04141-01','EVER04141-02','EVER05152-01','EVER05152-08','EVER12140-01','EVER12140-02','EVER13186-01','EVER13186-02','EVER71101-01','EVER71101-02','EVER81101-01','EVER81101-02','EVER85303-01','EVER85303-02','EVER88308-01','EVER88308-02','EVER90103-01','EVER90103-02','EVER90103-03','EVER91102-01','EVER91102-02','EVER92105-01','EVER92105-02','EVER93107-01','EVER93107-02','EVER94109-01','EVER94109-02','EVER95104-01','EVER95104-02','EVER98104-01','EVER98104-02','EVER99118-01','EVER99118-02','GANC90101-01','GANC90101-02','GAUR85401-01','GAUR85401-02','GYAC86301-01','GYAC86301-02','GYAJ94301-01','GYAJ94301-02','HIME80301-01','HIME80301-02','JONG98101-01','JONG98101-02','KUSU79303-01','KUSU79303-02','LHOT88302-01','LHOT88302-02','MANA02107-01','MANA02107-02','MANA81101-01','MANA81101-02','NUPK05301-01','NUPK05301-02','PUMO00102-01','PUMO00102-02','PUMO71101-01','PUMO71101-02','PUTH78301-01','PUTH78301-02','ROCN02101-01','ROCN02101-02','TILI88301-01','TILI88301-02') THEN
								SET  expedition_role = REPLACE(  expedition_role , expedition_role , 'Co-Leader' );
								UPDATE peak.members_fixed 
									SET members_fixed.expedition_role=expedition_role 
										WHERE members_fixed.member_id = member_id;
									END IF;  
									
	END LOOP fixLead_Role;
	CLOSE curLeadRole;

END$$
DELIMITER ;

CALL Correct_Leader_Titles();



































SELECT DISTINCT count(expedition_role )
FROM members_fixed
WHERE expedition_role = 'Leader';
--  10107 leaders, an additional 71 - 98 coleader = 10009

SELECT expedition_id, count(expedition_role) AS counting
FROM members
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING counting != 1;

SELECT expedition_id, member_id, expedition_role, REPLACE( expedition_role,expedition_role,'Co-Leader')
FROM members
WHERE expedition_role = 'Leader'
AND expedition_id IN(
SELECT expedition_id
FROM members
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING count(expedition_role) != 1);

SELECT p.peak_id , p.peak_name , m.expedition_role , m.expedition_id , m.member_id
FROM peaks AS p
INNER JOIN members AS m
WHERE p.first_ascent_expedition_id = m.expedition_id
AND m.expedition_role = 'Leader';
SELECT * FROM peaks;
SELECT *
FROM members
WHERE expedition_id = 'EVER90103';

-- Dropping extra leaders
SELECT * FROM Multi_leads;
--  98
USE peak;
DROP TABLE IF EXISTS Multi_leads;
CREATE TABLE Multi_leads 
(member_id varchar(12) );
INSERT Multi_leads 
		SELECT member_id
		FROM members
		WHERE expedition_role = 'Leader'
		AND expedition_id IN(
		SELECT expedition_id
		FROM members
		WHERE expedition_role = 'Leader'
		GROUP BY expedition_id
		HAVING count(expedition_role) != 1);



SELECT expedition_id, member_id, expedition_role, REPLACE( expedition_role,expedition_role,'Co-Leader')
FROM members
WHERE expedition_role = 'Leader'
AND RIGHT(member_id,2) != 01
AND expedition_id IN(
SELECT expedition_id
FROM members
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING count(expedition_role) != 1);

SELECT expedition_id, expedition_role FROM members_fixed WHERE expedition_role = 'Co-Leader';

SELECT expedition_id, member_id, expedition_role, REPLACE( expedition_role,expedition_role,'Co-Leader')
FROM members_leadfixed
WHERE expedition_role = 'Co-Leader'
AND expedition_id IN(
SELECT expedition_id
FROM members_leadfixed
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING count(expedition_role) != 1);