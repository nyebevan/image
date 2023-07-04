-- running total

select product_id, 
    count(*) over ( order by product_id ),
model, year, product_type,
    sum(base_msrp) over ( order by year )
from products;

select count(*) from products;

-- Exercise 16
-- Use window functions and write a query that will return customer information, and count the number of people through the date in the row have filled out their street address
select 
customer_id
, street_address
, date_added::date
, count(
CASE
    when street_address is not null then customer_id else null
END
)
over ( order by date_added::date)
from customers
order by date_added;

-- Calculate a rank for every salesperson with a rank of 1 going to the first hire, 2 to the second hire, and so on using RANK() function
SELECT *,
RANK() OVER (PARTITION BY dealership_id ORDER BY hire_date)
FROM salespeople
WHERE termination_date IS NULL;

-- Calculate total sales for a given day and the goal number

WITH daily_sales as (
SELECT sales_transaction_date::DATE,
SUM(sales_amount) as total_sales
FROM sales
GROUP BY 1
),

sales_stats_30 AS (
SELECT sales_transaction_date, total_sales,
MAX(total_sales) OVER (ORDER BY sales_transaction_date ROWS BETWEEN 30 PRECEDING and 1 PRECEDING) 
AS max_sales_30
FROM daily_sales
ORDER BY 1)

SELECT sales_transaction_date,
total_sales,
max_sales_30
FROM sales_stats_30
WHERE sales_transaction_date>='2019-01-01';

drop table demo_window;
-- create demo table
create table demo_window (
    id  int primary key,
    date    date,
    value1  float,
    value2  float
)

insert into demo_window
values 
( 1, '2022-09-01', 10, 2),
( 2, '2022-09-01', 20, 4),
( 3, '2022-09-01', 30, 6),
( 4, '2022-09-01', 40, 2),
( 5, '2022-09-01', 50, 2),
( 6, '2022-09-02', 60, 3),
( 7, '2022-09-02', 70, 3),
( 8, '2022-09-02', 80, 2),
( 9, '2022-09-03', 90, 5),
( 10, '2022-09-03', 100, 10);

select * from demo_window;
select id,
    value1,
    sum(value1) over ( order by id)
from demo_window

select id,
    date,
    value1,
    sum(value1) over ( partition by date order by id)
from demo_window

select id,
    value2,
    avg(value2) over ( order by id rows between 1 preceding and current row  ) 
from demo_window

select id,
    date,
    value2,
    avg(value2) over ( partition by date order by id rows between 1 preceding and current row  ) 
from demo_window

select id,
    date,
    value2,
    sum(value2) over ( partition by date order by id rows between 1 preceding and current row  ),
    count(value2) over ( partition by date order by id rows between 1 preceding and current row  ),
    avg(value2) over ( partition by date order by id rows between 1 preceding and current row  ) 
from demo_window

select id,
    date,
    value2,
    sum(value2) over w as sum,
    count(value2) over w as count,
    avg(value2) over w as avg 
from demo_window
window w as ( partition by date order by id rows between 1 preceding and current row  )

select id,
    date,
    value2,
    sum(value2) over w as sum,
    count(value2) over w as count,
    avg(value2) over w as avg 
from demo_window
window w as (  partition by date rows between unbounded preceding and current row  )

