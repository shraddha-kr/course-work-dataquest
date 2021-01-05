/* 4. Summary Statistics
Write a single query that returns the following:
        Minimum population
        Maximum population
        Minimum population growth
        Maximum population growth
*/
SELECT MIN(population), MAX(population),
	   MIN(population_growth), MAX(population_growth)
FROM facts;	   

/* 5. Exploring Outliers
Write a query that returns the countries with the minimum population.
Write a query that returns the countries with the maximum population.
*/
-- MIN POPULATION
SELECT name, population
FROM facts
ORDER BY population ASC;

SELECT *
FROM facts
WHERE population == (SELECT MIN(population)
                        FROM facts
                     );

-- MAX POPULATION
%%sql
SELECT *
  FROM facts
 WHERE population == (SELECT MAX(population)
                        FROM facts
                     );

/* 6. Exploring Average Population And Area
Recompute the summary statistics you found earlier while excluding the row for the whole world. Include the following:
        Minimum population
        Maximum population
        Minimum population growth
        Maximum population growth

In a different code cell, calculate the average value for the following columns:
        population
        area
*/
SELECT MIN(population) AS min_pop,
       MAX(population) AS max_pop,
       MIN(population_growth) AS min_pop_growth,
       MAX(population_growth) AS max_pop_growth 
FROM facts
WHERE name != 'World';


/* 7. Finding Densely Populated Countries
Write a query that finds all countries meeting both of the following criteria:
    The population is above average.
    The area is below average.
*/
SELECT name
FROM facts
WHERE population > (SELECT AVG(population) FROM facts WHERE name!='World')
AND
	  area < (SELECT AVG(area) FROM facts WHERE name!='World');
