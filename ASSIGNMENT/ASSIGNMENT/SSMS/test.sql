CREATE TABLE tblCustomer (
    CustId INT PRIMARY KEY,
    CustName VARCHAR(255) NOT NULL
);

CREATE TABLE tblFlight (
    FlightId INT PRIMARY KEY,
    FlightName VARCHAR(255) NOT NULL,
    FlightType VARCHAR(50) CHECK (FlightType IN ('International', 'Domestic')) NOT NULL,
    Source VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    FlightCharge DECIMAL(10, 2) NOT NULL,
    TicketsAvailable INT NOT NULL,
Travelclass VARCHAR(255) NOT NULL);



CREATE TABLE tblBooking (
    BookingId INT PRIMARY KEY,
    FlightId INT,
    CustId INT,
Travelclass VARCHAR(255),
    NoOfSeats INT NOT NULL,
    BookingDate DATE NOT NULL,
Totalamt money,
    FOREIGN KEY (FlightId) REFERENCES tblFlight(FlightId),
    FOREIGN KEY (CustId) REFERENCES tblCustomer(CustId)
);

INSERT INTO tblCustomer (CustId, CustName) VALUES
(1, 'John')



INSERT INTO tblFlight (FlightId, FlightName, FlightType, Source, Destination, FlightCharge, TicketsAvailable,Travelclass) VALUES
(101, 'SPICE AIR', 'Domestic', 'MUMBAI', 'KOLKATA', 2000.00, 100,'BUSINESS')




INSERT INTO tblBooking (BookingId, FlightId, CustId,Travelclass, NoOfSeats, BookingDate,Totalamt,) VALUES
(1001, 101, 1,'BUSINESS',2,'2021-05-18',3000),


SELECT * FROM tblCustomer
SELECT * FROM tblFlight
SELECT * FROM tblBooking

 ALTER PROCEDURE usp_BookTheTicket(
    @CustId VARCHAR(5),
    @FlightId VARCHAR(5),
    @NoOfTickets INT,
    @TicketsAvailable int output)
    
AS
BEGIN
DECLARE @TravelClass VARCHAR(20)

    SET NOCOUNT ON;

    DECLARE @BookingId INT, @TicketCost DECIMAL(10, 2), @TotalAmt DECIMAL(10, 2);


    IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustId = @CustId)
	BEGIN
	print'invalid user '
        RETURN -1;
		END

        IF NOT EXISTS (SELECT 1 FROM tblFlight WHERE FlightId = @FlightId)
		BEGIN
		print'invalid flight id  '
        RETURN -2;
		END
   
    IF @NoOfTickets <= 0
	BEGIN
	print'ticket cannot be zero '
        RETURN -3;
		END
    IF @NoOfTickets > (SELECT TicketsAvailable FROM tblFlight WHERE FlightId = @FlightId)
	BEGIN
	print' no ticket avilable  '
        RETURN -4;
END
 
    SELECT @BookingId = ISNULL(MAX(BookingId), 0) + 1 FROM tblBooking;

  
    SELECT @TicketCost = FlightCharge FROM tblFlight WHERE FlightId = @FlightId;
    SET @TotalAmt = @TicketCost * @NoOfTickets;
	BEGIN  TRAN 
		BEGIN TRY
		SET @TravelClass=(SELECT TRAVELCLASS FROM tblFlight WHERE FlightId=@FlightId)
			INSERT INTO tblBooking (BookingId, FlightId, CustId, TravelClass, NoOfSeats, BookingDate, TotalAmt)
			VALUES (@BookingId, @FlightId, @CustId, @TravelClass, @NoOfTickets, GETDATE(), @TotalAmt);

			update tblFlight
			set ticketsavailable -= @NoOfTickets
			where flightid = @FlightId

			set @TicketsAvailable=(SELECT ticketsavailable FROM tblFlight WHERE FlightId=@FlightId)
	       COMMIT TRAN
		   print 'RECORD inserted '
		   RETURN 1;
			
			
		END TRY
    BEGIN CATCH
	  ROLLBACK
	  print'transation not complte'
        RETURN -99;
		 
    END CATCH
	
END

Declare @result int,@TicketsAvailable1 int
EXEC @result= usp_BookTheTicket 1,104,0,@TicketsAvailable=@TicketsAvailable1 output
	print @TicketsAvailable1
PRINT @result 


SELECT * FROM tblBooking

----------------------------------
-- Function: ufn_BookedDetails
alter FUNCTION UDF_GET_DETAILS
    (@BookingId INT)
RETURNS TABLE
AS
RETURN (
    SELECT
        b.BookingId,
        c.CustName,
        f.FlightName,
        f.Source,
        f.Destination,
        b.BookingDate,
        b.NoOfSeats AS NoOfTickets,
        b.TotalAmt
    FROM
        tblBooking b
        JOIN tblCustomer c ON b.CustId = c.CustId
        JOIN tblFlight f ON b.FlightId = f.FlightId
    WHERE
        b.BookingId = @BookingId
);
GO

select * from dbo.UDF_GET_DETAILS(1005)


