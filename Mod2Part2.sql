CREATE PROCEDURE GetMaxQuantity()
SELECT max(Quantity) as 'Max-Quantity-in-Order' FROM Orders;

Call GetMaxQuantity();

PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM orders WHERE CustomerID = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;
drop procedure if exists CancelOrder;
Delimiter //
CREATE PROCEDURE CancelOrder(IN CancID INT)
BEGIN
Delete FROM orders WHERE OrderID = CancID;
SET @Confirmation = concat("Order", CancID, " is Cancelled");
SELECT @Confirmation as Confirmation;
END //

Delimiter ;

call CancelOrder(2);