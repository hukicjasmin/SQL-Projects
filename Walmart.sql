/* This is data analasys project in SQL (MySQL Workbench). 
I used dataset "walmart.csv" that is publicly available on Kaggle: 
https://www.kaggle.com/code/squidbob/walmart-analysis-eda */

/* Inspect data */
SELECT * FROM walmart;

SELECT COUNT(*) FROM walmart;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'walmart';

/* Change date types in date columns */

UPDATE walmart
SET `Order Date` = STR_TO_DATE(`Order Date`, '%d-%m-%Y');

ALTER TABLE walmart
MODIFY COLUMN `Order Date` DATE;

UPDATE walmart
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%d-%m-%Y');

ALTER TABLE walmart
MODIFY COLUMN `Ship Date` DATE;

/* Remove unnecessary column */

SELECT DISTINCT Country FROM walmart;

ALTER TABLE walmart
DROP COLUMN Country;

/* Perform EDA */

/* What are the cities and categories with the most orders? */

SET @total_count = (SELECT COUNT(*) FROM walmart);

SELECT 
    City,
    COUNT(`Order ID`) as CountOrders, 
    CONCAT(ROUND(COUNT(`Order ID`) * 100 / @total_count, 2), '%') AS Percentage
FROM walmart 
GROUP BY City  
ORDER BY CountOrders DESC;

SELECT 
    Category,
    COUNT(`Order ID`) as CountOrders, 
    CONCAT(ROUND(COUNT(`Order ID`) * 100 / @total_count, 2), '%') AS Percentage
FROM walmart 
GROUP BY Category  
ORDER BY CountOrders DESC;

/* What are the top 10 products and categories make the highest profit */

SET @total_profit = (SELECT SUM(Profit) FROM walmart);

SELECT 
     `Product Name` ,
     ROUND(SUM(Profit), 2) AS sum_profit,
     ROUND((SUM(Profit) / @total_profit * 100), 2) as percantage
FROM walmart
GROUP BY `Product Name`
ORDER BY sum_profit DESC
LIMIT 10;

SELECT 
     Category,
     ROUND(SUM(Profit), 2) AS sum_profit,
     ROUND((SUM(Profit) / @total_profit * 100), 2) as percantage
FROM walmart
GROUP BY Category
ORDER BY sum_profit DESC
LIMIT 10;

/* Which products are generating losses? */

SET @total_losses = (SELECT SUM(Profit) FROM walmart WHERE Profit < 0);

SELECT 
    `Product Name`,
    Category,
    ROUND(SUM(Profit), 2) AS losses,
    ROUND((SUM(Profit) / @total_losses * 100), 2) AS percentage
FROM walmart
GROUP BY `Product Name`, Category
HAVING SUM(Profit) < 0
ORDER BY losses

/* What are the months with the biggest sale */

ALTER TABLE walmart
ADD order_month DATE;

UPDATE walmart
SET order_month = DATE_FORMAT(`Order Date`, '%Y-%m-01');

SELECT 
    ROUND(SUM(Sales), 2) AS total_sales,
    MONTH(order_month)
FROM walmart
GROUP BY order_month
ORDER BY total_sales DESC;

