-- 1. Introducing Joins
--Write a query that returns all columns from the facts and cities tables.
SELECT * 
FROM facts 
INNER JOIN cities ON cities.facts_id = facts.id
LIMIT 10;

-- 2. Understanding INNER Joins
SELECT c.*, f.name country_name 
FROM facts f
INNER JOIN cities c ON c.facts_id = f.id
LIMIT 5;

-- 3. Practicing INNER Joins
/*Write a query that uses an INNER JOIN to join the two tables in your query and returns, in order:
    A column of country names, called country.
    A column of each country's capital city, called capital_city. */
SELECT f.name country, c.name capital_city
FROM facts f
INNER JOIN cities c ON c.facts_id = f.id
WHERE c.capital == 1;

-- 4. LEFT Joins
/*Write a query that returns the countries that don't exist in cities:
    Your query should return two columns:
        The country names, with the alias country.
        The country population.
    Use a LEFT JOIN to join cities to facts.
    Include only the countries from facts that don't have a corresponding value in cities.
*/
SELECT COUNT(DISTINCT(name)) FROM facts;
SELECT COUNT(DISTINCT(facts_id)) FROM cities;

SELECT f.name country, f.population
FROM facts f
LEFT JOIN cities c ON c.facts_id = f.id
WHERE c.capital IS NULL;

-- 5. RIGHT & OUTER JOINS
-- 6. FINDING THE MOST POPULOUS CAPITAL CITIES
SELECT c.name capital_city, f.name	country, c.population population
FROM facts f
INNER JOIN cities c ON c.facts_id = f.id
WHERE c.capital = 1
ORDER BY c.population DESC 
LIMIT 10;

-- 7. Combining Joins With SubQueries
SELECT f.name country, c.name capital_city
FROM facts f
INNER JOIN (
			  SELECT * FROM cities
			  WHERE capital = 1
			) c ON c.facts_id = f.id
LIMIT 10;	


/*Using a join and a subquery, write a query that returns capital cities with populations of over 10 million ordered from largest to smallest. Include the following columns:

    capital_city - the name of the city.
    country - the name of the country the city is the capital of.
    population - the population of the city.
*/
SELECT c.name capital_city, f.name country, c.population population 
FROM facts f
INNER JOIN(
			SELECT * FROM cities			
			WHERE population > 10000000
			AND capital = 1
		   ) c ON c.facts_id = f.id
ORDER BY c.population DESC;		

-- 8. Complex Query with Joins and Subqueries
/*
Write a query that generates output as shown above. The query should include:
    The following columns, in order:
        country, the name of the country.
        urban_pop, the sum of the population in major urban areas belonging to that country.
        total_pop, the total population of the country.
        urban_pct, the percentage of the population within urban areas, calculated by dividing urban_pop by total_pop.
    Only countries that have an urban_pct greater than 0.5.
    Rows should be sorted by urban_pct in ascending order.
*/
SELECT
    f.name country,
    c.urban_pop,
    f.population total_pop,
    (c.urban_pop / CAST(f.population AS FLOAT)) urban_pct
FROM facts f
INNER JOIN (
            SELECT
                facts_id,
                SUM(population) urban_pop
            FROM cities
            GROUP BY facts_id
           ) c ON c.facts_id = f.id
WHERE urban_pct > .5
ORDER BY urban_pct ASC;