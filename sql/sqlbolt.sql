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