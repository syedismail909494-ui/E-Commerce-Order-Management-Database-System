USE inventory_db;

SHOW TABLES;
USE inventory_db;

START TRANSACTION;

-- Step 1: Create a new order
INSERT INTO Orders
(Customer_ID, Order_Date, Total_Amount, Order_Status)
VALUES
(1, NOW(), 52000, 'Pending');

SET @new_order_id = LAST_INSERT_ID();

-- Step 2: Insert ordered product
INSERT INTO Order_Details
(Order_ID, Item_ID, Quantity, Unit_Price, Subtotal)
VALUES
(@new_order_id, 1, 1, 52000, 52000);

-- Step 3: Reduce inventory stock
UPDATE Inventory
SET Stock_Quantity = Stock_Quantity - 1
WHERE Item_ID = 1
AND Stock_Quantity >= 1;

-- Step 4: Insert payment details
INSERT INTO Payment
(Order_ID, Payment_Mode, Payment_Status, Amount)
VALUES
(@new_order_id, 'UPI', 'Successful', 52000);

-- Step 5: Update order status
UPDATE Orders
SET Order_Status = 'Completed'
WHERE Order_ID = @new_order_id;

-- Step 6: Save all changes
COMMIT;

-- Display result
SELECT * FROM Orders
WHERE Order_ID = @new_order_id;

SELECT * FROM Order_Details
WHERE Order_ID = @new_order_id;

SELECT * FROM Payment
WHERE Order_ID = @new_order_id;

SELECT * FROM Inventory
WHERE Item_ID = 1;

START TRANSACTION;

-- Step 1: Create order
INSERT INTO Orders
(Customer_ID, Order_Date, Total_Amount, Order_Status)
VALUES
(1, NOW(), 52000, 'Pending');

SET @failed_order_id = LAST_INSERT_ID();

-- Step 2: Insert ordered product
INSERT INTO Order_Details
(Order_ID, Item_ID, Quantity, Unit_Price, Subtotal)
VALUES
(@failed_order_id, 1, 1, 52000, 52000);

-- Step 3: Reduce stock temporarily
UPDATE Inventory
SET Stock_Quantity = Stock_Quantity - 1
WHERE Item_ID = 1;

-- Step 4: Simulate payment failure
INSERT INTO Payment
(Order_ID, Payment_Mode, Payment_Status, Amount)
VALUES
(@failed_order_id, 'UPI', 'Failed', 52000);

-- Step 5: Cancel all transaction changes
ROLLBACK;

-- Verify rollback
SELECT * FROM Orders
WHERE Order_ID = @failed_order_id;

SELECT * FROM Payment
WHERE Order_ID = @failed_order_id;

SELECT * FROM Inventory
WHERE Item_ID = 1;
START TRANSACTION;

UPDATE Inventory
SET Stock_Quantity = Stock_Quantity - 1
WHERE Item_ID = 1;

ROLLBACK;

SELECT * FROM Inventory
WHERE Item_ID = 1;
SELECT *
FROM Inventory
WHERE Stock_Quantity < 0;
START TRANSACTION;

SELECT *
FROM Inventory
WHERE Item_ID = 1
FOR UPDATE;

SELECT *
FROM Orders
WHERE Order_Status = 'Completed';
COMMIT;
SELECT o.*
FROM Orders o
LEFT JOIN Customers c
ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;
SELECT p.*
FROM Payment p
LEFT JOIN Orders o
ON p.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;
SELECT *
FROM Inventory
WHERE Stock_Quantity < 0;
SELECT o.Order_ID, o.Order_Status,
       p.Payment_Status
FROM Orders o
JOIN Payment p
ON o.Order_ID = p.Order_ID
WHERE o.Order_Status = 'Completed'
AND LOWER(p.Payment_Status) <> 'successful';
SELECT *
FROM Orders
WHERE Order_Status = 'Cancelled';
SELECT
    o.Order_ID,
    c.Customer_Name,
    o.Total_Amount,
    p.Payment_Status,
    o.Order_Status
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
LEFT JOIN Payment p
ON o.Order_ID = p.Order_ID;
SELECT
    o.Order_ID,
    c.Customer_Name,
    o.Total_Amount,
    p.Payment_Mode,
    p.Payment_Status,
    o.Order_Status
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
JOIN Payment p
ON o.Order_ID = p.Order_ID
WHERE LOWER(p.Payment_Status) = 'failed'
OR LOWER(o.Order_Status) = 'cancelled';
SELECT
    Item_ID,
    Item_Name,
    Stock_Quantity,
    Reorder_Level,
    CASE
        WHEN Stock_Quantity <= Reorder_Level
        THEN 'Low Stock'
        ELSE 'Available'
    END AS Stock_Status
FROM Inventory;