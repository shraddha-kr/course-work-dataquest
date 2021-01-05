-- 1. Working With Larger Databases
SELECT * FROM album LIMIT 3;

-- 2. Joining Three Tables
/*
For one single purchase (invoice_id) we want to know, for each track purchased:

    The id of the track.
    The name of the track.
    The name of media type of the track.
    The price that the customer paid for the track.
    The quantity of the track that was purchased.
*/
SELECT * FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
WHERE invoice_id = 3;

/*Write a query that gathers data about the invoice with an invoice_id of 4. Include the following columns in order:

    The id of the track, track_id.
    The name of the track, track_name.
    The name of media type of the track, track_type.
    The price that the customer paid for the track, unit_price.
    The quantity of the track that was purchased, quantity.
*/
SELECT il.track_id, t.name track_name, 
	   mt.name track_type, t.unit_price, il.quantity
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
WHERE invoice_id = 4

-- 3. Joining More Than Three Tables
/*Add a column containing the artists name to the query from the previous screen.

    The column should be called artist_name
    The column should be placed between track_name and track_type
*/

SELECT il.track_id, t.name track_name, a.name artist_name,
	   mt.name track_type, t.unit_price, il.quantity	   
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
INNER JOIN album al ON al.album_id = t.album_id
INNER JOIN artist a ON a.artist_id = al.artist_id
WHERE invoice_id = 4;

-- 4. Combining Multiple Joins With SubQueries
-- Q:What we want to produce is a query that lists the top 10 artists, calculated by the number of times a track by that artist has been purchased.

-- a. Write a subquery that produces a table with track.track_id and artist.name,
SELECT t.track_id, a.name 
FROM track t
INNER JOIN album al ON al.album_id = t.album_id
INNER JOIN artist a ON a.artist_id = al.artist_id 
ORDER BY t.track_id
LIMIT 5;

-- b. Join that subquery to the invoice_line table.
SELECT
    il.invoice_line_id,
    il.track_id,
    ta.artist_name
FROM invoice_line il
INNER JOIN (
            SELECT
                t.track_id,
                ar.name artist_name
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta
           ON ta.track_id = il.track_id
ORDER BY 1 LIMIT 5;

-- c. Use a GROUP BY statement to calculate the number of times each artist has had a track purchased, and find the top 10.
SELECT
    ta.artist_name artist,
    COUNT(*) tracks_purchased
FROM invoice_line il
INNER JOIN (
            SELECT 
                t.track_id,
                ar.name artist_name
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta ON ta.track_id = il.track_id
GROUP BY artist
ORDER BY tracks_purchased DESC 
LIMIT 10;

/*
Write a query that returns the top 5 albums, as calculated by the number of times a track from that album has been purchased. Your query should be sorted from most tracks purchased to least tracks purchased and return the following columns, in order:

    album, the title of the album
    artist, the artist who produced the album
    tracks_purchased the total number of tracks purchased from that album
*/
SELECT
    ta.album_title album,
    ta.artist_name artist,
    COUNT(*) tracks_purchased
FROM invoice_line il
INNER JOIN (
            SELECT
                t.track_id,
                al.title album_title,
                ar.name artist_name
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta
           ON ta.track_id = il.track_id
GROUP BY 1, 2
ORDER BY 3 DESC LIMIT 5;


-- 5. Recursive Joins
SELECT
    e1.employee_id,
    e2.employee_id supervisor_id
FROM employee e1
INNER JOIN employee e2 on e1.reports_to = e2.employee_id
LIMIT 4;

-- Concatenate Operator
SELECT
    album_id,
    artist_id,
    "album id is" || album_id col_1,
    "artist id is" || artist_id col2,
    album_id || artist_id col3
FROM album LIMIT 3;

/*
Write a query that returns information about each employee and their supervisor.

    The report should include employees even if they do not report to another employee.
    The report should be sorted alphabetically by the employee_name column.
    Your query should return the following columns, in order:
        employee_name - containing the first_name and last_name columns separated by a space, eg Luke Skywalker
        employee_title - the title of that employee
        supervisor_name - the first and last name of the person the employee reports to, in the same format as employee_name
        supervisor_title - the title of the person the employee reports to
*/
SELECT
     e1.first_name || " " || e1.last_name employee_name,
     e1.title employee_title,
     e2.first_name || " " || e1.last_name supervisor_name,
     e2.title supervisor_title
FROM employee e1
LEFT JOIN employee e2 ON e1.reports_to = e2.employee_id 
ORDER BY employee_name
LIMIT 5;


-- 6. Pattern Matching Using Like
SELECT
    first_name,
    last_name,
    phone
FROM customer
WHERE first_name LIKE "%Jen%";


/*Write a query that finds the contact details of a customer with a first_name containing Belle from the database. Your query should include the following columns, in order:

    first_name
    last_name
    phone
*/
SELECT 
	  first_name,
	  last_name,
	  phone
FROM customer
WHERE first_name LIKE "%Belle%";


-- 7. Generating Columns With The Case
/*Let's look at how we can use CASE to add a new column protected, which indicates whether each media type is protected.
*/
SELECT
    media_type_id,
    name,
    CASE
        WHEN name LIKE '%Protected%' THEN 1
        ELSE 0
        END
        AS protected
FROM media_type;
--In this example, our CASE statement has a single WHEN which looks for a partial match of the string Protected in the name column. Any rows with a match get a value of 1; all other rows get 0.

/*
Write a query that summarizes the purchases of each customer. For the purposes of this exercise, we do not have any two customers with the same name.

    Your query should include the following columns, in order:
        customer_name - containing the first_name and last_name columns separated by a space, eg Luke Skywalker.
        number_of_purchases, counting the number of purchases made by each customer.
        total_spent - the total sum of money spent by each customer.
        customer_category - a column that categorizes the customer based on their total purchases. The column should contain the following values:
            small spender - If the customer's total purchases are less than $40.
            big spender - If the customer's total purchases are greater than $100.
            regular - If the customer's total purchases are between $40 and $100 (inclusive).
    Order your results by the customer_name column.

*/
SELECT
	  c.first_name || " " || c.last_name customer_name,
	  COUNT(i.invoice_id) number_of_purchases,
	  SUM(i.total) total_spent,
	  CASE
	  	  WHEN SUM(i.total) < 40 THEN 'small spender'
	  	  WHEN SUM(i.total) > 100 THEN 'big spender'
	  	  ELSE 'regular'
	  	  END
	  	  AS customer_category
FROM invoice i
INNER JOIN customer c ON i.customer_id = c.customer_id
GROUP BY customer_name
ORDER BY customer_name;
	  	  
















