SELECT *
FROM OLYMPICS_HISTORY;

# 1. How many Olympics games have been held?
SELECT count(DISTINCT(games))
FROM OLYMPICS_HISTORY;

# 2. List down all Olympics games held so far.

SELECT DISTINCT(games)
FROM OLYMPICS_HISTORY
ORDER BY games;

# 3. Mention the total no of nations who participated in each olympics game?

with all_countries as
	(select games, nr.region
	from olympics_history oh
	join olympics_history_noc_regions nr ON nr.noc = oh.noc
	group by games, nr.region)
select games, count(1) as total_countries
from all_countries
group by games
order by games;

# 4. Which year saw the highest and lowest no of countries participating in Olympics?
WITH t1 AS (
	SELECT games, COUNT(DISTINCT(nr.region)) AS total_countries
	FROM OLYMPICS_HISTORY oh
	INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	GROUP BY games
	ORDER BY games)
SELECT CONCAT(FIRST_VALUE(games) over(), " - ", FIRST_VALUE(total_countries) over()) 
	AS lowest_countries,
    CONCAT(LAST_VALUE(games) over(), " - ", LAST_VALUE(total_countries) over()) 
	AS highest_countries
FROM t1
LIMIT 1;

# 5. Which nation has participated in all of the Olympic games?
WITH t1 AS (
	SELECT COUNT(DISTINCT(games)) AS total_games
	FROM OLYMPICS_HISTORY),
t2 AS (
	SELECT nr.region, COUNT(DISTINCT(games)) AS total_particpated_games 
	FROM OLYMPICS_HISTORY oh
	INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	GROUP BY nr.region)
SELECT *
FROM t2
INNER JOIN t1 
	ON t2.total_particpated_games = t1.total_games;

# 6. Identify the sport which was played in all summer Olympics.

# steps to solve 
# - find total no. of summer olympic games 
# - find for each sport, how many games where they played in 
# - compare 1 & 2

SELECT * 
FROM OLYMPICS_HISTORY;

WITH t1 AS (
	SELECT COUNT(DISTINCT games) AS total_summer_games
    FROM OLYMPICS_HISTORY
    WHERE season = 'Summer'),
t2 AS (
	SELECT DISTINCT(sport), games
    FROM OLYMPICS_HISTORY
    WHERE season = 'Summer'
    ORDER BY games),
t3 AS (
	SELECT sport, count(games) as no_of_games
    FROM t2 
    GROUP BY sport)
SELECT * 
FROM t3
JOIN t1 ON t1.total_summer_games = t3.no_of_games;

# 7. Which Sports were just played only once in the Olympics?

WITH t1 AS 
	(SELECT DISTINCT games, sport
	FROM OLYMPICS_HISTORY),
t2 AS 
	(SELECT sport, COUNT(1) AS no_of_games
	FROM t1
	GROUP BY sport)
SELECT t2.*, t1.games
FROM t2
INNER JOIN t1 ON t2.sport = t1.sport
WHERE t2.no_of_games = 1
ORDER BY t1.sport;

# 8. Fetch the total no of sports played in each Olympic game.
SELECT games, COUNT(DISTINCT(sport))
FROM OLYMPICS_HISTORY
GROUP BY games
ORDER BY games;

# 9. Fetch details of the oldest athletes to win a gold medal.
WITH t1 AS (
	SELECT MAX(age) AS max_age
    FROM OLYMPICS_HISTORY 
	WHERE age <> 'NA' 
    AND medal = 'Gold')
SELECT name, sex, age, team, games, city,
	sport, event, medal
FROM OLYMPICS_HISTORY oh
INNER JOIN t1 
	 ON oh.age = t1.max_age
WHERE medal = 'Gold'; 

# 10. Find the Ratio of male and female athletes participated in all Olympic games.
WITH t1 AS (
	SELECT sex, COUNT(games) as cnt
	FROM OLYMPICS_HISTORY
	GROUP BY sex),
t2 AS (
	SELECT *, ROW_NUMBER() OVER(ORDER BY cnt ASC) AS rn
    FROM t1),
female_cnt AS (
	SELECT cnt 
	FROM t2
	WHERE rn = 1),
male_cnt AS (
	SELECT cnt
    FROM t2
    WHERE rn = 2)
SELECT CONCAT('1:', ROUND(male_cnt.cnt/female_cnt.cnt,2)) AS ratio
FROM female_cnt, male_cnt
