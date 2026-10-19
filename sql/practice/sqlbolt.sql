https://sqlbolt.com/

--lesson 1
SELECT Title FROM movies;

SELECT Director FROM movies;

SELECT Title,Director FROM movies;

SELECT Title,Year FROM movies;

SELECT * FROM movies;

--lesson 2

SELECT * FROM movies 
Where id ==6;

SELECT * FROM movies 
Where year between 2000 and 2010;

SELECT * FROM movies 
Where year not between 2000 and 2010;

SELECT title, year FROM movies
WHERE year <= 2003;

--lesson 3

SELECT * FROM movies 
Where Title LIKE "%Toy Story%";

SELECT * FROM movies 
Where Director LIKE "John Lasseter";

SELECT * FROM movies 
Where Director Not LIKE "John Lasseter";

SELECT * FROM movies 
Where Movie LIKE "Wall-_";

--lesson 4

SELECT DISTINCT Director FROM movies
Order by Director ASC;

SELECT * From movies
ORDER BY Year DESC
Limit 4;

SELECT * From movies
ORDER BY Title ASC
Limit 5;

SELECT * From movies
ORDER BY Title ASC
Limit 5 OFFSET 5;

--Simple SELECT Queries exercises

SELECT city, population FROM north_american_cities
WHERE country = "Canada";

SELECT city, latitude FROM north_american_cities
WHERE country = "United States"
ORDER BY latitude DESC;

SELECT city, longitude FROM north_american_cities
WHERE longitude < -87.629798
ORDER BY longitude ASC;

SELECT city, population FROM north_american_cities
WHERE country LIKE "Mexico"
ORDER BY population DESC
LIMIT 2;

SELECT city, population FROM north_american_cities
Where country = "United States"
ORDER BY population DESC
Limit 2 OFFSET 2;

-- lesson 6

SELECT * FROM movies
INNER JOIN boxoffice
    ON movies.id = Boxoffice.Movie_id
    
WHERE domestic_sales < 	international_sales;

SELECT * FROM movies
INNER JOIN boxoffice
    ON movies.id = Boxoffice.Movie_id
    
ORDER BY rating DESC;

--lesson 7

SELECT DISTINCT building FROM employees;

SELECT DISTINCT building_name, role 
FROM buildings 
  LEFT JOIN employees
    ON building_name = building;

--lesson 8

SELECT name, role FROM employees
WHERE building IS NULL;

SELECT DISTINCT building_name
FROM buildings 
  LEFT JOIN employees
    ON building_name = building
WHERE role IS NULL;

-- lesson 9

SELECT title, (domestic_sales + international_sales) / 1000000 AS gross_sales_millions
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;
    
SELECT title, rating * 10 AS Percent
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;
    
SELECT title, Year
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id

Where Year%2==0;

--lesson 10

SELECT role, Avg(years_employed) FROM employees
GROUP BY role;

SELECT building, SUM(years_employed) as Total_years_employed
FROM employees
GROUP BY building;

-- lesson 11

SELECT role, COUNT(*) as Number_of_artists
FROM employees
WHERE role = "Artist";

SELECT role, COUNT(*)
FROM employees
GROUP BY role;

SELECT role,SUM(years_employed) FROM employees
WHERE role = "Engineer";

--lesson 12

SELECT director, SUM(domestic_sales + international_sales) as Cumulative_sales_from_all_movies
FROM movies
    INNER JOIN boxoffice
        ON movies.id = boxoffice.movie_id
GROUP BY director;

--lesson 13

INSERT INTO movies VALUES (4, "Toy Story 4", "El Directore", 2015, 90);

INSERT INTO boxoffice
VALUES (4, 8.7, 340000000, 270000000);

--lesson 14

UPDATE movies
SET director = "John Lasseter"
WHERE id = 2;

UPDATE movies
SET Year = "1999"
WHERE id = 3;

UPDATE movies
SET Title = "Toy Story 3", Director = "Lee Unkrich"
WHERE id = 11;

--lesson 15

DELETE FROM movies
WHERE Year < 2005;

DELETE FROM movies
WHERE Director = "Andrew Stanton";

--lesson 16

CREATE TABLE IF NOT EXISTS DATABASE(
    Name TEXT,
    Version FLOAT,
    Download_count INT

);

--lesson 17

ALTER TABLE Movies
  ADD COLUMN Aspect_ratio FLOAT DEFAULT 2.39;

ALTER TABLE movies
  ADD COLUMN Language TEXT DEFAULT "English";

--lesson 18

DROP TABLE IF EXISTS movies;

DROP TABLE IF EXISTS boxoffice;

