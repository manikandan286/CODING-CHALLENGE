CREATE DATABASE ecommerce_db;
USE ecommerce_db;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100)
);
select * from customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT,
    stockQuantity INT
);

CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_price DECIMAL(10,2),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (name, email, password) VALUES
('John Doe', 'johndoe@example.com', 'password123'),
('Jane Smith', 'janesmith@example.com', 'securepass'),
('Robert Johnson', 'robert@example.com', 'robertpass'),
('Sarah Brown', 'sarah@example.com', 'sarahpass'),
('David Lee', 'david@example.com', 'davidpass'),
('Laura Hall', 'laura@example.com', 'laurapass'),
('Michael Davis', 'michael@example.com', 'michaelpass'),
('Emma Wilson', 'emma@example.com', 'emmapass'),
('William Taylor', 'william@example.com', 'williamspass'),
('Olivia Adams', 'olivia@example.com', 'oliviapass');

select * from customers;

INSERT INTO products (name, price, description, stockQuantity) VALUES
('Laptop', 800.00, 'High-performance laptop', 10),
('Smartphone', 600.00, 'Latest smartphone', 15),
('Tablet', 300.00, 'Portable tablet', 20),
('Headphones', 150.00, 'Noise-canceling', 30),
('TV', 900.00, '4K Smart TV', 5),
('Coffee Maker', 50.00, 'Automatic coffee maker', 25),
('Refrigerator', 700.00, 'Energy-efficient', 10),
('Microwave Oven', 80.00, 'Countertop microwave', 15),
('Blender', 70.00, 'High-speed blender', 20),
('Vacuum Cleaner', 120.00, 'Bagless vacuum cleaner', 10);

select * from products;

INSERT INTO orders (customer_id, order_date, total_price, shipping_address) VALUES
(1, '2023-01-05', 1200.00, '123 Main St, City'),
(2, '2023-02-10', 900.00, '456 Elm St, Town'),
(3, '2023-03-15', 300.00, '789 Oak St, Village'),
(4, '2023-04-20', 150.00, '101 Pine St, Suburb'),
(5, '2023-05-25', 1800.00, '234 Cedar St, District'),
(6, '2023-06-30', 400.00, '567 Birch St, County'),
(7, '2023-07-05', 700.00, '890 Maple St, State'),
(8, '2023-08-10', 160.00, '321 Redwood St, Country'),
(9, '2023-09-15', 140.00, '432 Spruce St, Province'),
(10, '2023-10-20', 1400.00, '765 Fir St, Territory');

select * from orders;

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(3, 5, 2),
(4, 4, 4),
(4, 6, 1),
(5, 1, 1),
(5, 2, 2),
(6, 10, 2),
(6, 9, 3);

select * from order_items;

INSERT INTO cart (customer_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(3, 4, 4),
(3, 5, 2),
(4, 6, 1),
(5, 1, 1),
(6, 10, 2),
(6, 9, 3),
(7, 7, 2);

select * from cart;

-- 1) Update refrigerator product price to 800. 
UPDATE products SET price = 800 WHERE name = 'Refrigerator';
SELECT * FROM products WHERE name = 'Refrigerator';

-- 2) Remove all cart items for a specific customer
DELETE FROM cart WHERE customer_id = customer_id;
SELECT * FROM cart WHERE customer_id = customer_id;

-- 3) Retrieve Products Priced Below $100
SELECT * FROM products WHERE price < 100;

-- 4) Find Products with Stock Quantity Greater Than 5
SELECT * FROM products WHERE stockQuantity > 5;

-- 5) Retrieve Orders with Total Amount Between $500 and $1000
SELECT * FROM orders WHERE total_price BETWEEN 500 AND 1000;

-- 6) Find Products which name end with letter ‘r’
SELECT * FROM products WHERE name LIKE '%r';

-- 7) Retrieve Cart Items for Customer 5
SELECT * FROM cart WHERE customer_id = 5;

-- 8) Find Customers Who Placed Orders in 2023
SELECT DISTINCT c.* FROM customers c  
JOIN orders o ON c.customer_id = o.customer_id  
WHERE YEAR(o.order_date) = 2023;
-- 9) Determine the Minimum Stock Quantity
SELECT MIN(stockQuantity) AS min_stock FROM products;

-- 10. Calculate the Total Amount Spent by Each Customer
SELECT customer_id, SUM(total_price) AS total_spent  
FROM orders GROUP BY customer_id;

-- 11. Find the Average Order Amount for Each Customer
SELECT customer_id, AVG(total_price) AS avg_order_amount  
FROM orders GROUP BY customer_id;

-- 12. Count the Number of Orders Placed by Each Customer
SELECT customer_id, COUNT(*) AS order_count  
FROM orders GROUP BY customer_id;

-- 13. Find the Maximum Order Amount for Each Customer
SELECT customer_id, MAX(total_price) AS max_order_amount  
FROM orders GROUP BY customer_id;

-- 14. Get Customers Who Placed Orders Totaling Over $1000
SELECT customer_id FROM orders  
GROUP BY customer_id HAVING SUM(total_price) > 1000;

-- 15. Find Products Not in the Cart
SELECT * FROM products  
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM cart);

-- 16. Find Customers Who Haven't Placed Orders
SELECT * FROM customers  
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- 17. Calculate the Percentage of Total Revenue for a Product
SELECT p.product_id, p.name,  
(SUM(oi.quantity * p.price) / (SELECT SUM(total_price) FROM orders)) * 100 AS revenue_percentage  
FROM order_items oi  
JOIN products p ON oi.product_id = p.product_id  
GROUP BY p.product_id, p.name;

-- 18. Find Products with Low Stock
SELECT * FROM products WHERE stockQuantity < 5;

-- 19. Find Customers Who Placed High-Value Orders
SELECT customer_id FROM orders WHERE total_price > 1000;



























