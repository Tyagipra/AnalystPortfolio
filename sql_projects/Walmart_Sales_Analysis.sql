CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INTEGER NOT NULL,
    vat FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ) NOT NULL,
    rating FLOAT(2 , 1 )
);
 
 SELECT 
    *
FROM
    salesDataWalmart.sales;
 
 -- -----------------------------------------------------------------------------------------
 -- ----------------------------Feature Engineering------------------------------------------
 
 SELECT 
    time,
    (CASE
        WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    sales;
 
 
 Alter Table sales Add Column time_of_day varchar(30);
 
 UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
         
 -- -- day_name----
 
 SELECT 
    date, DAYNAME(date)
FROM
    sales;
 
 Alter table sales add column day_name varchar(30);
 
 UPDATE sales 
SET 
    day_name = DAYNAME(date);
    
-- month_name------------    
 
 SELECT 
    date, MONTHNAME(date)
FROM
    sales;
    
    Alter table sales add column month_name varchar(30);
    
    UPDATE sales 
SET 
    month_name = MONTHNAME(date);
 
 -- Exploratory Analysis-----
 
-- 1. How many unique Cities data have?---

SELECT 
    COUNT(DISTINCT (city))
FROM
    sales AS Count_of_unique_cities;
 
 -- 2. In which city is each branch?--
 
 SELECT DISTINCT
    branch, city
FROM
    sales;
 
 -- 3. How Many unique product lines does data have?---
 
 SELECT DISTINCT
    product_line
FROM
    sales;
    
-- 4. What is most common payment method?--

SELECT 
    payment_method,
    COUNT(payment_method) AS count_of_payment_method
FROM
    sales
GROUP BY payment_method
ORDER BY count_of_payment_method DESC;

-- 5. Which is most selling product line?--

SELECT 
    product_line, COUNT(product_line) AS count_of_product_line
FROM
    sales
GROUP BY product_line
ORDER BY count_of_product_line DESC;

-- 6. What is total revenue by month?--

SELECT 
    month_name, SUM(total) AS total_revenue_monthwise
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue_monthwise DESC;

-- 7. What month had the largest COGS?

SELECT 
    month_name, SUM(cogs) AS largest_cogs
FROM
    sales
GROUP BY month_name
ORDER BY largest_cogs DESC;

-- 8. What product line had the largest revenue?

SELECT 
    product_line, SUM(total) AS Largest_Revenue
FROM
    sales
GROUP BY product_line
ORDER BY Largest_Revenue DESC;

-- 9. What is the city with the largest revenue?

SELECT 
    city, SUM(total) AS Largest_Revenue
FROM
    sales
GROUP BY city
ORDER BY Largest_Revenue DESC;

-- 10. What product line had the largest VAT?

SELECT 
    product_line, AVG(VAT) AS Largest_VAT
FROM
    sales
GROUP BY product_line
ORDER BY Largest_VAT DESC;

-- 11. Fetch each product line and add column showing GOOD or BAD.Good if its greater than average sales.

SELECT 
    product_line,
    SUM(total) AS total_sales,
    AVG(total) AS average_sales,
    (CASE
        WHEN SUM(total) > AVG(total) THEN 'Good'
        ELSE 'Bad'
    END) AS comments
FROM
    sales
GROUP BY product_line;

-- 12. Which branch sold more products than average product sold?

SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity) AS average_product_sold
    FROM
        sales);
        
-- 13. What is the most common product line by gender?

SELECT 
    gender, product_line, COUNT(gender) AS cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY cnt DESC;

-- 14. What is the average rating of each product line?--

SELECT 
    product_line, AVG(rating) AS average_rating
FROM
    sales
GROUP BY product_line
ORDER BY average_rating DESC;

-- Sales Analysis--------------------------------------------
-- 1.Number of sales made in each time of the day per weekday.

SELECT 
    COUNT(quantity) AS Num_of_sales_made, time_of_day, day_name
FROM
    sales
GROUP BY time_of_day , day_name
ORDER BY Num_of_sales_made;

-- 2. Which customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) AS Total_revenue
FROM
    sales
GROUP BY customer_type;




