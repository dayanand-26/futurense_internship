#Task 1: List out all the orders with customers.
SELECT * FROM Customers cs
INNER JOIN Orders od ON cs.CustomerID = od.CustomerID


#Task 2: List out all the orders with customers and employees.
SELECT * FROM (Customers cs
INNER JOIN Orders od ON cs.CustomerID = od.CustomerID)
INNER JOIN Employees emp ON od.EmployeeID = emp.EmployeeID


#Task 3: List out all the products with their categories.
SELECT * FROM Products prod
INNER JOIN Categories cat ON prod.CategoryID = cat.CategoryID;


#Task 4: List out all the orders with shipping details.
SELECT * FROM (Orders od
INNER JOIN Shippers ship ON od.ShipperID = ship.ShipperID)
INNER JOIN Customers cs ON od.CustomerID = cs.CustomerID;


#Task 5: List out all the employees who have not placed any orders.
SELECT * FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
WHERE Orders.EmployeeID IS NULL;


#Task 6: List out top 5 products by order quantity.
SELECT TOP 5 prod.ProductID, IIF(SUM(od.Quantity) = NULL, 0,
SUM(od.Quantity)) AS Orders FROM (OrderDetails od
INNER JOIN Products prod ON od.ProductID = prod.ProductID)
GROUP BY prod.ProductID
ORDER BY IIF(SUM(od.Quantity) = NULL, 0, SUM(od.Quantity)) DESC;


#Task 7: List out customers and their orders in 2023 only.
SELECT * FROM Customers cs
INNER JOIN Orders od ON cs.CustomerID = od.CustomerID
WHERE od.OrderDate BETWEEN 1/1/2023 AND 12/31/2023;


#Task 8: List out all the suppliers with their products.
SELECT * FROM Suppliers sup
INNER JOIN Products prod ON sup.SupplierID = prod.SupplierID;


#Task 9: List out all the orders with their detailed product information.
SELECT * FROM ((OrderDetails odd
INNER JOIN Orders od ON odd.OrderID = od.OrderID)
INNER JOIN Products pd ON odd.ProductID = pd.ProductID)
INNER JOIN Categories cat ON pd.CategoryID = cat.CategoryID;