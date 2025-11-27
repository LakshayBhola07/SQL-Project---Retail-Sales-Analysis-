# 📊 Retail Sales Data Analysis using MySQL

A complete SQL-based project analyzing retail sales data through data cleaning, exploration, and business-focused analytical queries. This project uncovers trends in revenue, customer behavior, category performance, and operational efficiency.

---

## 📁 Project Overview
This project uses MySQL to analyze a retail sales dataset. It includes:
- Database & table creation  
- Data cleaning and validation  
- Exploratory Data Analysis (EDA)  
- Business problem-solving using SQL queries  
- Insights to support data-driven decision-making  

---

## 🗂 Dataset Structure
The dataset captures transaction-level sales data with the following fields:

| Column Name      | Description |
|------------------|-------------|
| transactions_id  | Unique transaction identifier |
| sale_date        | Date of sale |
| sale_time        | Time of sale |
| customer_id      | Customer identifier |
| gender           | Gender of customer |
| age              | Age of customer |
| category         | Product category |
| quantity         | Quantity purchased |
| price_per_unit   | Price of each item |
| cogs             | Cost of goods sold |
| total_sale       | Final sale amount |

---

## 🧹 Data Cleaning
Key data cleaning steps performed:
- Fixed incorrect column name (`quantiy` → `quantity`)
- Checked for NULL values across all fields  
- Verified data types for each column  
- Ensured logical consistency and record count validation  

```sql
ALTER TABLE retail_sales CHANGE quantiy quantity INT;
````

---

## 🔍 Exploratory Data Analysis (EDA)

### 1️⃣ Total Revenue

```sql
SELECT SUM(total_sale) 
FROM retail_sales;
```

### 2️⃣ Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;
```

### 3️⃣ Total Categories

```sql
SELECT COUNT(DISTINCT category)
FROM retail_sales;
```

---

## ❓ Business Problem Statements & SQL Solutions

### Q1. Sales on '2022-11-05'

```sql
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2. Clothing transactions (Qty ≥ 4) in Nov 2022

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022
  AND quantity >= 4;
```

### Q3. Total Sales by Category

```sql
SELECT category, SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY category;
```

### Q4. Average Age for Beauty Category

```sql
SELECT category, ROUND(AVG(age)) AS Average_Age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5. High-Value Transactions (>1000)

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

### Q6. Transactions by Gender & Category

```sql
SELECT category, gender, COUNT(transactions_id) AS Total_Transactions
FROM retail_sales
GROUP BY category, gender;
```

### Q7. Monthly Avg Sales + Best Month per Year

**Part 1**

```sql
SELECT MONTH(sale_date) AS Month,
       ROUND(AVG(total_sale),2) AS Avg_Sales
FROM retail_sales
GROUP BY Month;
```

**Part 2**

```sql
SELECT *
FROM (
    SELECT YEAR(sale_date) AS Year,
           MONTH(sale_date) AS Month,
           ROUND(AVG(total_sale),2) AS Avg_Sales,
           RANK() OVER(PARTITION BY YEAR(sale_date)
                       ORDER BY AVG(total_sale) DESC) AS Ranks
    FROM retail_sales
    GROUP BY Year, Month
) t
WHERE Ranks = 1;
```

### Q8. Top 5 Customers

```sql
SELECT customer_id, SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;
```

### Q9. Unique Customers per Category

```sql
SELECT category, COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY category;
```

### Q10. Shift-wise Transactions

**Part 1 — Assign Shifts**

```sql
SELECT *,
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift
FROM retail_sales;
```

**Part 2 — Total Orders per Shift**

```sql
WITH shift_wise_sales AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) <= 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Shift
    FROM retail_sales
)
SELECT Shift, COUNT(transactions_id) AS Total_Transactions
FROM shift_wise_sales
GROUP BY Shift;
```

---

# 📊 Business Insights Summary

* Seasonal sales patterns reveal clear revenue peaks during certain months.
* Top customers and strong-performing categories highlight key revenue contributors.
* Demographic insights (e.g., age trends for Beauty products) support targeted marketing.
* Shift-wise sales patterns help optimize workforce scheduling and operations.
* Category and gender-based purchasing trends help refine product and marketing strategies.

---

# 🚧 Challenges Faced

* Handling data quality issues, including missing values and incorrect formatting.
* Ensuring accurate yearly and monthly aggregations using SQL window functions.
* Managing outliers in high-value transactions to avoid skewed results.
* Structuring complex analytical queries while maintaining efficiency.

---

# 🚀 Future Scope

* Build interactive dashboards using Power BI or Tableau to visualize sales trends, categories, and customer insights.
* Expand the dataset by integrating additional tables (products, promotions, store information) for richer analysis.

```

---

If you want, I can also convert this into a **downloadable README.md file**, add **badges**, or design a **GitHub project banner** for your repository.
```

