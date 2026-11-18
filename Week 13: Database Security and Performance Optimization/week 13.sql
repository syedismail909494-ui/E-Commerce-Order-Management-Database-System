USE inventory_db;

CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
IDENTIFIED BY 'Admin@123';

CREATE USER IF NOT EXISTS 'sales_user'@'localhost'
IDENTIFIED BY 'Sales@123';

CREATE USER IF NOT EXISTS 'inventory_user'@'localhost'
IDENTIFIED BY 'Inventory@123';

CREATE USER IF NOT EXISTS 'support_user'@'localhost'
IDENTIFIED BY 'Support@123';

SELECT User, Host
FROM mysql.user
WHERE User IN (
'admin_user',
'sales_user',
'inventory_user',
'support_user'
);
CREATE ROLE IF NOT EXISTS 'admin_role';

CREATE ROLE IF NOT EXISTS 'sales_role';

CREATE ROLE IF NOT EXISTS 'inventory_role';

CREATE ROLE IF NOT EXISTS 'support_role';

SELECT User, Host
FROM mysql.user
WHERE User IN (
'admin_role',
'sales_role',
'inventory_role',
'support_role'
);
-- Admin Role
GRANT ALL PRIVILEGES
ON inventory_db.*
TO 'admin_role';

-- Sales Role
GRANT SELECT
ON inventory_db.Orders
TO 'sales_role';

GRANT SELECT
ON inventory_db.Order_Details
TO 'sales_role';

-- Inventory Role
GRANT SELECT, UPDATE
ON inventory_db.Inventory
TO 'inventory_role';

-- Support Role
GRANT SELECT
ON inventory_db.Customers
TO 'support_role';

GRANT SELECT
ON inventory_db.Orders
TO 'support_role';
GRANT 'admin_role'
TO 'admin_user'@'localhost';

GRANT 'sales_role'
TO 'sales_user'@'localhost';

GRANT 'inventory_role'
TO 'inventory_user'@'localhost';

GRANT 'support_role'
TO 'support_user'@'localhost';

SET DEFAULT ROLE 'admin_role'
TO 'admin_user'@'localhost';

SET DEFAULT ROLE 'sales_role'
TO 'sales_user'@'localhost';

SET DEFAULT ROLE 'inventory_role'
TO 'inventory_user'@'localhost';

SET DEFAULT ROLE 'support_role'
TO 'support_user'@'localhost';
GRANT INSERT
ON inventory_db.Payment
TO 'sales_user'@'localhost';

REVOKE INSERT
ON inventory_db.Payment
FROM 'sales_user'@'localhost';

SHOW GRANTS FOR 'sales_user'@'localhost';
SHOW GRANTS FOR 'admin_user'@'localhost';

SHOW GRANTS FOR 'sales_user'@'localhost';

SHOW GRANTS FOR 'inventory_user'@'localhost';

SHOW GRANTS FOR 'support_user'@'localhost';
DESCRIBE Products;

DESCRIBE Customers;

DESCRIBE Orders;
CREATE INDEX idx_product_name
ON Products(Product_Name);

CREATE INDEX idx_category_id
ON Products(Category_ID);
CREATE INDEX idx_customer_email
ON Customers(Email);

CREATE INDEX idx_customer_phone
ON Customers(Phone_Number);
CREATE INDEX idx_order_date
ON Orders(Order_Date);

CREATE INDEX idx_order_customer
ON Orders(Customer_ID);
EXPLAIN
SELECT *
FROM Products
WHERE Product_Name = 'Laptop';
EXPLAIN
SELECT *
FROM Products
WHERE Category_ID = 1;
EXPLAIN
SELECT *
FROM Orders
WHERE Customer_ID = 1;
EXPLAIN
SELECT
Item_ID,
SUM(Quantity) AS Total_Quantity,
SUM(Subtotal) AS Total_Revenue
FROM Order_Details
GROUP BY Item_ID;
EXPLAIN
SELECT
i.Item_Name,
SUM(od.Quantity) AS Total_Sold
FROM Order_Details od
JOIN Inventory i
ON od.Item_ID = i.Item_ID
GROUP BY i.Item_ID, i.Item_Name
ORDER BY Total_Sold DESC;
SELECT
Item_ID,
SUM(Quantity) AS Total_Quantity,
SUM(Subtotal) AS Total_Revenue
FROM Order_Details
GROUP BY Item_ID;
SHOW GRANTS FOR 'admin_user'@'localhost';

SHOW GRANTS FOR 'sales_user'@'localhost';

SHOW GRANTS FOR 'inventory_user'@'localhost';

SHOW GRANTS FOR 'support_user'@'localhost';