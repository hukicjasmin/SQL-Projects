/* This project is data cleaning using SQL (MySQL Workbench). 
I used dataset "movies.csv" that is publicly available on Kaggle: 
https://www.kaggle.com/datasets/danielgrijalvas/movies */

/* Inspect data */

SELECT * FROM movies;

SELECT COUNT(*) FROM movies;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'movies';

/* Change the format to DECIMAL in columns budget and gross */

ALTER TABLE movies 
MODIFY COLUMN budget DECIMAL(15,2);

ALTER TABLE movies 
MODIFY COLUMN gross DECIMAL(15,2);

/* Create a new column - month, and populate is with the data from the column released */

ALTER TABLE movies 
ADD month VARCHAR(20);

UPDATE movies
SET month = SUBSTRING(released, 1, INSTR(released, ' ')-1)
WHERE released LIKE '%, %';

/* Check if there are records with NULL, and delete them if the number is not significant */

SELECT * FROM movies 
WHERE month IS NULL;

DELETE FROM movies 
WHERE month IS NULL;

/* Check the records with the low number of votes, and delete if the number is not significant*/

SELECT * FROM movies 
WHERE votes < 1000;

DELETE FROM movies 
WHERE votes < 1000;

/* Find and delete the missing values in the column "rating" */

SELECT rating FROM movies 
WHERE rating = "";

DELETE FROM movies 
WHERE rating = "";

/* Explore the possibility to categorize countries*/

SELECT country, COUNT(country) AS number_of_movies 
FROM movies
GROUP BY country
ORDER BY number_of_movies DESC;

/* Categorize countries as US and non-US */ 

UPDATE movies
SET country = 
CASE WHEN country = 'United States'
	 THEN 'US'
     ELSE 'non-US'
END;

/* Find duplicate values in column "name" using WHERE comand */

SELECT * FROM movies
WHERE name IN (
 SELECT name FROM movies
 GROUP BY name
 HAVING COUNT(*) > 1
)

/* Finding duplicates with WHERE comand was to slow, so I used the approach with JOIN  */

SELECT m1.* FROM movies m1
JOIN (
 SELECT name
 FROM movies
 GROUP BY name
 HAVING COUNT(*) > 1
) m2 ON m1.name = m2.name;
