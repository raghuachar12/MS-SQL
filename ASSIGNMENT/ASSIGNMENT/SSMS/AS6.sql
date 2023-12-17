
--ASSIGNMENT 6 
CREATE TABLE ACC_TYPE(
ACC_TYPE INT PRIMARY KEY,
ACC_NAME VARCHAR(20))


CREATE TABLE TRA_TYPE(
TRANS_TYPE INT PRIMARY KEY,
TRANS_NAME VARCHAR(20))


CREATE TABLE C_DETAILS(
ACC_NO INT PRIMARY KEY,
CNAME VARCHAR(20),
ADDR VARCHAR(20),
ACC_TYPE INT FOREIGN KEY (ACC_TYPE) REFERENCES ACC_TYPE (ACC_TYPE) )

CREATE TABLE ACC_TRANS(
TID INT PRIMARY KEY,
ACC_NO INT FOREIGN KEY (ACC_NO) REFERENCES C_DETAILS (ACC_NO),
AMOUNT MONEY,
DATE_OF_T DATE,
TRANS_TYPE INT FOREIGN KEY (TRANS_TYPE) REFERENCES TRA_TYPE (TRANS_TYPE)
) 

USE bank
SELECT * FROM ACC_TYPE

SELECT * FROM TRA_TYPE

SELECT * FROM C_DETAILS

SELECT * FROM ACC_TRANS

--1--List the Customer with transaction details who has done third lowest  transaction 

SELECT TOP 3 CNAME ,MIN(AMOUNT) AS MIN_SAL  
FROM C_DETAILS JOIN ACC_TRANS ON C_DETAILS.ACC_TYPE = ACC_TRANS.TRANS_TYPE 
GROUP BY CNAME 

--2-- List the customers who has done more transactions than average number of  transaction  

SELECT CNAME,COUNT(TID) TID  
FROM C_DETAILS JOIN ACC_TRANS ON C_DETAILS.ACC_TYPE = ACC_TRANS.TRANS_TYPE
GROUP BY CNAME ,TID
HAVING COUNT(TID) IN (SELECT COUNT(TID) FROM ACC_TRANS
GROUP BY ACC_NO)
-------------------------------------


--3-- List the total transactions under each account type. 

SELECT C_DETAILS.ACC_NO,COUNT(TID)TRANS_COUNT,C_DETAILS.ACC_TYPE
FROM ACC_TYPE JOIN C_DETAILS 
ON ACC_TYPE.ACC_TYPE = C_DETAILS.ACC_TYPE JOIN ACC_TRANS 
ON C_DETAILS.ACC_NO = ACC_TRANS.ACC_NO
GROUP BY C_DETAILS.ACC_NO,C_DETAILS.ACC_TYPE

--4--List the total amount of transaction under each account type 

SELECT C_DETAILS.ACC_NO,SUM(AMOUNT)TRANS_AMOUNT,C_DETAILS.ACC_TYPE
FROM ACC_TYPE left JOIN C_DETAILS 
ON ACC_TYPE.ACC_TYPE = C_DETAILS.ACC_TYPE right JOIN ACC_TRANS 
ON C_DETAILS.ACC_NO = ACC_TRANS.ACC_NO
GROUP BY C_DETAILS.ACC_NO,C_DETAILS.ACC_TYPE

----------------------------------------
SELECT * FROM ACC_TYPE

SELECT * FROM TRA_TYPE

SELECT * FROM C_DETAILS

SELECT * FROM ACC_TRANS

--5--List the total tranctions along with the total amount on a Sunday. 

SELECT SUM(AMOUNT)TRANS_AMOUNT,COUNT(TID)TRANS_COUNT
FROM ACC_TRANS 
WHERE DATENAME(Dw,DATE_OF_T)='sunday'


--6--List the name, address, account type and total deposit from each customer account.

SELECT C.CNAME,C.ACC_TYPE,SUM(T.AMOUNT)
FROM C_DETAILS C RIGHT JOIN ACC_TRANS T ON C.ACC_NO = T.ACC_NO JOIN TRA_TYPE T1 ON T1.TRANS_TYPE = T.TRANS_TYPE
WHERE T1.TRANS_NAME = 'DEPOSIT'
GROUP BY C.CNAME,C.ACC_TYPE

