USE SAKILA;

SELECT * FROM FILM;

# VIEW TABLE FOR FILM, CATEGORY, ACTOR FULL NAME
CREATE VIEW film_actors AS (
	SELECT f.film_id, title, description, name AS category, 
		first_name, last_name
	FROM FILM f
	INNER JOIN FILM_CATEGORY fc
		ON f.film_id = fc.film_id
	INNER JOIN CATEGORY c
		 ON fc.category_id = c.category_id
	INNER JOIN FILM_ACTOR fa
		ON f.film_id = fa.film_id
	INNER JOIN ACTOR a
		ON fa.actor_id = a.actor_id
	ORDER BY f.film_id); 

SELECT * 
FROM film_actors;

# PROCEDURE FOR KEYWRODS IN THE DESCRIPTION ATTRIBUTE
DELIMITER $
CREATE PROCEDURE keyword(IN DESCR VARCHAR(255))
BEGIN 
	SELECT *
    FROM FILM
    WHERE description LIKE CONCAT('%',DESCR,'%')
    ORDER BY release_year DESC;
END $

CALL keyword('EPIC');

CREATE table employee_records(
	employee_id smallint NOT NULL AUTO_INCREMENT, 
	f_name VARCHAR(20) NOT NULL, 
	l_name VARCHAR(30) NOT NULL, 
	job_title VARCHAR(20), 
	username VARCHAR(20), 
	password TEXT, 
	PRIMARY KEY(employee_ID)
);

INSERT employee_records VALUES(1,'Dalia','Database','Executive','dalia_d', SHA1('movielover1'));

INSERT employee_records VALUES(2,'Dante','Database','Executive','dante_d', SHA1('Bossman99'));

SELECT * 
FROM employee_records;