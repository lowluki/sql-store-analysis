SELECT is_active, COUNT(*) 
FROM customers 
GROUP BY is_active;
SELECT * FROM categories;
SET SQL_SAFE_UPDATES = 0;
TRUNCATE TABLE categories;
SET SQL_SAFE_UPDATES = 1;
TRUNCATE TABLE products;
TRUNCATE TABLE orders;
SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;
SELECT * FROM customers;
DELETE FROM categories
WHERE name = 'name';
ALTER TABLE categories AUTO_INCREMENT = 1;
INSERT INTO categories (name) VALUES
('Electronics'),
('Clothing'),
('Home_&_Kitchen'),
('Sports'),
('Books'),
('Beauty'),
('Toys'),
('Automotive'),
('Grocery'),
('Health'),
('Garden'),
('Jewelry'),
('Office'),
('Pet_supplies');
SELECT * FROM products;
SELECT COUNT(*) FROM order_items;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT order_id 
FROM payments 
WHERE order_id = 638;

SELECT MIN(order_id), MAX(order_id) FROM payments;
SELECT order_id 
FROM payments 
ORDER BY order_id;
INSERT INTO payments (order_id, payment_date, payment_method, status, amount)
VALUES (
  638,
  TIMESTAMP('2024-01-01') + INTERVAL FLOOR(RAND()*365) DAY,
  'card',
  'completed',
  100.00
);

SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 100;

SELECT name, COUNT(*)
FROM products
GROUP BY name
HAVING COUNT(*) > 1;