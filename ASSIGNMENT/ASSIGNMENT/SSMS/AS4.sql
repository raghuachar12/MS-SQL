

-------------------------------------------------
--ASSIGNMENT 4

CREATE TABLE CUSTOMER (
CUST_ID INT PRIMARY KEY,
CUST_NAME VARCHAR(10),
CUST_TYPE CHAR(1))

CREATE TABLE CATEGORY(
C_ID INT PRIMARY KEY,
C_NAME VARCHAR(10))

CREATE TABLE TOY (
TOY_ID CHAR(5) PRIMARY KEY,
TOY_NAME VARCHAR(50) NOT NULL,
C_ID INT FOREIGN KEY (C_ID) referenceS CATEGORY (C_ID),
PRICE INT CHECK(PRICE >= 1000),
STOCK INT NOT NULL)

CREATE TABLE TRANSACTIONS(
TXN_ID INT PRIMARY KEY,
CUST_ID INT FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER (CUST_ID),
TOY_ID CHAR(5) FOREIGN KEY (TOY_ID) REFERENCES TOY (TOY_ID),
QUANTITY INT ,
TXN_COST INT )

---------------------
USE toys

SELECT * FROM CUSTOMER

SELECT * FROM CATEGORY

SELECT * FROM TOY

SELECT * FROM TRANSACTIONS
------------------------------

--1---
--Display CustName and total transaction cost as TotalPurchase for those customers 
--whose total transaction cost is greater than 1000. 

SELECT CUST_NAME ,SUM(TRANSACTIONS.TXN_COST) TOTAL_TRANS
FROM CUSTOMER RIGHT JOIN TRANSACTIONS 
ON CUSTOMER.CUST_ID = TRANSACTIONS.CUST_ID
WHERE TRANSACTIONS.TXN_COST>1000
GROUP BY CUSTOMER.CUST_NAME 


--2--
--List all the toyid, total quantity purchased as 'total quantity' irrespective of the 
--customer. Toys that have not been sold should also appear in the result with total units as 0 

SELECT TOY.TOY_ID,SUM(TRANSACTIONS.QUANTITY) AS QUANTITY_SOLD
FROM TOY LEFT JOIN TRANSACTIONS 
ON TOY.TOY_ID = TRANSACTIONS.TOY_ID 
GROUP BY TOY.TOY_ID

--3.The CEO of Toys corner wants to know which toy has the highest total Quantity sold. 
--Display CName, ToyName, total Quantity sold of this toy. */

SELECT CATEGORY.C_ID,count(*)
from TOY join Transactions
on TOY.TOY_ID=Transactions.TOY_ID
join CATEGORY on CATEGORY.C_ID=TOY.TOY_ID
GROUP BY CATEGORY.C_ID



-------------------------------------------------------------
-- T SQL
DECLARE @CUST_ID int = 104 ,@TOY_ID int =1001,@Quantity int = 40 , @LSTOCK INT ,@CUST VARCHAR(10)
DECLARE @TXN_ID INT =1030 ,@PRICE INT = 300 ,@TXN_COST INT
SELECT @LSTOCK = STOCK
FROM TOY 
WHERE TOY_ID = @TOY_ID

PRINT (@LSTOCK)


UPDATE TRANSACTIONS 
SET @LSTOCK=@LSTOCK-Quantity
WHERE @TOY_ID = 1003
SET @TXN_COST = @PRICE*@Quantity

INSERT INTO TRANSACTIONS VALUES(@TXN_ID,@CUST_ID,@TOY_ID,@Quantity,@TXN_COST)

SELECT * FROM TRANSACTIONS
------------------------------------------------------
--------------------------------------------

 BEGIN TRY
	DECLARE @cid int = 101,
	@lstock int = 0,
	@tid INT = 1003,
	@Quantity int = 40,
	@cust VARCHAR(4) = NULL,
	@txnid int =1006
	
	if(@lstock < @Quantity)
	BEGIN
	INSERT INTO TRANSACTIONS VALUES (@txnid,@cid,@tid,@Quantity,1200)
	UPDATE TOY
	SET STOCK = STOCK - @Quantity
	WHERE TOY_ID = @tid
	
	END
	ELSE
	print'Q SHOULD NOT BE 0 '
END TRY

BEGIN CATCH
	PRINT 'Duplicate vales TXN ID' 

END CATCH


SELECT * FROM TRANSACTIONS


------SP---------

--4.Consider Toy Centre database 
--Procedure Name : usp_UpdatePrice 
--Description:    This procedure is used to update the price of a given product. 
 
--Input Parameters: 
--∙ProductId 
--∙Price 
--Output Parameter 
--    UpdatedPrice 
--Functionality: 
--∙Check if the product id is valid, i.e., it exists in the Products table 
--∙If all the validations are successful, update the price in the table Products appropriately 
--∙Set the output parameter to the updated price 
--∙If the update is not successful or in case of exception, undo the entire operation and set the 
--output parameter to 0 
--Return Values: 
--∙1 in case of successful update 
--∙-1 in case of any errors or exception 


ALTER PROC usp_Toycenter(@productId VARCHAR(10),@price INT,
@updatedprice INT OUTPUT)
AS
BEGIN
BEGIN TRANSACTION
	IF(@productId IN (SELECT TOY_ID FROM TOY))
	BEGIN
		UPDATE TOY
		SET Price = @price
		WHERE TOY_ID = @productId
		COMMIT
		SELECT @updatedprice = PRICE
		FROM TOY
		WHERE TOY_ID = @productId
		RETURN 1
	END
	ELSE 
	ROLLBACK
	RETURN -1
END 

DECLARE @out INT
EXEC usp_Toycenter '1001',2500,@out OUTPUT
PRINT @out

select * from TOY

-----------


