USE birdstrikes;

# Exercise 1:
DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(id INTEGER NOT NULL,
employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));

# Exercise 2:
SELECT state FROM birdstrikes LIMIT 144,1;
# 'Tennessee'

# Exercise 3:
SELECT flight_date
FROM birdstrikes
ORDER BY flight_date DESC
LIMIT 1;
#'2000-04-18'

# Exercise 4:
SELECT DISTINCT cost FROM birdstrikes
ORDER BY cost DESC
LIMIT 49,1;
#'5345'

# Exercise 5:
SELECT state FROM birdstrikes
WHERE state <> ""
AND bird_size <> ""
LIMIT 1,1;
#'Colorado'

# Exercise 6:
SELECT DATEDIFF(DATE(NOW()),flight_date)
FROM birdstrikes
WHERE WEEKOFYEAR(flight_date)=52
AND state="Colorado";
# 7939
