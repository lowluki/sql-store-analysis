-- CUSTOMER ANALYSIS
-- TOP 5 BUYERS
SELECT orders.customer_id, customers.first_name, customers.last_name, SUM(orders.total_amount) AS sum_of_money
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY orders.customer_id
ORDER BY sum_of_money DESC
LIMIT 5;

-- REVENUE PER COUNTRY
SELECT customers.country AS country, SUM(orders.total_amount) AS revenue
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY country
ORDER BY revenue;

-- WHICH CUSTOMERS BUY THE MOST FROM A GIVEN PRODUCT CATEGORY
WITH customer_category_sales AS(
	SELECT categories.name, customers.first_name, customers.last_name, SUM(order_items.quantity) AS sum_of_products, 
	ROW_NUMBER() OVER(
	PARTITION BY categories.name
	ORDER BY SUM(order_items.quantity) DESC
	) AS rnk
FROM categories
JOIN products ON categories.category_id = products.category_id
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.status = 'delivered'
GROUP BY categories.name, customers.first_name, customers.last_name
)
SELECT *
FROM customer_category_sales
WHERE rnk = 1;
-- --------------------------------------------------------------------------------------------

-- PRODUCT ANALYSIS
-- TOP 5 BESTSELLERS PRODUCT
SELECT products.name, SUM(order_items.quantity) AS sum_of_products
FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.name
ORDER BY sum_of_products DESC
LIMIT 5;

-- PRODUCTS THAT WERE SOLD IN THE MOST QUANTITIES IN DESCENDING ORDER, LIMIT 20
SELECT products.name, SUM(order_items.quantity) AS sold_quantity
FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.name
ORDER BY sold_quantity DESC
LIMIT 20;

-- PRODUCTS GENERATED THE HIGHEST REVENUE
SELECT products.name, SUM(order_items.quantity * order_items.unit_price ) AS products_revenue
FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.name
ORDER BY products_revenue DESC
LIMIT 20;

-- SLOW MOVING PRODUCTS(<=5 SALES IN 2024)
SELECT products.name,  COUNT(order_items.product_id )
FROM products
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE YEAR(orders.order_date) = 2024
GROUP BY products.product_id, products.name
HAVING COUNT(order_items.product_id) <= 5;

-- CONTRIBUTION TO TOTAL PRODUCT REVENUE
WITH products_revenue AS(
	SELECT products.name, SUM(order_items.quantity * order_items.unit_price) AS product_revenue
    FROM products
    JOIN order_items ON products.product_id = order_items.product_id
    GROUP BY products.product_id, products.name
)
SELECT name, product_revenue, 
SUM(product_revenue) OVER() AS total_revenue, ROUND(product_revenue / SUM(product_revenue) OVER() * 100, 2) AS revenue_percent
FROM products_revenue
ORDER BY product_revenue DESC;
-- --------------------------------------------------------------------------------------------

-- CATEGORY ANALYSIS
-- TOP 5 CATEGORIES THAT MADE THE BIGGEST AMOUNT OF MONEY
SELECT categories.name, SUM(order_items.quantity * order_items.unit_price) AS revenue
FROM categories
JOIN products ON categories.category_id = products.category_id
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id 
GROUP BY categories.name
ORDER BY revenue DESC
LIMIT 5;
-- --------------------------------------------------------------------------------------------

-- TIME ANALYSIS
-- SALES PER WEEKDAY
SELECT DAYNAME(orders.order_date) AS weekday, SUM(orders.total_amount) AS sales
FROM orders
GROUP BY DAYNAME(orders.order_date)
ORDER BY FIELD(
weekday,
'Monday',
'Tuesday',
'Wednesday',
'Thursday',
'Friday',
'Saturday',
'Sunday'
);

-- MONTHLY REVENUE
SELECT DATE_FORMAT(order_date, '%Y-%m') AS year_and_month, SUM(total_amount) AS revenue
FROM orders
GROUP BY year_and_month
ORDER BY year_and_month;

-- YEAR OVER YEAR GROWTH
WITH yearly_revenue AS(
SELECT DATE_FORMAT(order_date, '%Y') AS year, SUM(total_amount) AS revenue
FROM orders
GROUP BY year
)
SELECT year, revenue,
LAG(revenue, 1, 0) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue, 1) OVER (ORDER BY year)) 
        / LAG(revenue, 1) OVER (ORDER BY year) * 100, 2) AS yoy_growth
FROM yearly_revenue;
-- --------------------------------------------------------------------------------------------

-- REVENUE METRICS
-- AVERAGE ORDER'S VALUE
SELECT ROUND(AVG(total_amount),2) AS avg_order_value
FROM orders;
-- --------------------------------------------------------------------------------------------


