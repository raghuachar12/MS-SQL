--ASSIGNMENT 7 

CREATE TABLE Salesman (
Sid INT PRIMARY KEY,
Sname VARCHAR(20),
Location VARCHAR(20))

CREATE TABLE PRODUCT(
Prodid INT PRIMARY KEY,
Pdesc VARCHAR(20),
Price INT,
Category VARCHAR(20),
DISCOUNT INT)

CREATE TABLE Sale (
Saleid INT PRIMARY KEY,
Sid INT FOREIGN KEY (Sid) REFERENCES Salesman (Sid),
Sale DATE,
Amount MONEY)

CREATE TABLE Saledetail (
Saleid INT FOREIGN KEY (Saleid) REFERENCES Sale (Saleid),
Prodid INT FOREIGN KEY (Prodid) REFERENCES PRODUCT (Prodid),
Quantity INT )

use SALESMAN
SELECT * FROM  Salesman

SELECT * FROM  PRODUCT

SELECT * FROM  Sale

SELECT * FROM  Saledetail

USE SALESMAN

--1--Display the sale id and date for most recent sale. 

SELECT Sid,Sldate 
FROM Sale WHERE Sldate = (SELECT MAX(Sldate) FROM Sale)

--2--Display the names of salesmen who have made at least 2 sales. 

SELECT Sname FROM Salesman WHERE Sid IN (SELECT Sid FROM Salesman GROUP BY Sid HAVING COUNT(*) >= 1)

--3--Display the product id and description of those products which are sold in minimum total quantity. 

SELECT P.Prodid, P.Pdesc
FROM Product P WHERE P.Prodid IN (SELECT Sd.Prodid
FROM Saledetail Sd
GROUP BY Sd.Prodid
HAVING SUM(Sd.Quantity) = (SELECT MIN(TotalQuantity)FROM (SELECT SUM(Sd2.Quantity) AS TotalQuantity
FROM Saledetail Sd2
GROUP BY Sd2.Prodid
) AS MinTotalQuantity))

---4---Display SId, SName and Location of those salesmen who have total sales amount 
--greater than average sales amount of all the sales made. 
--Amount can be calculated from Price and Discount of Product and Quantity sold.

SELECT * FROM  Salesman

SELECT * FROM  PRODUCT

SELECT * FROM  Sale

SELECT * FROM  Saledetail

SELECT S.Sid, S.Sname, S.Location
FROM Salesman S
WHERE S.Sid IN ( SELECT S1.Sid
                 FROM Salesman S1 JOIN Sale Sa 
				 ON S1.Sid = Sa.Sid
                 JOIN Saledetail Sd
                 ON Sa.Saleid = Sd.Saleid
                 JOIN Product P ON Sd.Prodid = P.Prodid
                 GROUP BY S1.Sid,S1.Location
                 HAVING SUM((P.Price - P.Discount) * Sd.Quantity) >

                                               ( SELECT AVG(TotalSales)

                                                 FROM (
                                                 SELECT S2.Location, SUM((P2.Price - P2.Discount) * Sd2.Quantity) AS TotalSales
                                                 
												 FROM Salesman S2
                                                 INNER JOIN Sale Sa2
												 ON S2.Sid = Sa2.Sid
                                                 INNER JOIN Saledetail Sd2
												 ON Sa2.Saleid = Sd2.Saleid
                                                 INNER JOIN Product P2 
												 ON Sd2.Prodid = P2.Prodid
                                                 GROUP BY S2.Location
                                                                     ) AS AvgSalesPerLocation
                                                 WHERE AvgSalesPerLocation.Location = S1.Location))



--5--Display the product id, category, description and price for those products whose 
--price is maximum in each category. 

SELECT P.Prodid,P.Pdesc,P.Category 
FROM PRODUCT P 
WHERE P.Price IN (SELECT MAX(P2.Price) FROM PRODUCT P2
WHERE P2.Category = P.Category)

--6--Display the names of salesmen who have not made any sales. 

SELECT Sname FROM SALESMAN  where sid not in (select sid from sale )

--7--Display the names of salesmen who have made at least 1 sale in the month of 
--Jun 2015. 

SELECT Sname
FROM Salesman sm 
WHERE sm.Sid IN (SELECT Sid FROM Sale
where DATEPART(MM,sldate)=01 
GROUP BY Sid
HAVING COUNT(*) >= 1) 

/*8.Display SId, SName and Location of those salesmen who have total sales 
amount greater than average total sales amount of their location calculated per 
salesman. Amount can be calculated from Price and Discount of Product and 
Quantity sold. */

SELECT S.SID,S.SNAME,S.LOCATION,SD.QUANTITY*(P.PRICE-(P.PRICE*P.DISCOUNT/100))
FROM Salesman S INNER  JOIN Sale SL	
ON S.SID=SL.SID  INNER JOIN Saledetail SD
ON	 SL.SALEID=SD.SALEID INNER JOIN PRODUCT P 
ON SD.PRODID=P.PRODID
WHERE SD.QUANTITY*(P.PRICE-(P.PRICE*P.DISCOUNT/100))>(SELECT AVG(SD1.QUANTITY*(P1.PRICE-(P1.PRICE*P1.DISCOUNT/100)))	 
FROM salesman S1 INNER JOIN Sale SL1 
ON	S1.SID=SL1.SID INNER JOIN Saledetail SD1 
ON SL1.SALEID=SD1.SALEID INNER JOIN PRODUCT P1
ON	SD1.PRODID=P1.PRODID
WHERE S.LOCATION=S1.LOCATION)

SELECT * FROM  Salesman

SELECT * FROM  PRODUCT

SELECT * FROM  Sale

SELECT * FROM  Saledetail


----------------------------------------------------------------------------------------------------------------------
--TCL STATEMENT -------------

CREATE TABLE tbltcldemo 
(
slno int  identity (1,1) )

INSERT INTO tbltcldemo DEFAULT VALUES 

SELECT * FROM tbltcldemo

BEGIN TRANSACTION T1 

INSERT INTO tbltcldemo DEFAULT VALUES 


ROLLBACK TRAN T1

SELECT * FROM tbltcldemo 

------------------------------------------------


