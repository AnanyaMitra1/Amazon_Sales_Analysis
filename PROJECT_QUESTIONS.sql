SELECT * FROM capstone_sql.amazon;

-- 1.What is the count of distinct cities in the dataset?

select count(distinct city) as cities from amazon;
 
-- ------------------------------------------------------

-- 2.For each branch, what is the corresponding city?

select distinct branch, city 
from amazon;


-- -----------------------------------------------------------------------

-- 3.What is the count of distinct product lines in the dataset?

select count(distinct `product line`) as distinct_productline
from amazon ;


-- -------------------------------------------------------------------------

-- 4.Which payment method occurs most frequently?

-- Selecting the column 'payment' and counting the occurrences of each payment method
SELECT 
    payment, -- Selecting the payment method
    COUNT(*) as Payment_count -- Counting the occurrences of each payment method and aliasing it as Payment_count
FROM 
    amazon 
GROUP BY 
    payment -- Grouping the results by payment method
ORDER BY 
    Payment_count DESC -- Ordering the results by Payment_count (number of occurrences of each payment method) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) Payment_count



-- ------------------------------------------------------------------------

-- 5. Which product line has the highest sales?

-- Selecting the column 'Product line' and counting the number of 'Invoice ID's for each product line
SELECT 
    `Product line`, -- Selecting the product line
    COUNT(`Invoice ID`) as sales_count -- Counting the number of 'Invoice ID's and aliasing it as sales_count
FROM 
    amazon 
GROUP BY 
    `Product line` -- Grouping the results by product line
ORDER BY 
    sales_count DESC -- Ordering the results by sales_count (number of 'Invoice ID's) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) sales count


-- -------------------------------------------------------------------------

-- 6. How much revenue is generated each month?

select distinct(monthname) from amazon;  -- finding the distinct months in the dataset

select month, count(`Invoice ID`) as monthly_sales
from amazon
group by month;


-- -----------------------------------------------------------------------------


-- 7.In which month did the cost of goods sold reach its peak?

-- Selecting the month and calculating the sum of COGS for each month
SELECT 
    month, -- Selecting the month
    SUM(cogs) AS total_cogs -- Calculating the total COGS and aliasing it as total_cogs
FROM 
    amazon 
GROUP BY 
    month -- Grouping the results by month
ORDER BY 
    total_cogs DESC -- Ordering the results by total_cogs (total COGS) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) total_cogs


-- ---------------------------------------------------------------------------------

-- 8. Which product line generated the highest revenue?

-- Selecting the column 'Product line' and calculating the total revenue for each product line
SELECT 
    `Product line`, -- Selecting the product line
    SUM(total) AS Total_Revenue -- Calculating the total revenue for each product line and aliasing it as Total_Revenue
FROM 
    amazon 
GROUP BY 
    `Product line` -- Grouping the results by product line
ORDER BY 
    Total_Revenue DESC
    -- Ordering the results by Total_Revenue (total revenue) in descending order
LIMIT 1;
-- Limiting the result to only the top (highest) Total_Revenue

-- -----------------------------------------------------------------------------

-- 9. In which city was the highest revenue recorded?

-- Selecting the column 'city' and calculating the total revenue for each city
SELECT 
    city, -- Selecting the city
    SUM(total) AS Total_Revenue 
    -- Calculating the total revenue for each city and aliasing it as Total_Revenue
FROM 
    amazon 
GROUP BY 
    city -- Grouping the results by city
ORDER BY 
    Total_Revenue DESC -- Ordering the results by Total_Revenue (total revenue) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) Total_Revenue


-- -------------------------------------------------------------------

-- 10. Which product line incurred the highest Value Added Tax?

 -- Selecting the column 'Product line' and calculating the total VAT amount for each product line
SELECT 
    `Product line`, -- Selecting the product line
    SUM(`Tax 5%`) AS total_vat_amount -- Calculating the total VAT amount for each product line and aliasing it as total_vat_amount
FROM 
    amazon 
GROUP BY 
    `Product line` -- Grouping the results by product line
ORDER BY 
    total_vat_amount DESC -- Ordering the results by total_vat_amount (total VAT amount) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) total VAT amount

-- --------------------------------------------------------------------------


-- 11.For each product line, 
-- add a column indicating "Good" if its sales are above average, otherwise "Bad."

-- Selecting the column 'Product line', calculating the total revenue for each product line,
-- and categorizing the sales as 'good' or 'bad' based on the comparison with the average total revenue
SELECT 
    `Product line`, -- Selecting the product line
    SUM(total) AS Total_Revenue, -- Calculating the total revenue for each product line
    CASE 
        WHEN SUM(total) < (SELECT AVG(total) FROM amazon) THEN 'Bad' -- Categorizing sales as 'Bad' if the total revenue for the product line is below the average total revenue
        ELSE 'good' -- Categorizing sales as 'good' otherwise
    END AS kindofsale -- Alias for the column representing the type of sale
FROM 
    amazon 
GROUP BY 
    `Product line` -- Grouping the results by product line
ORDER BY 
    Total_Revenue DESC; -- Ordering the results by Total_Revenue (total revenue) in descending order

