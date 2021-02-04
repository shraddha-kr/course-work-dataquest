--What is the proportion of women on the recent_grads table?
--List three lowest ShareWomen values
SELECT Rank, ShareWomen
FROM recent_grads
ORDER BY ShareWomen ASC
LIMIT 3;

SELECT MIN(ShareWomen) 
FROM recent_grads;
  
--2. Query that returns the lowest unemployment rate
SELECT MIN(Unemployment_rate)
FROM recent_grads;

--3. Query that computes the sum of the Total column
SELECT SUM(Total)
FROM recent_grads;

--4. How many majors included mostly women
SELECT COUNT(Major)
FROM recent_grads
WHERE ShareWomen > 0.5;

-- How many majors included mostly men
SELECT COUNT(Major)
FROM recent_grads
WHERE ShareWomen < 0.5;

--5. Query to find a column that has at least one missing value.
SELECT COUNT(*), COUNT(Unemployment_rate)
FROM recent_grads;
  
-- 6. Combining Multiple Aggregation Functions
-- Query that calculates the average of the Total column, the minimum of the Men column, and the maximum of the Women column, in that order.
SELECT AVG(Total), MIN(Men), MAX(Women)
FROM recent_grads;

-- 7. Customizing the Results
SELECT COUNT(*) AS 'Number of Majors', MAX(Unemployment_rate) AS 'Highest Unemployment Rate' 
FROM recent_grads;

-- 8. Counting Unique Values
-- Query to return all of the unique values in a column 
SELECT DISTINCT Major_category
FROM recent_grads;

-- Query to count the number of unique values in a column
SELECT COUNT(DISTINCT Major_category)
AS unique_major_categories
FROM recent_grads;

-- Query that returns the number of unique values in the Major, Major_category, 
-- and Major_code columns.
SELECT 
COUNT(DISTINCT Major) AS unique_majors,
COUNT(DISTINCT Major_category) AS unique_major_categories,
COUNT(DISTINCT Major_code) AS unique_major_codes
FROM recent_grads;

-- 9. Data Types
--https://www.sqlite.org/datatype3.html
SELECT Major, Total, Men, Women, Unemployment_rate
  FROM recent_grads
 ORDER BY Unemployment_rate DESC
 LIMIT 3;

-- 10. String Functions And Operations
SELECT Major,
       Total, Men, Women, Unemployment_rate,
       LENGTH(Major) AS Length_of_name
FROM recent_grads
ORDER BY Unemployment_rate DESC
LIMIT 3;

-- We can also concatenate strings by using the || operator.
SELECT 'Data' || 'quest' as 'e-learning';

-- We can compare columns with both constant numbers and other columns in WHERE clauses, we can also mix columns and constant strings when concatenating.
SELECT 'Cat: ' || Major_category
FROM recent_grads
LIMIT 2;

-- Query to replace the Major column with one where all values appear in lowercase letters
SELECT 'Major: ' || LOWER(Major) AS 'Major', 
		Total, Men, Women, Unemployment_rate,
		LENGTH(Major) AS 'Length_of_name'
FROM recent_grads
ORDER BY Unemployment_rate DESC;

-- 11. Performing Arithmetic in SQL
SELECT Major,
	   Major_category,
	   P75th - P25th AS 'quartile_spread'
FROM recent_grads
ORDER BY quartile_spread
LIMIT 20;
