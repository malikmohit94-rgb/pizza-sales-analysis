-- Pizza_analysis_project

use pizza_analysis;

-- Total No. of Order Placed
select count(order_id) as total_orders from orders;

-- TOTAL REVENUE
select sum(od.quantity * p.price) as total_revenue 
from order_details as od
left join pizzas as p
on p.pizza_id  =  od.pizza_id;

-- HIGHEST PRICED PIZZA

SELECT pt.name as Pizza_Name, p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Most common pizza size ordered

SELECT 
    p.size,
    SUM(o.quantity) AS total_orders
FROM pizzas p
JOIN order_details o
    ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC;


-- TOP 5 MOST ORDERED PIZZAS

select  pt.name as PIZZA_NAME , sum(quantity) as Total_Orders from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by 1
order by Total_orders desc
Limit 5;

-- REVENUE BY CATEGORY

select sum(p.price*o.quantity) as Revenue , pt.category from order_details as o
join pizzas as p
on o.pizza_id =  p.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by category
order by Revenue desc
limit 3;

-- PERCENTAGE REVENUE CONTRIBUTION

select category , sum(p.price*o.quantity) as revenue , round(
                  sum(p.price*o.quantity) * 100 
                  / 
                  sum(sum(p.price*o.quantity)) over () , 2) as percentage
                  from order_details as o
                  join pizzas as p
                  on o.pizza_id = p.pizza_id
                  join pizza_types as pt
                  on pt.pizza_type_id = p.pizza_type_id
                  group by pt.category;


-- TOP 3 PIZZAS PER CATEGORY

select * from 
(select category , name ,sum(p.price * o.quantity) as revenue , 
rank () over ( partition by category order by sum(p.price * o.quantity) desc) as ranking from order_details as o 
join pizzas as p
on p.pizza_id = o.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by category , name) as temp
where ranking  <= 3;

-- Daily Revenue

SELECT 
    o.order_date,
    round (SUM(od.quantity * p.price) , 2 ) AS daily_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Monthly Revenue

with Monthly_Sales as (
select month(order_date) as Month_ , round(
sum(od.quantity * p.price) , 2)as Revenue from orders as o
join order_details as od
on o.order_id = od.order_id
join pizzas as p
on od.pizza_id = p.pizza_id
group by month(o.order_date) )

select * from monthly_sales
order by Month_;

-- Average Order Value

SELECT 
    ROUND(
        SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;