-- -------------------------------------------------------------------------------


-- 12. Identify the branch that exceeded the average number of products sold.

     select distinct branch from amazon 
     where quantity > 
     (select avg(quantity) from amazon);
     ----
     
      select  branch, sum(quantity) 
      from amazon 
      group by branch
      having sum(quantity)  > (select avg(quantity) from amazon);
    
    
    SELECT 
    Branch,
    SUM(Quantity) AS Total_Quantity
FROM 
    amazon
GROUP BY 
    Branch
HAVING 
    SUM(Quantity) > (SELECT AVG(Quantity) FROM amazon);
    
    -- ------------------------------------------------------------------------------

-- 13 Which product line is most frequently associated with each gender?

-- Using a Common Table Expression (CTE) named "freq" to calculate the frequency of purchases for each product line and gender combination,
-- and assigning an "obsession level" using the ROW_NUMBER() window function
WITH freq AS (
    SELECT  
        `product line`, -- Selecting the product line
        gender, -- Selecting the gender
        COUNT(`Invoice ID`) AS frequ, -- Counting the number of Invoice IDs and aliasing it as frequ
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(`Invoice ID`) DESC) AS obsession_level -- Assigning an "obsession level" based on the count of Invoice IDs for each gender, ordered in descending order
    FROM 
        amazon 
    GROUP BY 
        `Product line`, gender -- Grouping the results by product line and gender
)
-- Selecting the product line, gender, and frequency where the "obsession level" is equal to 1,
-- which indicates the most purchased product line for each gender
SELECT  
    `product line`, -- Selecting the product line
    gender, -- Selecting the gender
    frequ -- Selecting the frequency of purchases
FROM 
    freq
WHERE 
    obsession_level = 1; -- Filtering out rows where the "obsession level" is equal to 1


-- -------------------------------------------------------------------------------

-- 14. Calculate the average rating for each product line.

-- Selecting the column 'product line' and calculating the average rating for each product line
SELECT 
    `product line`, -- Selecting the product line
    AVG(rating) as pl_avg_rating -- Calculating the average rating and aliasing it as pl_avg_rating
FROM 
    amazon 
GROUP BY 
    `product line` -- Grouping the results by product line
ORDER BY 
    pl_avg_rating DESC; -- Ordering the results by pl_avg_rating (average rating) in descending order

-- ----------------------------------------------------------------------------------

-- 15.Count the sales occurrences for each time of day on every weekday.

-- Selecting the columns dayname, timeofday 
-- and counting the number of Invoice IDs for each day and time of day
SELECT 
    dayname, -- Selecting the day of the week
    timeofday, -- Selecting the time of day
    count(`Invoice ID`) as count_of_sale -- Counting the number of Invoice IDs and aliasing it as count_of_sale
FROM 
    amazon 
WHERE 
    dayname NOT IN ('Saturday','Sunday') -- Filtering out Saturday and Sunday sales
GROUP BY 
    dayname, timeofday -- Grouping the results by day of the week and time of day
ORDER BY 
    dayname DESC, count_of_sale DESC; -- Ordering the results by day of the week in descending order, then by count_of_sale in descending order



-- ----------------------------------------------------------------------------------

-- 16.Identify the customer type contributing the highest revenue.

-- Selecting the column 'customer type' and calculating the total revenue for each customer type
SELECT 
    `customer type`, -- Selecting the customer type
    sum(total) as rev -- Calculating the total revenue and aliasing it as rev
FROM 
    amazon 
GROUP BY 
    `customer type` -- Grouping the results by customer type
ORDER BY 
    rev desc -- Ordering the results by rev (total revenue) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) revenue


-- -------------------------------------------------------------------------------


-- -- 17.Determine the city with the highest VAT percentage.

-- Selecting the column City and calculating the VAT percentage for each city
SELECT 
    City, -- Selecting the city
    COALESCE(SUM(`Tax 5%`) / NULLIF(SUM(Total), 0) * 100, NULL) AS VAT_Percentage 
    -- Calculating the VAT percentage using SUM(`Tax 5%`) divided by SUM(Total) and multiplying
    -- by 100. Using COALESCE to handle division by zero errors and return NULL in such cases.
FROM 
    amazon 
GROUP BY 
    City -- Grouping the results by city
ORDER BY 
    VAT_Percentage DESC -- Ordering the results by VAT_Percentage in descending order
LIMIT 1; -- Limiting the result to only the top (highest) VAT_Percentage

-- -------------------------------------------------------------------------------

-- 18.identify the customer type with the highest VAT payments.

-- Selecting the column 'customer type' and calculating the sum of 'tax 5%' for each customer type
SELECT 
    `customer type`, -- Selecting the customer type
    sum(`tax 5%`) as vat_p -- Calculating the sum of 'tax 5%' and aliasing it as vat_p
FROM 
    amazon 
GROUP BY 
    `customer type` -- Grouping the results by customer type
ORDER BY 
    vat_p desc -- Ordering the results by vat_p (sum of 'tax 5%') in descending order
LIMIT 1; -- Limiting the result to only the top (highest) vat_p


