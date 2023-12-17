 use toys 
 
CREATE TABLE tblCustomer (
    CustId VARCHAR(50) PRIMARY KEY,
    CustName VARCHAR(255) NOT NULL
);

-- Inserting sample data into tblCustomer
INSERT INTO tblCustomer (CustId, CustName) VALUES
('C301', 'John '),
('C302', 'Sam'),
('C303', 'Robert'),
('C304', 'Albert')

CREATE TABLE tblFlight (
    FlightId VARCHAR(50) PRIMARY KEY,
    FlightName VARCHAR(255) NOT NULL,
    FlightType VARCHAR(50) CHECK (FlightType IN ('International', 'Domestic')) NOT NULL,
    Source VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    FlightCharge DECIMAL(10, 2) NOT NULL,
    TicketsAvailable INT NOT NULL,
	Travelclass VARCHAR(20) CHECK (Travelclass IN ('Bussiness','Economy')) NOT NULL
);

-- Inserting sample data into tblFlight
INSERT INTO tblFlight (FlightId, FlightName, FlightType, Source, Destination, FlightCharge, TicketsAvailable,Travelclass) VALUES 
('F101', 'Spice jet', 'Domestic', 'Banglore', 'Mumbai', 1500.00, 100,'Bussiness'),
('F102', 'Indian Airlines', 'International', 'Delhi', 'Kolkota', 5000.00, 50,'Economy'),
('F103', 'Deccan Airlines', 'Domestic', 'Mysuru', 'Belagavi', 2000.00, 75,'Bussiness'),
('F104', 'British Airlines', 'International', 'Mysuru', 'Pune', 2500.00, 45,'Economy');

CREATE TABLE tblBooking (
    BookingId INT PRIMARY KEY,
    FlightId VARCHAR(50),
    CustId VARCHAR(50),
	Travelclass VARCHAR(20) CHECK (Travelclass IN ('Bussiness','Economy')) NOT NULL,
    NoOfSeats INT NOT NULL,
    BookingDate DATE NOT NULL,
	TotalAmt MONEY NOT NULL,
    FOREIGN KEY (FlightId) REFERENCES tblFlight(FlightId),
    FOREIGN KEY (CustId) REFERENCES tblCustomer(CustId)
);

-- Inserting sample data into tblBooking
INSERT INTO tblBooking (BookingId, FlightId, CustId,Travelclass, NoOfSeats, BookingDate,Totalamt) VALUES
(101, 'F101','C301','Bussiness',10,'22-march-18',3000),
(102, 'F102','C302','Bussiness',20,'17-may-18',5000),
(103, 'F103','C303','Economy',15,'23-oct-18',6000),
(104, 'F104','C304','Economy',25,'01-sep-18',15000)


select * from tblBooking
Select * from tblCustomer
select * from tblFlight

============================================================================================
/*1.Identify the customer(s) who have not booked any flight tickets or not booked any 
flights tickets of travel class ‘Economy’.Display custid and custname of the identified 
customer(s)*/

SeLECT Cust.CustId, Cust.CustName,bkng.travelclass
FROM tblCustomer Cust
LEFT JOIN tblBooking Bkng ON Cust.CustId = Bkng.CustId
WHERE Bkng.CustId IS NULL OR Bkng.TravelClass !='Economy';

/*2.Identify the booking(s) with flightcharge greater than the average flightcharge of all the 
flights booked for the same travel class. Display flightid, flightname and  custname of 
the identified bookings(s). */
SELECT flt.flightid,flt.flightname,cust.custname,flt.Flightcharge
FROM                                      
tblflight flt INNER JOIN tblbooking bkng
ON flt.flightid=bkng.flightid INNER JOIN tblcustomer cust
ON bkng.custid=cust.custid
WHERE flt.flightcharge>(SELECT AVG(flightcharge) FROM tblflight f WHERE f.TravelClass=flt.TravelClass)


/*3.Identify the bookings done by the same customer for the same flight type and travel 
class. Display flightid and the flighttype of the identified bookings. */

SELECT distinct Bkng.FlightId,  Flt.FlightType, Cust.CustName,Cust.custname,Bkng.bookingid
FROM tblBooking Bkng
INNER JOIN tblFlight Flt ON Bkng.FlightId = Flt.FlightId
INNER JOIN    tblCustomer Cust ON Bkng.CustId = Cust.CustId
INNER JOIN (SELECT CustId,FlightId,  COUNT(*) AS BookingCount 
FROM  tblBooking
GROUP BY   CustId, FlightId
HAVING   COUNT(*) > 1
) AS Dupilicate ON Bkng.CustId = Dupilicate.CustId AND Bkng.FlightId = Dupilicate.FlightId;


