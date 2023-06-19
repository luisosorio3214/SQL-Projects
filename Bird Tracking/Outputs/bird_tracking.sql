CREATE SCHEMA milestone_project2;

SELECT *
FROM city_weather 
LIMIT 5;

SELECT * 
FROM bird_data
LIMIT 5;

SELECT id, altitude, date_time, device_info_serial, direction, latitude, longitude, speed_2d, bird_name, nearest_city,
		country, avg_temp
FROM bird_data as bd 
INNER JOIN city_weather as cw
ON bd.date = cw.DATE;

SELECT id, altitude, date_time, device_info_serial, direction, latitude, longitude, speed_2d, bird_name, nearest_city,
		country, avg_temp
FROM bird_data as bd 
LEFT JOIN city_weather as cw
ON bd.date = cw.DATE;

SELECT id, altitude, date_time, device_info_serial, direction, latitude, longitude, speed_2d, bird_name, nearest_city,
		country, avg_temp
FROM bird_data as bird
INNER JOIN city_weather as city
ON bird.date = city.DATE
ORDER BY id ASC;

SELECT * 
FROM bird_data
WHERE id = 1;

SELECT * 
FROM city_weather
WHERE DATE = '8/14/2013';
