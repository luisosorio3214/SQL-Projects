# 11. Fetch the top 5 athletes who have won the most gold medals.

WITH t1 AS (
	SELECT name, team, COUNT(*) AS total_medals
	FROM OLYMPICS_HISTORY
	WHERE medal = 'Gold'
    GROUP BY name
    ORDER BY total_medals DESC),
t2 AS (
	SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
    FROM t1)
SELECT * 
FROM t2
WHERE rnk <= 5;

# 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
WITH t1 AS (
	SELECT name, team, COUNT(*) AS total_medals
	FROM OLYMPICS_HISTORY
    WHERE medal <> 'NA'
    GROUP BY name
    ORDER BY total_medals DESC),
t2 AS (
	SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
    FROM t1)
SELECT * 
FROM t2
WHERE rnk <= 5;

# 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
WITH t1 AS (
	SELECT nr.region, COUNT(medal) AS total_medals 
	FROM OLYMPICS_HISTORY oh 
	INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	WHERE medal <> 'NA'
	GROUP BY nr.region
	ORDER BY total_medals DESC),
t2 AS (
	SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
    FROM t1)
SELECT *
FROM t2
WHERE rnk <= 5;

# 14. List down total gold, silver and bronze medals won by each country.

# PIVOT TABLE 

WITH t1 AS (
	SELECT nr.region AS country, medal, COUNT(1) AS total_medals
	FROM OLYMPICS_HISTORY oh
	INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	WHERE medal <> 'NA'
	GROUP BY country, medal
	ORDER BY country, medal)
SELECT country, 
	SUM(CASE 
    WHEN medal = 'Gold' THEN total_medals 
    ELSE 0 
    END) AS gold, 
    SUM(CASE 
    WHEN medal = 'Silver' THEN total_medals 
    ELSE 0 
    END) AS silver,
    SUM(CASE 
    WHEN medal = 'Bronze' THEN total_medals 
    ELSE 0 
    END) AS bronze
FROM t1
GROUP BY country
ORDER BY gold DESC, silver DESC, bronze DESC;

# 15. List down total gold, silver and bronze medals won by each country corresponding to each Olympic game.
 WITH t1 AS (
	SELECT games, nr.region AS country, medal, COUNT(1) AS total_medals
	FROM OLYMPICS_HISTORY oh
	INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	WHERE medal <> 'NA'
	GROUP BY games, country, medal
	ORDER BY games, country, medal)
SELECT games, country, 
	SUM(CASE 
    WHEN medal = 'Gold' THEN total_medals 
    ELSE 0 
    END) AS gold, 
    SUM(CASE 
    WHEN medal = 'Silver' THEN total_medals 
    ELSE 0 
    END) AS silver,
    SUM(CASE 
    WHEN medal = 'Bronze' THEN total_medals 
    ELSE 0 
    END) AS bronze
FROM t1
GROUP BY games, country
ORDER BY games, country;   

# 16. Identify which country won the most gold, most silver and most bronze medals in each Olympic game.

WITH t1 AS (
	SELECT CONCAT(games," - ",nr.region) AS game_country, medal, COUNT(1) AS total_medals
	FROM OLYMPICS_HISTORY oh
    INNER JOIN OLYMPICS_HISTORY_NOC_REGIONS nr
		ON oh.noc = nr.noc
	WHERE medal <> 'NA'
	GROUP BY games, nr.region, medal
	ORDER BY games, nr.region, medal),
t2 AS (
	SELECT game_country, 
		SUM(CASE 
		WHEN medal = 'Gold' THEN total_medals 
		ELSE 0
		END) AS gold, 
		SUM(CASE 
		WHEN medal = 'Silver' THEN total_medals 
		ELSE 0
		END) AS silver,
		SUM(CASE 
		WHEN medal = 'Bronze' THEN total_medals 
		ELSE 0
		END) AS bronze
	FROM t1
	GROUP BY game_country
	ORDER BY game_country, gold DESC, silver DESC, bronze DESC),
t3 AS (
	SELECT SUBSTRING(game_country,1,POSITION(" - " IN game_country)) AS games,
		   SUBSTRING(game_country, POSITION(" - " IN game_country) + 3) AS country,
           gold, silver, bronze
	FROM t2)
SELECT DISTINCT(games),
    CONCAT(FIRST_VALUE(country) OVER(PARTITION BY games ORDER BY gold DESC), " - ",
    FIRST_VALUE(gold) OVER(PARTITION BY games ORDER BY gold DESC)) AS max_gold,
    CONCAT(FIRST_VALUE(country) OVER(PARTITION BY games ORDER BY silver DESC), " - ",
    FIRST_VALUE(silver) OVER(PARTITION BY games ORDER BY silver DESC)) AS max_silver,
    CONCAT(FIRST_VALUE(country) OVER(PARTITION BY games ORDER BY bronze DESC), " - ",
    FIRST_VALUE(bronze) OVER(PARTITION BY games ORDER BY bronze DESC)) AS max_bronze
FROM t3
ORDER BY games;


