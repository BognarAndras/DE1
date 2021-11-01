USE peak;

-- Below is the testing Process for Cleaning Codes. This section can be skipped if only running the code.
-- First, regarding stored procedure - Separate_Asecnt_Counties - see where Germany appears in original table. 

SELECT distinct first_ascent_country FROM peaks_fixed WHERE first_ascent_country LIKE '%Germany%';

-- Next, see exact places of spaces and how they can be replaced.

SELECT first_ascent_country, length(first_ascent_country) AS LEN,
LOCATE(' ',first_ascent_country) AS NUM,
  REPLACE(first_ascent_country,' ', '/') AS correct
	FROM peaks
	WHERE first_ascent_country LIKE '%New Zealand%';

-- Regarding procedure Correct_Leader_Titles. See common patterns within the roles that could refer to leaders:

SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%/%';
-- Whenever / is contained, role can be changed to leader simply. Example group below shows they only have this leader.
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader%/%';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'CHOY06313';
-- Similarly, when + is contained, role can be changed.
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%+%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader%+%';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'ANN188304';
--  One group with 'Leader & Exp Doctor' can be changed.
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%&%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE 'Leader & Exp Doctor';
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'BHRI02301';
--  Following groups can be changed:  'Leader (nomimal)' ,  'Leader (Admin)' , 'Commander General' ,    'Leader?' 
SELECT distinct expedition_role FROM members WHERE expedition_role LIKE 'Leader%(%)%';
SELECT expedition_id , expedition_role FROM members WHERE expedition_role LIKE  'Commander General'  ;
SELECT expedition_role , member_id FROM members WHERE expedition_id = 'EVER73301';

--  Testing Replace correction:
SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role LIKE 'Leader%/%';

SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role LIKE 'Leader%+%';

SELECT expedition_id , expedition_role , REPLACE(  expedition_role , expedition_role , 'Leader' ) AS Correct
FROM members
WHERE expedition_role IN ('Leader & Exp Doctor' , 'Leader (nomimal)' ,  'Leader (Admin)' , 'Commander General' ,    'Leader?' );


-- Additionally, we have to make sure for later joins that any expedition can only have 1 leader. 

SELECT DISTINCT count(expedition_role )
FROM members_fixed
WHERE expedition_role = 'Leader';
--  10107 leaders in members_fixed after first replacements, an additional 71 from original 10036
-- However, there are 48 groups with more than 1 Leader. In total this means 98 coleaders to be corrected.
-- If we remove them correctly we should be left with 10009 Leaders.

SELECT expedition_id, count(expedition_role) AS counting
FROM members
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING counting != 1;

-- We can find them by nesting the selections. 

SELECT expedition_id, member_id, expedition_role, REPLACE( expedition_role,expedition_role,'Co-Leader')
FROM members
WHERE expedition_role = 'Leader'
AND expedition_id IN(
SELECT expedition_id
FROM members
WHERE expedition_role = 'Leader'
GROUP BY expedition_id
HAVING count(expedition_role) != 1);

-- An example expedition group: 

SELECT *
FROM members
WHERE expedition_id = 'EVER90103';

-- Dropping extra leaders
SELECT * FROM Multi_leads;
--  A new table created with the 98 member_ids
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

-- However, a nested selection can't be entered in the stored procedure as it would take too long. 
-- Therefore, the solution is to save the table in a csv file to get the list of member ids and paste them into the procedure.

SELECT * FROM Multi_leads;