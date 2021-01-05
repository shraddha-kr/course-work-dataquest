-- 1. Introduction
-- 2. Writing Readable Queries
-- 3. The WITH Clause
-- a. 
SELECT * FROM
    (
     SELECT
         t.name,
         ar.name artist,
         al.title album_name,
         mt.name media_type,
         g.name genre,
         t.milliseconds length_milliseconds
     FROM track t
     INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
     INNER JOIN genre g ON g.genre_id = t.genre_id
     INNER JOIN album al ON al.album_id = t.album_id
     INNER JOIN artist ar ON ar.artist_id = al.artist_id
    )
WHERE album_name = "Jagged Little Pill";

-- b.
WITH track_info AS
    (                
     SELECT
         t.name,
         ar.name artist,
         al.title album_name,
         mt.name media_type,
         g.name genre,
         t.milliseconds length_milliseconds
     FROM track t
     INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
     INNER JOIN genre g ON g.genre_id = t.genre_id
     INNER JOIN album al ON al.album_id = t.album_id
     INNER JOIN artist ar ON ar.artist_id = al.artist_id
    )

SELECT * FROM track_info
WHERE album_name = "Jagged Little Pill";

/*
Create a query that shows summary data for every playlist in the Chinook database:

    Use a WITH clause to create a named subquery with the following info:
        The unique ID for the playlist.
        The name of the playlist.
        The name of each track from the playlist.
        The length of each track in seconds.
    Your final table should have the following columns, in order:
        playlist_id - the unique ID for the playlist.
        playlist_name - The name of the playlist.
        number_of_tracks - A count of the number of tracks in the playlist.
        length_seconds - The sum of the length of the playlist in seconds. This column should be an integer.
    The results should be sorted by playlist_id in ascending order.

*/
WITH playlist_info AS
    (
     SELECT
         p.playlist_id,
         p.name playlist_name,
         t.name track_name,
         (t.milliseconds / 1000) length_seconds
     FROM playlist p
     LEFT JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
     LEFT JOIN track t ON t.track_id = pt.track_id
    )

SELECT
    playlist_id,
    playlist_name,
    COUNT(track_name) number_of_tracks,
    SUM(length_seconds) length_seconds
FROM playlist_info
GROUP BY 1, 2
ORDER BY 1;

-- 4. Creating Views
/*
 Create a view called customer_2, identical to the existing customer table
*/
CREATE VIEW customer_2 AS
	   SELECT * FROM customer;

-- Modifying an existing view, gives you an error
CREATE VIEW customer_2 AS
    SELECT
        customer_id,
        first_name || last_name name,
        phone,
        email,
        support_rep_id
    FROM customer;
-- [Query 2: table customer_2 already exists]
-- [DROP VIEW customer_2;]

-- The first is a view of all customers that live in the USA.
CREATE VIEW customer_usa AS 
     SELECT * FROM 	customer
     WHERE country = "USA";

-- A second view of customers that have purchased more than $90 from our store.
CREATE VIEW customer_gt_90_dollars AS 
    SELECT
        c.*
    FROM invoice i
    INNER JOIN customer c ON i.customer_id = c.customer_id
    GROUP BY 1
    HAVING SUM(i.total) > 90;
    
SELECT * FROM customer_gt_90_dollars;


-- 5. Combining Rows With Union
-- Use UNION to produce a table of customers in the USA or have spent more than $90
-- UNION = OR
SELECT * FROM customer_usa
UNION
SELECT * FROM customer_gt_90_dollars;

-- 6. Combining Rows Using Intersect and Except
-- INTERSECT = AND
SELECT * from customer_usa
INTERSECT
SELECT * from customer_gt_90_dollars;

-- EXCEPT = AND NOT
SELECT * from customer_usa
EXCEPT
SELECT * from customer_gt_90_dollars;


/*Write a query that works out how many customers that are in the USA and have purchased more than $90 are assigned to each sales support agent. For the purposes of this exercise, no two employees have the same name.

    Your result should have the following columns, in order:
    employee_name - The first_name and last_name of the employee separated by a space, eg Luke Skywalker.
    customers_usa_gt_90 - The number of customers assigned to that employee that are both from the USA and have have purchased more than $90 worth of tracks.
    The result should include all employees with the title "Sales Support Agent", but not employees with any other title.
    Order your results by the employee_name column.
*/
WITH customers_usa_gt_90 AS
    (
     SELECT * FROM customer_usa

     INTERSECT

     SELECT * FROM customer_gt_90_dollars
    )

SELECT
    e.first_name || " " || e.last_name employee_name,
    COUNT(c.customer_id) customers_usa_gt_90
FROM employee e
LEFT JOIN customers_usa_gt_90 c ON c.support_rep_id = e.employee_id
WHERE e.title = 'Sales Support Agent'
GROUP BY 1 ORDER BY 1;

-- 7. Multiple Named SubQueries
WITH
    usa AS
        (
        SELECT * FROM customer
        WHERE country = "USA"
        ),
    last_name_g AS
        (
         SELECT * FROM usa
         WHERE last_name LIKE "G%"
        ),
    state_ca AS
        (
        SELECT * FROM last_name_g
        WHERE state = "CA"
        )

/*
Write a query that uses multiple named subqueries in a WITH clause to gather total sales data on customers from India:

    The first named subquery should return all customers that are from India.
    The second named subquery should calculate the sum total for every customer.
    The main query should join the two named subqueries, resulting in the following final columns:
        customer_name - The first_name and last_name of the customer, separated by a space, eg Luke Skywalker.
        total_purchases - The total amount spent on purchases by that customer.
    The results should be sorted by the customer_name column in alphabetical order.

*/
SELECT
    first_name,
    last_name,
    country,
    state
FROM state_ca

WITH
    customers_india AS
        (
        SELECT * FROM customer
        WHERE country = "India"
        ),
    sales_per_customer AS
        (
         SELECT
             customer_id,
             SUM(total) total
         FROM invoice
         GROUP BY 1
        )

SELECT
    ci.first_name || " " || ci.last_name customer_name,
    spc.total total_purchases
FROM customers_india ci
INNER JOIN sales_per_customer spc ON ci.customer_id = spc.customer_id
ORDER BY 1;


-- 8. Challenge: Each Country's Best Customer
/*Create a query to find the customer from each country that has spent the most money at our store, ordered alphabetically by country. Your query should return the following columns, in order:

    country - The name of each country that we have a customer from.
    customer_name - The first_name and last_name of the customer from that country with the most total purchases, separated by a space, eg Luke Skywalker.
    total_purchased - The total dollar amount that customer has purchased.
*/
WITH
    customer_country_purchases AS
        ( 
         SELECT
             i.customer_id,
             c.country,
             SUM(i.total) total_purchases
         FROM invoice i
         INNER JOIN customer c ON i.customer_id = c.customer_id
         GROUP BY 1, 2
        ),
    country_max_purchase AS
        (
         SELECT
             country,
             MAX(total_purchases) max_purchase
         FROM customer_country_purchases
         GROUP BY 1
        ),
    country_best_customer AS
        (
         SELECT
            cmp.country,
            cmp.max_purchase,
            (
             SELECT ccp.customer_id
             FROM customer_country_purchases ccp
             WHERE ccp.country = cmp.country AND cmp.max_purchase = ccp.total_purchases
            ) customer_id
         FROM country_max_purchase cmp
        )
SELECT
    cbc.country country,
    c.first_name || " " || c.last_name customer_name,
    cbc.max_purchase total_purchased
FROM customer c
INNER JOIN country_best_customer cbc ON cbc.customer_id = c.customer_id
ORDER BY 1 ASC