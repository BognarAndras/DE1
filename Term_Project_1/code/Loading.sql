DROP SCHEMA IF EXISTS Peak;
CREATE SCHEMA Peak;
USE peak;

SHOW VARIABLES LIKE "secure_file_priv";
SHOW VARIABLES LIKE "local_infile";
SET GLOBAL local_infile = true;


DROP TABLE IF EXISTS expeditions;

CREATE TABLE expeditions
(expedition_id varchar(9) primary key NOT NULL,
peak_id varchar(4) NOT NULL,
peak_name varchar(255),
year_exp integer,
season varchar(20),
basecamp_date date,
highpoint_date date,
termination_date date,
termination_reason varchar(255),
highpoint_metres integer,
members integer,
member_deaths integer,
hired_staff integer,
hired_staff_deaths integer,
oxygen_used integer,
trekking_agency varchar(255));


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expeditions.csv'
INTO TABLE expeditions
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(expedition_id, peak_id, peak_name, year_exp, season, @basecamp_date, @highpoint_date, @termination_date, termination_reason, @highpoint_metres, members, member_deaths, hired_staff, hired_staff_deaths, @oxygen_used, @trekking_agency)
SET
basecamp_date = IF(@basecamp_date = 'NA' , '1900-01-01' , @basecamp_date),
highpoint_date = IF(@highpoint_date = 'NA' , '1900-01-01' , @highpoint_date),
termination_date = IF(@termination_date = 'NA' , '1900-01-01' , @termination_date),
highpoint_metres = IF(@highpoint_metres = 'NA' , 9999999 , @highpoint_metres),
oxygen_used = IF(@oxygen_used = 'TRUE' , 1 , 0),
trekking_agency = IF(@trekking_agency = 'NA' , 'Unknown' , @trekking_agency);

# Note: dates, highpoint_meters placeholder used. Oxygen_used as binary.


DROP TABLE IF EXISTS members;

CREATE TABLE members
(expedition_id varchar(9) NOT NULL,
member_id varchar(12) primary key NOT NULL,
peak_id varchar(4) NOT NULL,
peak_name varchar(255),
year_exp integer,
season varchar(20),
sex varchar(9),
age integer,
citizenship varchar(255),
expedition_role varchar(255),
hired integer,
highpoint_metres integer,
success integer,
solo integer,
oxygen_used integer,
died integer,
death_cause varchar(255),
death_height_metres integer,
injured integer,
injury_type varchar(255),
injury_height_metres integer);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/members.csv'
INTO TABLE members
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(expedition_id, member_id, peak_id, peak_name, year_exp, season, @sex, @age, @citizenship, @expedition_role, @hired, @highpoint_metres, @success, @solo, @oxygen_used, @died, @death_cause, @death_height_metres, @injured, @injury_type, @injury_height_metres)
SET
sex = IF(@sex = 'NA' , 'Unknown' , @sex),
age = IF(@age = 'NA' , 9999999 , @age),
citizenship = IF(@citizenship = 'NA' , 'Unknown' , @citizenship),
expedition_role = IF(@expedition_role = 'NA' , 'Unknown' , @expedition_role),
hired = IF(@hired = 'TRUE' , 1 , 0),
highpoint_metres = IF(@highpoint_metres = 'NA' , 9999999 , @highpoint_metres),
success = IF(@success = 'TRUE' , 1 , 0),
solo = IF(@solo = 'TRUE' , 1 , 0),
oxygen_used = IF(@oxygen_used = 'TRUE' , 1 , 0),
died = IF(@died = 'TRUE' , 1 , 0),
death_cause = IF(@death_cause = 'NA' , 'Unknown' , @death_cause),
death_height_metres = IF(@death_height_metres = 'NA' , 9999999 , @death_height_metres),
injured = IF(@injured = 'TRUE' , 1 , 0),
injury_type = IF(@injury_type = 'NA' , 'Unknown' , @injury_type),
injury_height_metres = IF(@injury_height_metres = 'NA' , 9999999 , @injury_height_metres);

SELECT * FROM members;


DROP TABLE IF EXISTS peaks;

CREATE TABLE peaks
(peak_id varchar(4) primary key NOT NULL,
peak_name varchar(255),
peak_alternative_name varchar(255),
height_metres integer,
climbing_status varchar(255),
first_ascent_year integer,
first_ascent_country varchar(255),
first_ascent_expedition_id varchar(9));


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/peaks.csv'
INTO TABLE peaks
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(peak_id, peak_name, @peak_alternative_name, height_metres, climbing_status, @first_ascent_year, @first_ascent_country, @first_ascent_expedition_id)
SET
peak_alternative_name = IF(@peak_alternative_name = 'NA' , 'Unknown' , @peak_alternative_name),
first_ascent_year = IF(@first_ascent_year = 'NA' , 9999999 , @first_ascent_year),
first_ascent_country = IF(@first_ascent_country = 'NA' , 'Unknown' , @first_ascent_country),
first_ascent_expedition_id = IF(@first_ascent_expedition_id = 'NA' , 'Unknown' , @first_ascent_expedition_id);

SELECT * FROM peaks;