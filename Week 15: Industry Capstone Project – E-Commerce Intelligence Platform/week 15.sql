USE inventory_db;

SHOW TABLES;
DESCRIBE Customers;
DESCRIBE Orders;
DESCRIBE Order_Details;
DESCRIBE Inventory;
DESCRIBE Payment;
SELECT 'Customers' AS Table_Name, COUNT(*) AS Total_Records FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order Details', COUNT(*) FROM Order_Details
UNION ALL
SELECT 'Inventory', COUNT(*) FROM Inventory
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment;
SELECT * FROM Customers;

SELECT * FROM Orders;

SELECT * FROM Inventory;

SELECT * FROM Customers
ORDER BY Customer_Name ASC;

SELECT DISTINCT Order_Status
FROM Orders;

SELECT *
FROM Customers
WHERE Customer_Name LIKE 'A%';

SELECT *
FROM Orders
WHERE Total_Amount BETWEEN 100 AND 10000;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount,
    o.Order_Status
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Revenue,
    AVG(Total_Amount) AS Average_Order_Value
FROM Orders;
SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Monthly_Revenue
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Sales_Year, Sales_Month;SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    COALESCE(SUM(o.Total_Amount), 0) AS Total_Purchases,
    MAX(o.Order_Date) AS Last_Purchase_Date
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    i.item_id,
    i.item_name,
    SUM(od.Quantity) AS Quantity_Sold,
    SUM(od.Quantity * od.Unit_Price) AS Revenue
FROM Inventory i
JOIN Order_Details od
ON i.item_id = od.Item_ID
GROUP BY i.item_id, i.item_name
ORDER BY Revenue DESC;
SELECT
    item_id,
    item_name,
    Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS Product_Rank
FROM (
    SELECT
        i.item_id,
        i.item_name,
        SUM(od.Quantity * od.Unit_Price) AS Revenue
    FROM Inventory i
    JOIN Order_Details od
    ON i.item_id = od.Item_ID
    GROUP BY i.item_id, i.item_name
) AS Product_Sales;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Spending,
    DENSE_RANK() OVER (
        ORDER BY SUM(o.Total_Amount) DESC
    ) AS Customer_Rank
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    Order_ID,
    Customer_ID,
    Order_Date,
    ROW_NUMBER() OVER (
        ORDER BY Order_Date DESC
    ) AS Order_Sequence
FROM Orders;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    COALESCE(SUM(o.Total_Amount), 0) AS Total_Spending,
    CASE
        WHEN COALESCE(SUM(o.Total_Amount), 0) >= 50000
            THEN 'High Value'
        WHEN COALESCE(SUM(o.Total_Amount), 0) >= 10000
            THEN 'Regular'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    item_id,
    item_name,
    stock_quantity,
    reorder_level,
    CASE
        WHEN stock_quantity <= reorder_level THEN 'Low Stock'
        WHEN stock_quantity >= reorder_level * 5 THEN 'Overstocked'
        ELSE 'Normal Stock'
    END AS Stock_Status
FROM Inventory;
CREATE OR REPLACE VIEW Customer_Order_Report AS
SELECT
    c.Customer_ID,
    c.Customer_Name,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount,
    o.Order_Status
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID;
CREATE OR REPLACE VIEW Sales_Report AS
SELECT
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Revenue,
    AVG(Total_Amount) AS Average_Order_Value
FROM Orders;
CREATE OR REPLACE VIEW Inventory_Report AS
SELECT
    item_id,
    item_name,
    stock_quantity,
    reorder_level
FROM Inventory;
SELECT * FROM Customer_Order_Report;

SELECT * FROM Sales_Report;

SELECT * FROM Inventory_Report;
CREATE INDEX idx_customer_id
ON Customers(Customer_ID);

CREATE INDEX idx_order_date
ON Orders(Order_Date);

CREATE INDEX idx_order_customer
ON Orders(Customer_ID);

CREATE INDEX idx_inventory_name
ON Inventory(item_name);
EXPLAIN
SELECT *
FROM Orders
WHERE Customer_ID = 1;
EXPLAIN
SELECT *
FROM Inventory
WHERE item_name = 'Laptop';
DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN cid INT)
BEGIN
    SELECT *
    FROM Orders
    WHERE Customer_ID = cid;
END //

DELIMITER ;
CALL GetCustomerOrders(1);
DELIMITER //

CREATE FUNCTION GetCustomerSpending(cid INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);

    SELECT COALESCE(SUM(Total_Amount), 0)
    INTO total
    FROM Orders
    WHERE Customer_ID = cid;

    RETURN total;
END //

DELIMITER ;
SELECT GetCustomerSpending(1) AS Customer_Total_Spending;
SHOW FULL TABLES;

SHOW INDEX FROM Customers;

SHOW INDEX FROM Orders;

SHOW INDEX FROM Inventory;

SHOW PROCEDURE STATUS
WHERE Db = 'inventory_db';

SHOW FUNCTION STATUS
WHERE Db = 'inventory_db';
SHOW FULL TABLES;

SHOW INDEX FROM Customers;

SHOW INDEX FROM Orders;

SHOW INDEX FROM Inventory;

SHOW PROCEDURE STATUS
WHERE Db = 'inventory_db';

SHOW FUNCTION STATUS
WHERE Db = 'inventory_db';







