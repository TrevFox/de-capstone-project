-- Create Orders View --
CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM Orders WHERE Quantity > 2;

SELECT * FROM OrdersView;

-- Join Query --
SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderID, O.TotalCost, M.Cuisine as MenuName, M.Courses as Course, M.Starters as Starter
FROM customerdetails as C INNER JOIN orders as O ON C.CustomerID = O.CustomerID
INNER JOIN menu as M ON M.OrderID = O.OrderID
WHERE O.TotalCost > 150
ORDER BY O.TotalCost ASC;

-- Subquery --
SELECT Cuisine as MenuName FROM menu
WHERE OrderID = ANY (SELECT OrderID FROM orders WHERE Quantity > 2);

-- Create GetMaxQuantity Procedure --
CREATE PROCEDURE GetMaxQuantity()
SELECT max(Quantity) as 'Max-Quantity-in-Order' FROM Orders;

Call GetMaxQuantity();

-- Create Prepared Statement --
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM orders WHERE CustomerID = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Create CancelOrder Procedure --
Delimiter //
CREATE PROCEDURE CancelOrder(IN CancID INT)
BEGIN
Delete FROM orders WHERE OrderID = CancID;
SET @Confirmation = concat("Order", CancID, " is Cancelled");
SELECT @Confirmation as Confirmation;
END //

Delimiter ;

call CancelOrder(2);
