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