/*4.Identify the flight(s) for which the bookings are done to destination ‘Kolkata’, ‘Italy’ or 
‘Spain’. Display flightid and flightcharge of the identified booking(s) in the increasing 
order of flightname and decreasing order of flightcharge. */
select flightid,FlightName,flightcharge
from tblFlight
where Destination in('PUNE','Mumbai','Kolkota')
order by FlightName ASc,
flightcharge Desc;

Select * from tblFlight

/*5.Identify the month(s) in which the maximum number of bookings are made. Display 
custid and custname of the customers who have booked flights tickets in the identified 
month(s).*/

select * from tblBooking
Select * from tblFlight
select * from tblCustomer

/*6.Identify the booking(s) done in the year 2019 for the flights having the letter ‘u’ 
anywhere in their source or destination and booked by the customer having atleast 5 
characters in their name. Display bookingid prefixed with ‘B’ as “BOOKINGID” ( column 
alias) and the numeric part of custid as “CUSTOMERID” (column alias) for the identified 
booking(s). */



/*7 Identify the customers who have booked the seats of the travelclass 'Bussiness' for maximum number of times.
Display custid,custname of the identified customers*/
select bkng.CustId,cust.CustName,count(*) AS  Maximum_Number
from tblBooking bkng INNER JOIN tblCustomer cust
ON bkng.CustId=cust.CustId
where travelclass='Bussiness'
GROUP BY bkng.custid,cust.CustName
ORDER BY count(*)

/*8. Identify the bookings done with the same flightcharge. For every customer who has 
booked the identified bookings, display custname and bookingdate as “BDATE” (column 
alias). Display ‘NA’ in BDATE if the customer does not have any booking or if no such 
booking is done by the customer. */




/*9 .Identify the customer(s) who have paid highest flightcharge for the travel class 
economy. Write a SQL query to display id, flightname and name of the identified 
customers. */
SELECT c.custId,f.flightName, c.CustName
from tblCustomer c inner join tblBooking b ON c.CustId=b.CustId
inner join tblFlight f on f.FlightId=b.FlightId
where b.TravelClass='Economy' and f.FlightCharge= (
			SELECT MAX(FlightCharge) from tblFlight
			where TravelClass='Economy')
group by c.custId,f.flightName, c.CustName


/*14.Write a SQL query to display customer’s id and name of those customers who have paid 
the flight charge which is more than the average flightcharge for all international flights. */


select * from tblFlight

--Identify the International flight(s) which are booked for the maximum number of 
--times.Write a SQL query to display id and name of the identified flights. 


SELECT TOP 1 F.flightId, F.FlightName,COUNT(b.bookingId)
FROM tblFlight f
inner join tblBooking b ON f.FlightId= b.FlightId
WHERE f.FlightType = 'International'
GROUP BY f.FlightId, f.FlightName
ORDER BY COUNT(b.bookingId) desc


--11.Identify the customer(s) who have bookings during the months of October 2018 to 
--January 2019 and paid overall total flightcharge less than the average flightcharge of all 
--bookings belonging to travel class ‘Business’. Write a SQL query to display id and name 
--of the identified customers. 

SELECT  c.CustId, c.CustName
FROM tblCustomer c
INNER JOIN tblBooking b ON c.CustId = b.CustId
INNER JOIN tblFlight F ON b.FlightId=F.FlightId
WHERE (MONTH(b.BookingDate) BETWEEN 10 AND 12 AND YEAR (b.BookingDate)=2018) OR
		(MONTH(b.BookingDate) =1   and  YEAR (b.BookingDate)=2019)
		and b.TravelClass='Business'
GROUP BY c.CustId, c.CustName
HAVING SUM(F.FlightCharge) < (SELECT AVG(F.FlightCharge)FROM tblFlight)


--12.Identify the bookings with travel class ‘Business’ for the International flights.
--Write a SQL 
--query to display booking id, flight id and customer id of those customer(s) not having 
--letter ‘e’ anywhere in their name and have booked the identified flight(s). 


SELECT DISTINCT  b1.BookingId,F1.FlightId,C1.CustId
FROM tblBooking b1 INNER JOIN tblFlight F1 ON f1.FlightId= b1.FlightId
INNER JOIN tblCustomer C1 ON   c1.CustId = b1.CustId
WHERE B1.TravelClass='Business' AND    C1.CustName NOT LIKE '%E%'
GROUP BY C1.CustId,b1.BookingId,  F1.FlightId