--7--List the total amount of transactions of Mysore customers. 

SELECT SUM(T.AMOUNT) AS TOTAL_TRANSS
FROM C_DETAILS C JOIN ACC_TRANS T
ON C.ACC_NO = T.ACC_NO
GROUP BY C.ADDR
HAVING C.ADDR IN ('SMG')


--8--List the name,account type and the number of transactions performed by each customer. 

SELECT COUNT(ACC_TRANS.TID) COUNTT,C_DETAILS.CNAME,C_DETAILS.ACC_NO
FROM C_DETAILS JOIN ACC_TRANS
ON C_DETAILS.ACC_NO = ACC_TRANS.ACC_NO
GROUP BY C_DETAILS.ACC_NO,C_DETAILS.CNAME,C_DETAILS.ACC_NO

--9--List the amount of transaction from each Location. 

SELECT C_DETAILS.ADDR,SUM(ACC_TRANS.AMOUNT) AMT
FROM C_DETAILS RIGHT JOIN ACC_TRANS
ON C_DETAILS.ACC_NO = ACC_TRANS.ACC_NO
GROUP BY C_DETAILS.ADDR

--10--Find out the number of customers  Under Each Account Type 

SELECT COUNT(C_DETAILS.ACC_NO) NUMBER_OF_CUST,C_DETAILS.ACC_TYPE
FROM C_DETAILS JOIN ACC_TRANS
ON C_DETAILS.ACC_TYPE = ACC_TRANS.TRANS_TYPE
GROUP BY C_DETAILS.ACC_NO,C_DETAILS.ACC_TYPE

-------------------------

CREATE DATABASE SALESMAN

-------------------------------------------------------------------------------------
-----------------------VIEW-----------------------------------------------------
SELECT * FROM C_DETAILS
--------------------------------------------------------------------------------
CREATE VIEW VIEW_TBL
AS
SELECT * FROM C_DETAILS

SELECT * FROM VIEW_TBL
sp_helptext VIEW_TBL

select ACC_NO FROM VIEW_TBL
---------------------------------------------------------------------------------
CREATE VIEW VIEW_TBL3
WITH SCHEMABINDING 
AS
SELECT ACC_NO,CNAME FROM dbo.C_DETAILS

SELECT * FROM VIEW_TBL3

INSERT INTO VIEW_TBL3 VALUES (105,'RAHUL')

ALTER TABLE dbo.VIEW_TBL3 drop column ACC_NO
-------------------------------------------------------------------------------------
CREATE VIEW DEMO
WITH ENCRYPTION  
AS
SELECT ACC_NO,CNAME FROM dbo.C_DETAILS

SELECT * FROM DEMO
sp_helptext DEMO

------------------------------------------
ALTER VIEW DEMO
AS 
SELECT ADDR FROM C_DETAILS 

SELECT * FROM DEMO

----------------------------------------------------------
SELECT * FROM ACC_TYPE

SELECT * FROM TRA_TYPE

SELECT * FROM C_DETAILS

SELECT * FROM ACC_TRANS

---------------------------------------------------------
CREATE VIEW SAMPLE1
AS 
SELECT A.ACC_NAME,B.CNAME
FROM ACC_TYPE A JOIN C_DETAILS B
ON A.ACC_TYPE = B.ACC_TYPE

SELECT * FROM SAMPLE1
---------------------------------------------------------
CREATE VIEW SAMPLE2
AS
SELECT A.ACC_NO,B.ACC_TYPE
FROM ACC_TRANS A JOIN C_DETAILS B
ON A.ACC_NO = B.ACC_NO

SELECT * FROM SAMPLE2

SELECT * FROM ACC_TYPE

SELECT * FROM TRA_TYPE

SELECT * FROM C_DETAILS

SELECT * FROM ACC_TRANS
----------------------------------------------------------

-----------NON EQUI JOIN -------------------

