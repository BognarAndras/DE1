# Exercise 1:

SELECT aircraft, airline, speed,
IF(speed < 100 OR speed IS NULL, 'LOW SPEED', 'HIGH SPEED') AS speed_category
FROM birdstrikes
ORDER BY speed_category;

# Exercise 2:
SELECT COUNT(DISTINCT aircraft) FROM birdstrikes;
# Answer: 3

# Exercise 3:
SELECT MIN(speed)
FROM birdstrikes
WHERE aircraft LIKE 'H%';
# Answer: 9

# Exercise 4:
SELECT phase_of_flight, COUNT(*) AS num_inc
FROM birdstrikes
GROUP BY phase_of_flight
ORDER BY num_inc ASC
LIMIT 1;
# Answer: Taxi - 2

# Exercise 5:
SELECT phase_of_flight, ROUND(AVG(cost),0) AS hig_avg_cost
FROM birdstrikes
GROUP BY phase_of_flight
ORDER BY hig_avg_cost DESC
Limit 1;
# Answer: 'Climb', '54673'

# Exercise 6:
SELECT state, speed, AVG(speed) AS avg_speed	
FROM birdstrikes
WHERE length(state)<5
AND state <> ''
GROUP BY state
ORDER BY avg_speed DESC
LIMIT 1;
# Answer: 'Iowa', '3000', '2862.5000'
