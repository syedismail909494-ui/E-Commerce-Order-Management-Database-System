                

/* =========================================================
   REPORT 1: CUSTOMER ORDER HISTORY
   ========================================================= */

SELECT
    c.Customer_Name,
    o.Order_ID,
    o.Order_Date,
    o.Total_Amount,
    o.Order_Status AS Status
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
ORDER BY o.Order_Date;


/* =========================================================
   REPORT 2: PRODUCT-WISE ORDER REPORT
   ========================================================= */

SELECT
    p.Product_Name,
    COUNT(od.Order_ID) AS Times_Ordered,
    SUM(od.Quantity) AS Total_Quantity_Sold
FROM Products p
JOIN Order_Details od
    ON p.Product_ID = od.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY Total_Quantity_Sold DESC;


/* =========================================================
   REPORT 3: CUSTOMER PURCHASE ANALYSIS
   ========================================================= */
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(o.Order_ID) AS Total_Orders,
        SUM(o.Total_Amount) AS Total_Spending,
        ROUND(AVG(o.Total_Amount), 2) AS Average_Order_Value
    FROM Customers c
    JOIN Orders o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name;