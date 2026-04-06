CREATE DATABASE superstore_db;
use superstore_db;

create table sales (
Order_ID varchar(50),
Order_Date varchar(50),
Region Varchar(50),
Category Varchar(50),
Sales Varchar(255),
Quantity Varchar(255),
Discount Varchar(255),
Profit Varchar(255)
);
# update quantity, profit, discount datatype After Cleaning
UPDATE sales SET 
    Quantity = REGEXP_REPLACE(Quantity, '[^0-9]', ''),
    Profit = REGEXP_REPLACE(Profit, '[^0-9.-]', ''),
    Discount = REGEXP_REPLACE(Discount, '[^0-9.]', '');
ALTER TABLE sales 
MODIFY COLUMN Quantity INT,
MODIFY COLUMN Profit DECIMAL(15, 2),
MODIFY COLUMN Discount DECIMAL(15, 2);

# clean sales Column
UPDATE sales 
SET Sales = '0' 
WHERE Sales NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE sales SET Sales = TRIM(Sales);
UPDATE sales SET Sales = '0' WHERE Sales = '' OR Sales IS NULL;

# change data type
ALTER TABLE sales 
MODIFY COLUMN Sales DECIMAL(15, 2);

# Order date Update into date Datatype
UPDATE sales 
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y')
WHERE Order_Date LIKE '%-%-%';
ALTER TABLE sales 
MODIFY COLUMN Order_Date DATE;

select *
from sales;

# Total sales by region
select Region, sum(sales) as total_sales
from sales
group by Region;

# Top 5 profitable categories

select Category, sum(Profit) as total_profit
from sales
group by Category
order by total_profit desc
limit 5;

# Monthly sales

select month(Order_Date) as month, sum(sales) as total_sales
from sales
group by month
order by month;

# Discount impact on profit

select Discount, avg(Profit)
from sales
group by Discount;