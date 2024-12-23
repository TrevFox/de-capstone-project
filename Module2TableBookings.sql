-- Populate Bookings Table --
USE littlelemondb;
INSERT INTO bookings (BookingID, Date, TableNo, EmployeeID, CustomerID)
	VALUES (1, '2022-10-10', 5, 1, 1),
			(2, '2022-11-12', 3, 1, 3),
            (3, '2022-10-11', 2, 2, 2),
            (4, '2022-10-13', 2, 2, 1);

-- Create CheckBooking Procedure --
drop procedure if exists CheckBooking;
Delimiter //
CREATE PROCEDURE CheckBooking(IN DateCheck Date, IN TableCheck VARCHAR(45))
BEGIN
SELECT case when (SELECT count(*) as booked FROM bookings WHERE Date = DateCheck and TableNo = TableCheck) > 0
		then concat('Table ', TableCheck, ' is already booked') 
        else concat('Table ', TableCheck, ' is available') end as Booking_Status FROM bookings GROUP BY Booking_Status;
END //
Delimiter ;

call CheckBooking('2022-11-12', 3);

-- Create AddValidBooking Procedure --
drop procedure if exists AddValidBooking;
Delimiter //
CREATE PROCEDURE AddValidBooking(IN NewRes Date, IN NewTable VARCHAR(45))
BEGIN
START TRANSACTION;
INSERT INTO bookings(Date, TableNo) VALUES (NewRes, NewTable);
SET @check:= (SELECT count(*) as booked FROM bookings WHERE Date = NewRes and TableNo = NewTable);
IF @check > 1
THEN ROLLBACK;
SELECT concat('Table ', NewTable, ' is already booked - booking cancelled') as Booking_Status;
ELSE COMMIT;
SELECT concat('Table ', NewTable, ' is now booked') as Booking_Status;
END IF;
END //
Delimiter ;

call AddValidBooking('2022-11-12', 3);

-- Create AddBooking Procedure --
drop procedure if exists AddBooking;
Delimiter //
CREATE PROCEDURE AddBooking(IN BID INT, IN CID INT, IN BDate Date, 
								IN TableNum VARCHAR(45), IN EmpID INT)
BEGIN
INSERT INTO bookings(BookingID, Date, TableNo, EmployeeID, CustomerID) 
	VALUES (BID, BDate, TableNum, EmpID, CID);
SELECT 'New Booking Added' as CONFIRMATION;
END //
Delimiter ;

call AddBooking(9, 3, '2022-12-30', 4, 2);

-- Create UpdateBooking Procedure --
drop procedure if exists UpdateBooking;
Delimiter //
CREATE PROCEDURE UpdateBooking(IN BID INT, IN BDate Date)
BEGIN
UPDATE bookings SET Date = BDate WHERE BookingID = BID;
SELECT concat('Booking ', BID, ' updated') as CONFIRMATION;
END //
Delimiter ;

call UpdateBooking(9, '2022-12-17');

-- Create CancelBooking Procedure --
drop procedure if exists CancelBooking;
Delimiter //
CREATE PROCEDURE CancelBooking(IN BID INT)
BEGIN
DELETE FROM bookings WHERE BookingID = BID;
SELECT concat('Booking ', BID, ' cancelled') as CONFIRMATION;
END //
Delimiter ;

call CancelBooking(9);