-- 19 What is the count of distinct customer types in the dataset?

select count(distinct `customer type`) as dct
from amazon;

-- --------------------------------------------------------------------------------

-- 20 What is the count of distinct payment methods in the dataset?

-- Selecting the count of distinct payment methods
SELECT 
    count(distinct payment) as dpm -- Counting the number of distinct payment methods and aliasing it as dpm
FROM 
    amazon; 


-- -----------------------------------------------------------------------------

-- 21. Which customer type occurs most frequently?

-- Selecting the column 'customer type' and counting the number of 'Invoice ID's for each customer type
SELECT 
    `customer type`, -- Selecting the customer type
    count(`Invoice ID`) as freq -- Counting the number of 'Invoice ID's and aliasing it as freq
FROM 
    amazon
GROUP BY 
    `customer type` -- Grouping the results by customer type
ORDER BY 
    freq desc -- Ordering the results by freq (number of 'Invoice ID's) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) frequency


-- ---------------------------------------------------------------------------


-- 22 Identify the customer type with the highest purchase frequency.

-- Selecting the column 'Customer type' and counting the number of purchases for each customer type
SELECT 
    `Customer type`, -- Selecting the customer type
    COUNT(*) AS Purchase_Frequency -- Counting the number of purchases and aliasing it as Purchase_Frequency
FROM 
    amazon 
GROUP BY 
    `Customer type` -- Grouping the results by customer type
ORDER BY 
    Purchase_Frequency DESC -- Ordering the results by Purchase_Frequency (number of purchases) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) purchase frequency



-- ------------------------------------------------------------------------------



-- 23.Determine the predominant gender among customers.

-- Selecting the column gender and counting the number of purchases for each gender
SELECT 
    gender, -- Selecting the gender
    COUNT(*) AS Purchase_Frequency -- Counting the number of purchases and aliasing it as Purchase_Frequency
FROM 
    amazon 
GROUP BY 
    gender -- Grouping the results by gender
ORDER BY 
    Purchase_Frequency DESC -- Ordering the results by Purchase_Frequency (number of purchases) in descending order
LIMIT 1; -- Limiting the result to only the top (highest) purchase frequency



-- -------------------------------------------------------------------------

-- 24 Examine the distribution of genders within each branch.

-- Selecting the columns Branch, gender, and counting the number of Invoice IDs for each combination
SELECT 
    branch, -- Selecting the branch
    gender, -- Selecting the gender
    count(`Invoice ID`) as freq_co -- Counting the number of Invoice IDs and aliasing it as freq_co
FROM 
    amazon 
GROUP BY 
    branch, gender -- Grouping the results by branch and gender
ORDER BY 
    branch, freq_co desc; -- Ordering the results by branch in ascending order and freq_co (number of Invoice IDs) 
                            -- in descending order



-- ---------------------------------------------------------------------------------------

-- 25. Identify the time of day when customers provide the most ratings.

-- Selecting the column TimeOfDay and counting the number of ratings for each time of day
SELECT 
    TimeOfDay, -- Selecting the time of day
    COUNT(rating) AS freq -- Counting the number of ratings and aliasing it as freq
FROM 
    amazon 
GROUP BY 
    TimeOfDay -- Grouping the results by TimeOfDay
ORDER BY 
    freq DESC; -- Ordering the results by freq (number of ratings) in descending order




-- ------------------------------------------------------------------------------------

-- 26. Determine the time of day with the highest customer ratings for each branch.

-- Selecting the columns TimeOfDay, BRANCH, and counting the number of ratings for each combination
SELECT 
    TimeOfDay, -- Selecting the time of day
    BRANCH, -- Selecting the branch
    COUNT(rating) AS freq -- Counting the number of ratings and aliasing it as freq
FROM 
    amazon 
GROUP BY 
    TimeOfDay, BRANCH -- Grouping the results by TimeOfDay and BRANCH
ORDER BY 
    freq DESC; -- Ordering the results by freq (number of ratings) in descending order


-- --------------------------------------------------------------------------------


-- 27.Identify the day of the week with the highest average ratings.

-- Selecting the DAYNAME and calculating the average Rating for each day

SELECT 
    DAYNAME, -- Selecting the day of the week
    AVG(Rating) AS Average_Rating -- Calculating the average rating and aliasing it as Average_Rating
FROM 
    amazon -- 
GROUP BY 
    DAYNAME -- Grouping the results by day of the week
ORDER BY 
    Average_Rating DESC -- Ordering the results by Average_Rating in descending order
LIMIT 1; -- Limiting the result to only the top (highest) average rating

-- --------------------------------------------


-- 28 Determine the day of the week with the highest average ratings for each branch.

 -- Selecting the columns Branch, DAYNAME, and the average Rating
SELECT 
    Branch,
    DAYNAME,
    AVG(Rating) AS Average_Rating -- Calculating the average rating and aliasing it as Average_Rating
FROM 
    amazon
GROUP BY 
    Branch, DAYNAME -- Grouping the results by Branch and DAYNAME
ORDER BY 
    Branch, Average_Rating DESC; -- Ordering the results by Branch in ascending order and Average_Rating in descending order

