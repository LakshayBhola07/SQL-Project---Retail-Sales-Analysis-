CREATE DATABASE rsa_db;

-- Create Table

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
 );
 
 
 SELECT count(*)
 from retail_sales;

-- Data Cleaning

  
 select count(*) from retail_sales
 where sale_date is null
 or transactions_id is null
 or sale_time is null
 or customer_id is null
 or gender is null
 or age is null
 or category is null
 or quantity is null
 or price_per_unit is null
 or cogs is null
 or total_sale is null;
 
 
 
ALTER table retail_sales change quantiy quantity INT;


-- DATA EXPLORATION:

-- How much has the business generated as Total Revenue?

SELECT SUM(total_sale)
FROM retail_sales;


-- How many customers does the business have?

SELECT COUNT(DISTINCT customer_id ) AS Unique_Customers
FROM retail_sales;
 
 
-- No. of categories the business have?

SELECT COUNT(DISTINCT category) AS Category
FROM retail_sales; 


-- Exploratory Data Analysis (EDA)

-- Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales. 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).






-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'; 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022.

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	  and MONTH(sale_date) = 11 
      and YEAR(sale_date) = 2022 
      and quantity >=4;
      

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS Total_Sales
FROM retail_sales 
GROUP BY category; 


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category, ROUND(AVG(age)) AS Average_Age
FROM retail_sales
WHERE category = "Beauty"; 


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, COUNT(transactions_id) AS Total_Transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY category; 


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.


-- Part 1
 
SELECT MONTH(sale_date) AS 'Month', ROUND(AVG(total_sale),2) AS Avg_Sales
FROM retail_sales
GROUP BY MONTH(sale_date)
ORDER BY MONTH(sale_date);

-- Part 2 
 
SELECT * FROM
( 
SELECT YEAR(sale_date) AS 'Year',
       MONTH(sale_date) AS 'Month',
       ROUND(AVG(total_sale),2) AS Avg_Sales,
       RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS 'Ranks'
FROM retail_sales       
       GROUP BY YEAR(sale_date),MONTH(sale_date)
) AS t1
where Ranks = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales. 

SELECT customer_id, SUM(total_sale) AS Total_Sales 
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT(customer_id)) AS Unique_Customers
FROM retail_sales
GROUP BY category; 


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17). Also, Find the total number of orders placed in each shift.

-- Part 1
 
SELECT *,
    CASE
	   WHEN HOUR(sale_time) <=12 THEN 'Morning'
       WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
       ELSE 'Evening'
    END AS Shift
FROM retail_sales; 

-- Part 2


WITH shift_wise_sales
AS
(
SELECT *,
    CASE
	   WHEN HOUR(sale_time) <=12 THEN 'Morning'
       WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
       ELSE 'Evening'
    END AS Shift
FROM retail_sales
) 
SELECT Shift, COUNT(transactions_id) AS Total_Transactions
FROM shift_wise_sales
GROUP BY Shift;

-- END OF PROJECT   
 