USE peak;

SELECT p.peak_name , e.highpoint_date , m.citizenship 
	FROM peaks AS p
	INNER JOIN expeditions AS e
    ON p.first_ascent_expedition_id = e.expedition_id
    INNER JOIN members as m
    ON e.expedition_id = m.expedition_id
    AND m.expedition_role = 'Leader';