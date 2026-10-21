-- https://sqlbolt.com/
-- SQLBolt runs on SQLite, which lets a few things through that Postgres errors on:
-- "double quotes" for strings, == for equals, and columns next to an aggregate without a GROUP BY.
-- The ✅ versions below run on both SQLite and Postgres.

--lesson 1

-- ✅ pick only the columns needed
SELECT Title FROM movies;

SELECT Director FROM movies;

-- ✅ columns separated by commas, they come back in the order written
SELECT Title,Director FROM movies;

SELECT Title,Year FROM movies;

-- ✅ * pulls every column, good for a quick look, but name the columns in real queries
SELECT * FROM movies;

--lesson 2

-- ❌ errors in Postgres: == is SQLite only
-- SELECT * FROM movies Where id ==6;

-- ✅ a single = works everywhere
SELECT * FROM movies
Where id = 6;

-- ✅ BETWEEN includes both ends, so 2000 and 2010 are both in
SELECT * FROM movies
Where year between 2000 and 2010;

-- ✅ NOT BETWEEN gives everything before 2000 and after 2010
SELECT * FROM movies
Where year not between 2000 and 2010;

-- ✅ <= includes 2003 itself
SELECT title, year FROM movies
WHERE year <= 2003;

--lesson 3

-- ❌ errors in Postgres: "Toy Story" in double quotes is read as a column name, not a string
-- SELECT * FROM movies Where Title LIKE "%Toy Story%";

-- ✅ strings go in single quotes, % matches any run of characters on either side
SELECT * FROM movies
Where Title LIKE '%Toy Story%';

-- ✅ LIKE without % or _ is an exact match, so = does the same job and is clearer
SELECT * FROM movies
Where Director = 'John Lasseter';

SELECT * FROM movies
Where Director != 'John Lasseter';

-- ❌ errors: there is no Movie column, the movie name is in Title
-- SELECT * FROM movies Where Movie LIKE "Wall-_";

