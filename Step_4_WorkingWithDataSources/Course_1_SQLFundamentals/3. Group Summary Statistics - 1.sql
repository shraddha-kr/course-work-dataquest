-- 2. If/then in SQL
-- We may want to create a column that indicates whether or not the value on rank for each row is greater than 10.
SELECT Major, Rank,
	   CASE
	   WHEN rank <= 10 THEN 'Top 10'
	   WHEN rank <= 20 THEN 'Top 20'
	   ELSE NULL
	   END AS rank_category
FROM recent_grads;

--3. We'll categorize the Sample_size column into three categories: Small, Medium, and Large.
SELECT CASE
       WHEN Sample_size < 200 THEN 'Small'
       WHEN Sample_size < 1000 THEN 'Medium'
       ELSE 'Large'
       END AS Sample_category
FROM recent_grads;	
  
-- 3. Dissecting CASE
SELECT Major, Sample_size, 
	   CASE
	   WHEN Sample_size < 200 THEN 'Small'
	   WHEN Sample_size < 1000 THEN 'Medium'
	   ELSE 'Large'
	   END AS Sample_category
FROM recent_grads;	

-- 4. Calculating Group-Level Summary Statistics
-- Query to find the total no of people employed in each major category
SELECT Major_category, SUM(Total) AS 'Total_graduates'
FROM recent_grads
GROUP BY Major_category;

-- 5. GROUP BY Visual Breakdown
SELECT Major_category, AVG(ShareWomen) AS 'Average_women'
FROM recent_grads
GROUP BY Major_category;

-- 6. Multiple Summary Statistics By Group
SELECT Major_category,
       SUM(Employed), AVG(Employed), MAX(Employed), MIN(Employed)
FROM recent_grads
GROUP BY Major_category;

-- Query that computes the difference between the maximum and the minimum number of employed graduates
SELECT Major_category,
       SUM(Employed), AVG(Employed), 
       MAX(Employed) - MIN(Employed) as range_employed
FROM recent_grads
GROUP BY Major_category;

SELECT Major_category,
	   SUM(Women) AS 'Total_women',
	   AVG(ShareWomen) AS 'Mean_women',
	   SUM(Total) * AVG(ShareWomen) AS 'Estimate_women'
FROM recent_grads
GROUP BY Major_category;

-- 7. Multiple Group Columns  ******TO DO********
-- Update new_grad with a additional col values using CASE 
UPDATE new_grads
SET Sample_category = CASE
        			  WHEN new_grads.Sample_size < 200 THEN 'Small'
        			  WHEN new_grads.Sample_size < 1000 THEN 'Medium'
                      WHEN (new_grads.Sample_size > 1000 AND new_grads.Major_category != NULL) THEN 'Large'                
        			  END

SELECT Major_category, COUNT(DISTINCT Sample_category)
FROM new_grads
GROUP BY Major_category;


SELECT Major_category, Sample_category,
       AVG(ShareWomen) AS Mean_women,
       SUM(Total) AS Total_graduates
FROM new_grads
GROUP BY Major_category, Sample_category;

-- Continued with jobs_new.db in separate workspace