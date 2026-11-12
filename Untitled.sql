# Top 10 Product In Terms Of Revenue
USE northwind;
SELECT t.ProductID,k.ProductName,t.Revenue FROM
(SELECT t3.ProductID,SUM(ROUND((t2.UnitPrice * t2.Quantity * (1-t2.Discount)))) AS 'Revenue'  FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
INNER JOIN nw_products t3
ON t3.ProductID = t2.ProductID
GROUP BY ProductID)t
INNER JOIN nw_products k
ON k.ProductID = t.ProductID
ORDER BY Revenue DESC LIMIT 10;

# Total items Sold From Each Category
USE northwind;
SELECT t2.CategoryID,SUM(t1.Quantity) AS 'Sold_units' FROM nw_order_details t1
INNER JOIN nw_products t2
ON t1.ProductID = t2.ProductID
GROUP BY CategoryID
ORDER BY Sold_units DESC;

# Percentage Revenue Contribution BY Each Product
USE northwind;
SELECT *,(Revenue * 100 / (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM nw_order_details)) AS 'Percentage_revenue' FROM (SELECT t.ProductID,k.ProductName,t.Revenue FROM(SELECT ProductID,ROUND(SUM((UnitPrice * Quantity * (1 - Discount))),2) AS 'Revenue' FROM nw_order_details 
GROUP BY ProductID)t
INNER JOIN nw_products k
ON k.ProductID = t.ProductID)w
ORDER BY Percentage_revenue DESC LIMIT 10;

# Monthly Growth
Use northwind;
SELECT *,((Revenue - Prev)*100 / Prev) AS 'Percentage_Growth' FROM (SELECT *,LAG(Revenue) OVER(ORDER BY Year ASC , Month ASC ) AS 'Prev' FROM(SELECT MONTH(OrderDate) AS 'Month',Year(OrderDate) AS 'Year', ROUND(SUM((UnitPrice*Quantity*(1-Discount))),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY Month,Year
ORDER BY Year ASC , Month ASC)t)k;

#Top 10 Customers
USE northwind;
SELECT t1.CustomerID,ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY CustomerID
ORDER BY Revenue DESC LIMIT 10;


#Repeat Customers
USE northwind;
SELECT CustomerID,COUNT(CustomerID) AS 'total_orders' FROM nw_orders
GROUP BY CustomerID
HAVING total_orders > 1
ORDER BY total_orders DESC;

#Country Wise Revenue
USE northwind;
SELECT ShipCountry,ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY ShipCountry
ORDER BY Revenue DESC;

#Supplier Wise Revenue 
USE northwind;
SELECT t1.SupplierID,ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_products t1
INNER JOIN nw_order_details t2
ON t1.ProductID = t2.ProductID
GROUP BY t1.SupplierID
ORDER BY Revenue DESC LIMIT 10;

# Average Order Value
USE northwind;
SELECT ROUND(AVG(Revenue),2) AS 'AOV' FROM(SELECT t1.OrderID, ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY t1.OrderID)k;

# Employees Performance
USE northwind;
SELECT t.EmployeeID,k.FirstName,k.LastName,t.Revenue FROM (SELECT t3.EmployeeID,ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
INNER JOIN nw_employees t3
ON t1.EmployeeID = t3.EmployeeID
GROUP BY EmployeeID)t
INNER JOIN nw_employees k
ON t.EmployeeID = k.EmployeeID
ORDER BY Revenue DESC;

# Unique Customers From Different Country
USE northwind;
SELECT ShipCountry,COUNT(DISTINCT(CustomerID)) AS 'total_order' FROM nw_orders 
GROUP BY ShipCountry
ORDER BY total_order DESC; #Austria Revenue main 3 h ppar uske customer 2 yani austria main moti party h yah demand bhaut jada h toh kuch toh karna chiaye ki aur austria ki companies ko reach kar skate 

# Average Ship Time Country Wise
USE northwind;
SELECT ShipCountry, AVG(DATEDIFF(ShippedDate, OrderDate)) AS avg_day_diff FROM nw_orders
GROUP BY ShipCountry;

# Employee performance
USE northwind;
SELECT t.EmployeeID,t4.FirstName,t4.LastName,t.Revenue FROM(SELECT t1.EmployeeID,ROUND(SUM(t2.UnitPrice * t2.Quantity * (1-t2.Discount)),2) AS 'Revenue' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
INNER JOIN nw_employees t3
ON t1.EmployeeID = t3.EmployeeID
GROUP BY EmployeeID)t
INNER JOIN nw_employees t4
ON t4.EmployeeID = t.EmployeeID
ORDER BY Revenue DESC;

# Unique Customers
USE northwind;
SELECT COUNT(DISTINCT(CustomerID)) AS 'Unique_Customers' FROM nw_orders;

# Month Over Month Product Order Grwoth
USE northwind;
SELECT *,((total_item_sold - Prev)*100/Prev ) AS 'Percentage_Growth' FROM (SELECT *,LAG(total_item_sold) OVER(PARTITION BY ProductID ORDER BY Year ASC,Month ASC) AS 'Prev' FROM (SELECT t2.ProductID,MONTH(OrderDate) AS 'Month',YEAR(OrderDate) AS 'Year',SUM(t2.Quantity) AS 'total_item_sold' FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY ProductID,Year,Month
ORDER BY ProductID,Year ASC,Month ASC)t)k