-- ✅ _ matches exactly 1 character, % would match any number
-- (SQLite's LIKE ignores case, Postgres's doesn't, so match the case of the data: WALL-E)
SELECT * FROM movies
Where Title LIKE 'WALL-_';

--lesson 4

-- ✅ DISTINCT drops the repeated directors, ORDER BY sorts them A to Z
SELECT DISTINCT Director FROM movies
Order by Director ASC;

-- ❌ LIMIT without ORDER BY gives back any 4 rows, not the 4 newest
-- SELECT * FROM movies LIMIT 4;

-- ✅ sort first, then LIMIT keeps the top 4
SELECT * From movies
ORDER BY Year DESC
Limit 4;

SELECT * From movies
ORDER BY Title ASC
Limit 5;

-- ✅ OFFSET 5 skips the first 5, so this is rows 6 to 10 (page 2)
SELECT * From movies
ORDER BY Title ASC
Limit 5 OFFSET 5;

--Simple SELECT Queries exercises

-- ❌ errors in Postgres: "Canada" is read as a column name
-- SELECT city, population FROM north_american_cities WHERE country = "Canada";

-- ✅ single quotes for strings
SELECT city, population FROM north_american_cities
WHERE country = 'Canada';

-- ✅ DESC on latitude = north to south
SELECT city, latitude FROM north_american_cities
WHERE country = 'United States'
ORDER BY latitude DESC;

-- ✅ smaller (more negative) longitude = further west, ASC lists west to east
SELECT city, longitude FROM north_american_cities
WHERE longitude < -87.629798
ORDER BY longitude ASC;

-- ✅ exact match, so = instead of LIKE
SELECT city, population FROM north_american_cities
WHERE country = 'Mexico'
ORDER BY population DESC
LIMIT 2;

-- ✅ OFFSET 2 skips the 2 biggest, so this gives the 3rd and 4th
SELECT city, population FROM north_american_cities
Where country = 'United States'
ORDER BY population DESC
Limit 2 OFFSET 2;

-- lesson 6

-- ✅ ON matches each movie to its boxoffice row by the key, then WHERE filters the joined rows
SELECT * FROM movies
INNER JOIN boxoffice
    ON movies.id = Boxoffice.Movie_id
WHERE domestic_sales < 	international_sales;

SELECT * FROM movies
INNER JOIN boxoffice
    ON movies.id = Boxoffice.Movie_id
ORDER BY rating DESC;

--lesson 7

-- ✅ DISTINCT gives each building once
SELECT DISTINCT building FROM employees;

-- ❌ INNER JOIN drops the buildings that have no employees
-- SELECT DISTINCT building_name, role FROM buildings INNER JOIN employees ON building_name = building;

-- ✅ LEFT JOIN keeps every building, the empty ones get NULL for role
SELECT DISTINCT building_name, role
FROM buildings
  LEFT JOIN employees
    ON building_name = building;

--lesson 8

-- ❌ gives back 0 rows: nothing is ever = NULL
-- SELECT name, role FROM employees WHERE building = NULL;

-- ✅ IS NULL is the only way to test for NULL
SELECT name, role FROM employees
WHERE building IS NULL;

-- ✅ LEFT JOIN + IS NULL on the right side = rows with no match, i.e. buildings with no employees
SELECT DISTINCT building_name
FROM buildings
  LEFT JOIN employees
    ON building_name = building
WHERE role IS NULL;

-- lesson 9

-- ✅ expression in SELECT with an alias
-- (integer / integer drops the decimals, use 1000000.0 to keep them)
SELECT title, (domestic_sales + international_sales) / 1000000 AS gross_sales_millions
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;

SELECT title, rating * 10 AS Percent
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;

-- ❌ errors in Postgres: == is SQLite only
-- SELECT title, Year FROM movies JOIN boxoffice ON movies.id = boxoffice.movie_id WHERE Year%2==0;

-- ✅ % is the remainder, so remainder 0 when divided by 2 = even year
SELECT title, Year
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id
Where Year % 2 = 0;

--lesson 10

-- ✅ every non-aggregate column in SELECT (role) is in GROUP BY
SELECT role, Avg(years_employed) FROM employees
GROUP BY role;

SELECT building, SUM(years_employed) as Total_years_employed
FROM employees
GROUP BY building;

-- lesson 11

-- ❌ errors in Postgres: role sits next to COUNT(*) without a GROUP BY (SQLite lets it through)
-- SELECT role, COUNT(*) as Number_of_artists FROM employees WHERE role = "Artist";

-- ✅ WHERE keeps only the artists, GROUP BY role makes role allowed in SELECT
SELECT role, COUNT(*) as Number_of_artists
FROM employees
WHERE role = 'Artist'
GROUP BY role;

SELECT role, COUNT(*)
FROM employees
GROUP BY role;

-- ❌ errors in Postgres: same problem, role next to SUM() with no GROUP BY
-- SELECT role,SUM(years_employed) FROM employees WHERE role = "Engineer";

-- ✅
SELECT role, SUM(years_employed) FROM employees
WHERE role = 'Engineer'
GROUP BY role;

--lesson 12

-- ✅ join first, then group the joined rows by director
SELECT director, SUM(domestic_sales + international_sales) as Cumulative_sales_from_all_movies
FROM movies
    INNER JOIN boxoffice
        ON movies.id = boxoffice.movie_id
GROUP BY director;

--lesson 13

-- ❌ works, but breaks if the table gets a new column, and the double quotes error in Postgres
-- INSERT INTO movies VALUES (4, "Toy Story 4", "El Directore", 2015, 90);

-- ✅ naming the columns keeps it working even if the table changes later
INSERT INTO movies (id, title, director, year, length_minutes)
VALUES (4, 'Toy Story 4', 'El Directore', 2015, 90);

INSERT INTO boxoffice (movie_id, rating, domestic_sales, international_sales)
VALUES (4, 8.7, 340000000, 270000000);

--lesson 14

-- ❌ no WHERE = every movie gets this director
-- UPDATE movies SET director = 'John Lasseter';

-- ✅ WHERE on the id changes only that 1 row
UPDATE movies
SET director = 'John Lasseter'
WHERE id = 2;

-- ❌ "1999" is a string going into a number column (SQLite converts it, Postgres errors on the double quotes)
-- UPDATE movies SET Year = "1999" WHERE id = 3;

-- ✅ numbers go in without quotes
UPDATE movies
SET Year = 1999
WHERE id = 3;

-- ✅ several columns in 1 UPDATE, separated by commas
UPDATE movies
SET Title = 'Toy Story 3', Director = 'Lee Unkrich'
WHERE id = 11;

--lesson 15

-- ❌ no WHERE = every row in the table is deleted
-- DELETE FROM movies;

-- ✅ run it as a SELECT with the same WHERE first, to see what will be deleted
DELETE FROM movies
WHERE Year < 2005;

DELETE FROM movies
WHERE Director = 'Andrew Stanton';

--lesson 16

-- ✅ IF NOT EXISTS skips the error if the table is already there
CREATE TABLE IF NOT EXISTS DATABASE(
    Name TEXT,
    Version FLOAT,
    Download_count INT
);

--lesson 17

-- ✅ the default fills in the existing rows as well as new ones
ALTER TABLE Movies
  ADD COLUMN Aspect_ratio FLOAT DEFAULT 2.39;

-- ❌ errors in Postgres: "English" is read as a column name
-- ALTER TABLE movies ADD COLUMN Language TEXT DEFAULT "English";

-- ✅
ALTER TABLE movies
  ADD COLUMN Language TEXT DEFAULT 'English';

--lesson 18

-- ❌ errors if the table doesn't exist
-- DROP TABLE movies;

-- ✅ IF EXISTS skips the error
DROP TABLE IF EXISTS movies;

DROP TABLE IF EXISTS boxoffice;
