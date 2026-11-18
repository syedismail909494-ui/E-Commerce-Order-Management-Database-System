USE inventory_db;

SELECT
    SUM(Total_Amount) AS Total_Sales,
    COUNT(Order_ID) AS Number_Of_Orders,
    AVG(Total_Amount) AS Average_Order_Value
FROM Orders;
SELECT
    MONTH(Order_Date) AS Sales_Month,
    YEAR(Order_Date) AS Sales_Year,
    SUM(Total_Amount) AS Monthly_Revenue
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Sales_Year, Sales_Month;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Purchases,
    COUNT(o.Order_ID) AS Number_Of_Orders,
    MAX(o.Order_Date) AS Last_Purchase_Date
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Purchases DESC;
SELECT
    i.item_id,
    i.item_name,
    SUM(od.Quantity) AS Quantity_Sold,
    SUM(od.Subtotal) AS Revenue_Generated,
    RANK() OVER (ORDER BY SUM(od.Subtotal) DESC) AS Product_Rank
FROM Inventory i
JOIN Order_Details od
ON i.item_id = od.Item_ID
GROUP BY i.item_id, i.item_name
ORDER BY Product_Rank;
SELECT
    i.item_name,
    SUM(od.Subtotal) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(od.Subtotal) DESC) AS Sales_Rank
FROM Inventory i
JOIN Order_Details od
ON i.item_id = od.Item_ID
GROUP BY i.item_name;
SELECT
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Purchase,
    DENSE_RANK() OVER (ORDER BY SUM(o.Total_Amount) DESC) AS Customer_Rank
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    Order_ID,
    Customer_ID,
    Order_Date,
    Total_Amount,
    ROW_NUMBER() OVER (ORDER BY Order_Date DESC) AS Order_Sequence
FROM Orders;
SELECT
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Purchase,
    COUNT(o.Order_ID) AS Total_Orders,
    CASE
        WHEN SUM(o.Total_Amount) >= 100000
             AND COUNT(o.Order_ID) >= 10
            THEN 'High Value'
        WHEN SUM(o.Total_Amount) >= 20000
            THEN 'Regular'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name;
SELECT
    c.Customer_ID,
    c.Age,
    COUNT(DISTINCT o.Order_ID) AS Total_Purchases,
    SUM(o.Total_Amount) AS Total_Spending,
    AVG(o.Total_Amount) AS Average_Order_Value,
    COUNT(DISTINCT o.Order_ID) AS Purchase_Frequency,
    MAX(od.Category_ID) AS Preferred_Category
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
JOIN Order_Details od
ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_ID, c.Age;
SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Total_Amount) AS Total_Spending,
    AVG(Total_Amount) AS Average_Purchase_Value,
    MAX(Order_Date) AS Last_Purchase_Date
FROM Orders
GROUP BY Customer_ID;
SELECT
    item_id,
    item_name,
    SUM(stock_quantity) AS Available_Stock,
    unit_price AS Product_Price
FROM Inventory
GROUP BY item_id, item_name, unit_price;
SELECT
    Order_ID,
    YEAR(Order_Date) AS Purchase_Year,
    MONTH(Order_Date) AS Purchase_Month,
    DAY(Order_Date) AS Purchase_Day,
    Customer_ID,
    Total_Amount
FROM Orders;