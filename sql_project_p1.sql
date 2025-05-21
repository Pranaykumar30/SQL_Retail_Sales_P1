-- SQL Retail Sales Analysis - P1

-- Create Table
DROP TABLE IF EXISTS retail_sales;
create table retail_sales(
		transactions_id INT PRIMARY KEY,
		sale_date Date,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(20),
		quantiy INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
);

select * from retail_sales;
select * from retail_sales
limit 10;
select count(*) from retail_sales;


select * from retail_sales
where transactions_id is NULL;

select * from retail_sales
where sale_date is NULL;

select * from retail_sales
where sale_time is NULL;
--Data Cleaing

select * from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	customer_id is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or total_sale is null;


	---
delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	customer_id is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or 
	total_sale is null;

-- Data Exploration

-- HOw many sales we have?
select count(*) as total_sale from retail_sales;

--How many unique customers do we have?
select count(distinct customer_id) as total_customers from retail_sales;

--How many unique category we have?
select distinct category as unique_categories from retail_sales;


-- Data Analysis & BUsiness key problems and answers.


-- Q.1 Write a query to retrieve all columns for sales made on '2022-11-05'?

select *
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a query to retrieve all transactions whete the cateogry is 'Clothing' and the quantity is more than 4  in the month of Nov-2022?
select
	*
from retail_sales
where category = 'Clothing'
	and
	to_char(sale_date, 'yyyy-MM') = '2022-11'
	and
	quantiy >= 4

-- Q.3 Write a SQL query to calculate the retail sales for each category?
select
	category,
	sum(total_sale) as net_sales,
	count(*) as total_orders
from retail_sales
group by 1;

--Q.4 Write a SQL query to fid the avg age of the customers purchsed items from the 'Beauty' catoegory?
select
	round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty';


-- Q.5  Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000 

-- Q.6 Write a SQL query to find the total number of trnasactions (transaction_id) made by eacj gender in each category.

select
	category,
	gender,
	count(*) as total_transactions
from retail_sales
group
	by
	category,
	gender
order by 1;



-- Q.7 Write a SQL query to caalculate the avg sale for each month. Find out best selling month in each year.

select * from 
(
	select
		extract(year from sale_date) as year,
		extract(month from sale_date)as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group
		by
		1, 2
) as t1
where rank = 1
-- order by 1,3 desc



-- Q.8 Write a AQL query to find the top 5 customers based on the highest total_sales.

select
	customer_id,
	sum(total_sale) as total
from retail_sales
group by 1
order by 2 desc
limit 5


-- Q.9 Write the SQL query to find the number of unique customers who purchases items from each category.

select
	category,
	count(distinct customer_id)as unique_customers
from retail_sales
group by 1


-- Q.10 Write the SQL query to create each shift and number of orders
with hourly_sales
as
(
	select *,
		case
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
)
select
	shift,
	count(*)as total_orders
from hourly_sales
group by shift

-- End of Project