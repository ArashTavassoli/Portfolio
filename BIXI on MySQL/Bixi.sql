SET sql_mode = 'ONLY_FULL_GROUP_BY';

# The total number of trips for the years of 2016:
SELECT COUNT(*) AS 'Total number of trips in 2016' 
FROM trips 
WHERE YEAR(start_date) = 2016

# The total number of trips for the years of 2017:
SELECT COUNT(*) AS 'Total number of trips in 2017' 
FROM trips 
WHERE YEAR(start_date) = 2017

# The total number of trips for the years of 2016 broken-down by month:
SELECT (CASE MONTH(start_date)
		WHEN 1 THEN '01: Jan'
		WHEN 2 THEN '02: Feb'
		WHEN 3 THEN '03: Mar'
		WHEN 4 THEN '04: Apr'
		WHEN 5 THEN '05: May'
		WHEN 6 THEN '06: Jun'
		WHEN 7 THEN '07: Jul'
		WHEN 8 THEN '08: Aug'
		WHEN 9 THEN '09: Sep'
		WHEN 10 THEN '10: Oct'
		WHEN 11 THEN '11: Nov'
		WHEN 12 THEN '12: Dec'
		END) AS Selected_Month, COUNT(*) AS 'Total number of trips per month' 
FROM trips
WHERE YEAR(start_date) = 2016
GROUP BY Selected_Month

# The total number of trips for the years of 2017 broken-down by month:
SELECT (CASE MONTH(start_date)
		WHEN 1 THEN '01: Jan'
		WHEN 2 THEN '02: Feb'
		WHEN 3 THEN '03: Mar'
		WHEN 4 THEN '04: Apr'
		WHEN 5 THEN '05: May'
		WHEN 6 THEN '06: Jun'
		WHEN 7 THEN '07: Jul'
		WHEN 8 THEN '08: Aug'
		WHEN 9 THEN '09: Sep'
		WHEN 10 THEN '10: Oct'
		WHEN 11 THEN '11: Nov'
		WHEN 12 THEN '12: Dec'
		END) AS Selected_Month, COUNT(*) AS 'Total number of trips per month' 
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY Selected_Month

# The average number of trips a day for each year-month combination in the dataset:
SELECT YEAR(start_date) AS Selected_Year,
		MONTH(start_date) AS Selected_Month, 
		ROUND(COUNT(*)/COUNT(DISTINCT DAY(start_date))) AS 'Average daily trips' 
FROM trips
GROUP BY Selected_Year, Selected_Month

# The total number of trips in the year 2017 broken-down by membership status (member/non-member).
SELECT (CASE is_member
			WHEN 0 THEN 'Non-member'
            WHEN 1 THEN 'Member'
		END) as Membership, COUNT(*) AS 'Total number of trips per year' 
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY Membership

# The fraction of total trips that were done by members for the year of 2017 broken-down by month:
SELECT MONTH(start_date) AS 'Month in 2017', 
		AVG(is_member) AS 'Fraction of trips done by members' 
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY `Month in 2017`

# Calculate the average trip time across the entire dataset:
SELECT ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' FROM trips

# Calculate the average trip time broken-down by membership status:
SELECT (CASE is_member
			WHEN 0 THEN 'Non-member'
            WHEN 1 THEN 'Member'
		END) AS Membership, ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' 
FROM trips
GROUP BY Membership

# Calculate the average trip time broken-down by month:
SELECT MONTH(start_date) AS 'Month', 
		ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' 
FROM trips
GROUP BY `Month`

# Calculate the average trip time broken-down by day of week:
SELECT (CASE DAYOFWEEK(start_date) 
			WHEN 1 THEN '1: Sunday'
            WHEN 2 THEN '2: Monday'
            WHEN 3 THEN '3: Tuesday'
            WHEN 4 THEN '4: Wednesday'
            WHEN 5 THEN '5: Thursday'
            WHEN 6 THEN '6: Friday'
			WHEN 7 THEN '7: Saturday'
		END) AS 'Day of week', ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' 
FROM trips
GROUP BY `Day of week`

# Calculate the average trip time broken-down by station name:
SELECT stations.name AS 'Station Name', 
		ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' 
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
ORDER BY `Average trip time in seconds` DESC
LIMIT 1

