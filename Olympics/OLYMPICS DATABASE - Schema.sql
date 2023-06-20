Use olympics;

# we create our tables to load the data 

CREATE TABLE OLYMPICS_HISTORY (
	id INT,
    name VARCHAR(255),
    sex VARCHAR(255),
    age VARCHAR(255),
    heigth VARCHAR(255),
    weight VARCHAR(255),
    team VARCHAR(255),
    noc VARCHAR(255),
    games VARCHAR(255),
    year INT,
    season VARCHAR(255),
    city VARCHAR(255),
    sport VARCHAR(255),
    event VARCHAR(255),
    medal VARCHAR(255)
    );
    
# create table for our 2nd data set
    
CREATE TABLE OLYMPICS_HISTORY_NOC_REGIONS (
	noc VARCHAR(255),
	region VARCHAR(255),
	notes VARCHAR(255)
	);
	
# check if the import was successful

SELECT * 
FROM OLYMPICS_HISTORY
WHERE id = 125221;

# count the amount of records imported 
  
SELECT COUNT(*) 
FROM OLYMPICS_HISTORY;    
   
SELECT COUNT(*) 
FROM OLYMPICS_HISTORY_NOC_REGIONs;
    
SELECT *
FROM OLYMPICS_HISTORY;



