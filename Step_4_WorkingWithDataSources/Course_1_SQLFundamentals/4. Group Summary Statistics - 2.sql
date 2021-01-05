-- 8. Querying Virtual Columns with the HAVING Statement
SELECT Major_category, (AVG(Low_wage_jobs) / AVG(Total)) AS 'Share_low_wage'
FROM new_grads
GROUP BY Major_category
HAVING Share_low_wage > .1

-- 9. Order Of Execution
/* And the order in which SQL runs this is as follows:
    FROM
    WHERE
    GROUP BY
    HAVING
    SELECT
    ORDER BY
    LIMIT   */
    
-- 10. Rounding Results With the ROUND() Function
SELECT ROUND(Sharewomen, 4) AS Rounded_women,
	   Major_category
FROM new_grads
LIMIT 10;

-- 11. Nesting Functions
SELECT Major_category,
	   ROUND((AVG(College_jobs) / AVG(Total)), 3) AS Share_degree_jobs
FROM new_grads
GROUP BY Major_category
HAVING Share_degree_jobs < .3;

-- 12. Casting
SELECT Major_category, 
	   CAST(SUM(Women) AS FLOAT) / CAST(SUM(Total)AS FLOAT) AS SW
FROM new_grads
GROUP BY Major_category
ORDER BY SW;