SELECT stations.name AS 'Station Name', 
		ROUND(AVG(duration_sec)) AS 'Average trip time in seconds' 
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
ORDER BY `Average trip time in seconds` ASC
LIMIT 1

SELECT STDDEV(duration_sec), AVG(duration_sec), MIN(duration_sec), MAX(duration_sec) FROM trips

# Calculate the fraction of trips that were round trips and break it down by membership status:
SELECT (CASE is_member
			WHEN 0 THEN 'Non-member'
            WHEN 1 THEN 'Member'
		END) AS Membership, 
        AVG(start_station_code = end_station_code) AS 'Fraction of round trips' 
FROM trips
GROUP BY Membership

# Calculate the fraction of trips that were round trips and break it down by day of week:
SELECT (CASE DAYOFWEEK(start_date) 
			WHEN 1 THEN '1: Sunday'
            WHEN 2 THEN '2: Monday'
            WHEN 3 THEN '3: Tuesday'
            WHEN 4 THEN '4: Wednesday'
            WHEN 5 THEN '5: Thursday'
            WHEN 6 THEN '6: Friday'
			WHEN 7 THEN '7: Saturday'
		END) AS 'Day of week', 
        AVG(start_station_code = end_station_code) AS 'Fraction of round trips' 
FROM trips
GROUP BY `Day of week`

# What are the names of the 5 most popular starting stations?
SELECT stations.name AS 'Station Name', 
		COUNT(trips.start_station_code) AS Count
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
ORDER BY Count DESC
LIMIT 5

# What are the names of the 5 most popular ending stations?
SELECT stations.name AS 'Station Name', 
		COUNT(trips.end_station_code) AS Count
FROM trips 
JOIN stations ON trips.end_station_code = stations.code
GROUP BY `Station Name`
ORDER BY Count DESC
LIMIT 5

# How is the number of starts and ends distributed for the station Mackay / de Maisonneuve throughout the day?
SELECT * FROM stations
WHERE name = 'Mackay / de Maisonneuve'

SELECT start_station.Time_of_day, Count_Start, Count_End FROM
	(
    SELECT (CASE
			WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "1: morning"
			WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "2: afternoon"
			WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "3: evening"
			ELSE "4: night"
		END) AS "Time_of_day", COUNT(*) AS Count_Start
	FROM trips
	WHERE start_station_code = 6100
	GROUP BY `Time_of_day`
    ) AS start_station
    JOIN
	(
    SELECT (CASE
			WHEN HOUR(end_date) BETWEEN 7 AND 11 THEN "1: morning"
			WHEN HOUR(end_date) BETWEEN 12 AND 16 THEN "2: afternoon"
			WHEN HOUR(end_date) BETWEEN 17 AND 21 THEN "3: evening"
			ELSE "4: night"
		END) AS "Time_of_day", COUNT(*) AS Count_End
	FROM trips
	WHERE end_station_code = 6100
	GROUP BY `Time_of_day`
    ) AS end_station
    ON start_station.Time_of_day = end_station.Time_of_day


# Which station has proportionally the least number of member trips (Only stations with 10+ starting trips)?
SELECT stations.name as 'Station Name', 
		COUNT(trips.start_station_code) AS 'Number of trips', 
		AVG(trips.is_member) AS 'Fraction of trips done by members' 
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
HAVING `Number of trips` >= 10
ORDER BY `Fraction of trips done by members`
LIMIT 1


# Which station has proportionally the most number of member trips (Only stations with 10+ starting trips)?
SELECT stations.name as 'Station Name', 
		COUNT(trips.start_station_code) AS 'Number of trips', 
		AVG(trips.is_member) AS 'Fraction of trips done by members' 
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
HAVING `Number of trips` >= 10
ORDER BY `Fraction of trips done by members` DESC
LIMIT 1


# List all stations for which at least 10% of trips are round trips (alternative approach):
SELECT stations.name as 'Station Name', 
		COUNT(trips.start_station_code) AS 'Number of trips', 
		AVG(trips.start_station_code = trips.end_station_code) AS 'Fraction of round trips' 
FROM trips 
JOIN stations ON trips.start_station_code = stations.code
GROUP BY `Station Name`
HAVING `Fraction of round trips` >= 0.1 AND `Number of trips` >= 50
ORDER BY `Fraction of round trips` DESC

