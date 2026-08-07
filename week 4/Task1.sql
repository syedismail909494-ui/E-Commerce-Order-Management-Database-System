
DROP DATABASE IF EXISTS inventory_db;

-- Create database
CREATE DATABASE inventory_db;
USE inventory_db;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_categories
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Gadgets, devices, and electronic accessories'),
('Home Appliances', 'Appliances for home, kitchen, and living rooms'),
('Books & Stationery', 'Books, notebooks, and office supplies'),
('Apparel', 'Clothing, footwear, and accessories');

INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Wireless Bluetooth Headphones', 1, 59.99, 120),
('4K Ultra HD Smart TV', 1, 499.00, 30),
('Gaming Laptop 16GB RAM', 1, 1199.50, 15),
('Microwave Oven 20L', 2, 85.00, 45),
('Ergonomic Office Chair', 2, 150.00, 20),
('SQL Database Design Guide', 3, 29.99, 200),
('Ballpoint Pens (Pack of 10)', 3, 4.50, 500),
('Cotton Graphic T-Shirt', 4, 19.99, 150);

-- DISPLAY DATA--

SELECT * FROM categories;
SELECT * FROM products;
-- UPDATE--

UPDATE products
SET price = 54.99,
    stock_quantity = 140
WHERE product_id = 1;

UPDATE products
SET price = price * 1.10
WHERE category_id = 1;

SELECT * FROM products;

-- DELETE--

DELETE FROM products
WHERE product_id = 8;

DELETE FROM categories
WHERE category_id = 4;

SELECT * FROM categories;
SELECT * FROM products;
-- REPORT 1
-- COMPLETE PRODUCT CATALOG--

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,
    (p.price * p.stock_quantity) AS total_inventory_value
FROM products p
INNER JOIN categories c
ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- REPORT 2
-- CATEGORY SUMMARY--

SELECT
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS total_products,
    ROUND(AVG(p.price),2) AS average_price,
    SUM(p.stock_quantity) AS total_stock_count,
    SUM(p.price * p.stock_quantity) AS total_category_value
FROM categories c
LEFT JOIN products p
ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_category_value DESC;

-- REPORT 3
-- LOW STOCK REPORT--

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity
FROM products p
INNER JOIN categories c
ON p.category_id = c.category_id
WHERE p.stock_quantity < 25
ORDER BY p.stock_quantity ASC;

-- SHOW TABLES--

SHOW TABLES;

DESCRIBE categories;
DESCRIBE products;