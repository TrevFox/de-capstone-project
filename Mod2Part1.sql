CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM Orders WHERE Quantity > 2;

SELECT * FROM OrdersView;
        
SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderID, O.TotalCost, M.Cuisine as MenuName, M.Courses as Course, M.Starters as Starter
FROM customerdetails as C INNER JOIN orders as O ON C.CustomerID = O.CustomerID
INNER JOIN menu as M ON M.OrderID = O.OrderID
WHERE O.TotalCost > 150
ORDER BY O.TotalCost ASC;

SELECT Cuisine as MenuName FROM menu
WHERE OrderID = ANY (SELECT OrderID FROM orders WHERE Quantity > 2);
