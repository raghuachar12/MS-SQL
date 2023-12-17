
CREATE TABLE tblProject 
( 
   ProjectId BIGINT PRIMARY KEY, 
   Name VARCHAR(100) NOT NULL, 
   Code NVARCHAR(50) NOT NULL, 
   ExamYear SMALLINT NOT NULL 
); 
 
 
CREATE TABLE tblExamCentre  
( 
  ExamCentreId BIGINT PRIMARY KEY, 
  Code VARCHAR(100) NULL, 
  Name VARCHAR(100)  NULL 
); 
 
CREATE TABLE tblProjectExamCentre 
( 
   ProjectExamCentreId BIGINT PRIMARY KEY, 
   ExamCentreId BIGINT NOT NULL FOREIGN KEY REFERENCES tblExamCentre(ExamCentreId), 
   ProjectId BIGINT FOREIGN KEY REFERENCES tblProject(ProjectId) 
); 

INSERT INTO tblProject(ProjectId,Name,Code,ExamYear) VALUES 
(1,'8808-01-CW-YE-GCEA-2022','PJ0001',2022), 
(2,'6128-02-CW-YE-GCENT-2022','PJ0002',2022), 
(3, '7055-02-CW-YE-GCENA-2022','PJ0003',2022), 
(4,'8882-01-CW-YE-GCEA-2022','PJ0004',2022), 
(5,'7062-02-CW-YE-GCENT-2022','PJ0005',2022), 
(8,'6128-02-CW-YE-GCENT-1000','PJ0008',1000), 
(9,'7062-02-CW-YE-GCENT-5000','PJ0009',5000), 
(10,'8808-01-CW-YE-GCEA-2023','PJ0010',2023), 
(11,'8808-01-CW-YE-GCEA-2196','PJ0011',2196), 
(15,'6073-02-CW-YE-GCENA-2022','PJ0015',2022), 
(16,'8808-01-CW-YE-GCE0-2022','PJ0016',2022); 
 
 --------------------------------------------UPDATE
 
 ALTER trigger trgdemo
 on tblProject 
 for insert,update ,delete 
 as 
 begin 

 print 'opertations on table '

 end 

 update tblProject 
 set Name = 'updated'
 where ProjectId = 1

 INSERT INTO tblProject(ProjectId,Name,Code,ExamYear) VALUES 
(42,'CW-YE-GCEA-2022','PJ0020',2022)

delete tblProject 
where ProjectId =1 
 --------------------------------------------
 
INSERT INTO tblExamCentre(ExamCentreId,Name,Code) VALUES 
(112,'VICTORIA SCHOOL-GCENA-S','2711'), 
(185,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S','2746'), 
(227,'YIO CHU KANG SECONDARY SCHOOL-GCENA-S','2721'), 
(302,'CATHOLIC JUNIOR COLLEGE','9066'), 
(303,'ANGLO-CHINESE JUNIOR COLLEGE','9067'), 
(304,'ST. ANDREW''S JUNIOR COLLEGE','9068'), 
(305,'NANYANG JUNIOR COLLEGE','9069'), 
(306,'HWA CHONG INSTITUTION','9070'), 
(1,NULL,'2011'), 
(2,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S',NULL); 
 
 
INSERT INTO tblProjectExamCentre(ProjectExamCentreId,ProjectId,ExamCentreId) VALUES 
(44,1,112), 
(45,1,227), 
(46,1,185), 
(47,2,112), 
(48,2,227), 
(49,2,185), 
(50,3,112), 
(51,3,227), 
(52,3,185), 
(69,4,112); 
 
select * from tblProject 
select * from tblExamCentre 
select * from tblProjectExamCentre 
---------------------------------------------------------------------------------------------------------


--1. What are types of Variables and mention the difference between them 
 global variable and local variable
 global variable @@- - those are the variable which are used accross the db

 local variable
 local variable @ - - those are the variables which are used only in that session


 --2. Declare a variable with name [SQLData] which can store a string datatype 
	--and assign a value to using SELECT option and specify an alias name for the same
	Declare @SQLData varchar(50)
	set @SQLData = (select Name from tblProject where ProjectId=1)
	print @SQLData

	--3. What is used to define a SQL variable to put a value in a variable?
--	a. SET @id = 6;  this is the correct answer
	--b. SET id = 6;
	--c. Id = 6;
	--d. SET #id = 6;  


	--4. Compare Local and Global Temporary tables with an Example
	 global variable and local variable
 global variable @@- - those are the variable which are used accross the db
 Declare @@Did int =10
 print @@Did

 local variable
 local variable @ - - those are the variables which are used only in that session
  Declare @Did int =10
 print @Did


 --5. Create a table with an IDENTITY column whose Seed value is 2 and Increment value of 100
 create table employee
 (
 id int identity(2,100),
 name varchar(20)
 )

 insert  into employee (name) values
 ('Raju')
  insert  into employee (name) values('Kumar')
  insert  into employee (name) values('anthony')

  select * from employee


  6. What is the difference between SCOPE_IDENTITY() and @@IDENTITY. Explain with an Example.
 select  SCOPE_IDENTITY()
 select * from employee

 select @@IDENTITY
 select * from employee

 both works as same it will return the last indexed id

-----------------------------------------------------------------------------------------------------------

--1.Write a procedure to fetch the ProjectId, ProjectName, ProjectCode, ExamCentreName 
--and ExamCentreCode from the tables tblProject and  
--tblExamCentre based on the ProjectId and ExamCentreId passed as input parameters. 
 USE TSQL

 create or alter procedure usp_q1
(@p int,@e int)

as
begin
IF(@p not in (select ProjectId from tblProject))
begin
print'enter valid pid'
end
begin
select p.ProjectId,p.Name,p.Code,e.Name
from tblProject p inner join tblProjectExamCentre pe
on p.ProjectId=pe.ProjectId
inner join  tblExamCentre e
on pe.ExamCentreId = pe.ExamCentreId
where p.ProjectId=@p and pe.ExamCentreId =@e
end
end
go

exec usp_q1 @p= 3,@e=227 

--2.Write a procedure to insert values into the table tblProject when the data for the 
--ProjectId  
--which is being inserted does not exist in the table. 

create or alter procedure usp_q2
(@ProjectId bigint,@Name varchar(20),@Code NVARCHAR(50),@ExamYear SMALLINT)

as 
begin 
if (@ProjectId in (select ProjectId from  tblProject))
	begin
		print 'REC ALREADY EXISTS'
	end
	begin
		insert into tblProject values (@ProjectId,@Name,@Code,@ExamYear)
	end 
end 
go

exec usp_q2 @ProjectId=20,@Name='abc',@Code='xyz',@ExamYear=2025

select * from tblProject

--3.Write a procedure to update the columns-Code and Name in tblExamCentre when 
--either of the Code or the Name column is NULL  
--and also delete the records from the table tblProjectExamCentre when ProjectId IS 4. 

create procedure usp_q3
(@code int,@name varchar(10))
as 
begin 

	update tblExamCentre 
	set code = @code ,Name = @name
	where (Code is null or Name is null)

	delete tblExamCentre where ProjectId = 4
end 
go 
 
 exec usp_q3 @code = 2000,@name = 'new'

 select * from  tblExamCentre


-- 4.Write a procedure to fetch the total count of records present in the table tblProject 
--based on the ProjectId AS OUTPUT parameter 
--and also sort the records in ascending order based on the ProjectName. 


alter procedure usp_q4
@ProjectId int, 
@Pcount int output

as 
begin 
select @Pcount = count(ProjectId) from  tblProject
SELECT * FROM tblProject ORDER BY Name 
end 

declare @Pcount int
exec usp_q4 @ProjectId=1,@Pcount=@Pcount output 
select @Pcount

SELECT * FROM tblProject
--5.Write a procedure to create a Temp table named Students with columns- 
--StudentId,StudentName and Marks where the  
--column StudentId is generated automatically  
--and insert data into the table and also retrieve the data. 

alter procedure usp_q5 
(@StudentId int ,@StudentName varchar(10))
as begin 

  create table #student(
StudentId int ,
StudentName varchar(10))

insert into #student values(@StudentId,@StudentName)


 exec usp_q5 @StudentId = 2,@StudentName = 'bahrat'
 exec usp_q5 @StudentId = 3,@StudentName = 'rahul'

 SELECT * FROM #student
 END


-- 6.Write a procedure to perform the following DML operations on the column - 
--ProjectName in tblProject table by using a varibale.  
--Declare a local variable and initialize it to value 0,  
--1. When the value of the variable is equal to 2, then insert another record into the table 
--tblProject. 
--2. When the value of the variable is equal to 10, then change the ProjectName to 
--'Project_New' for input @ProjectId 
 
--In the next part of the stored procedure, return all the fields of the table 
--tblProject(ProjectId,ProjectName,Code and Examyear) 
--based on the ProjectId and for the column ExamYear display it as given using CASE 
--statement. 
--1.If the ExamYear is greater than or equal to 2022 then display 'New' 
--2.If the ExamYear is lesser than or equal to 2022 then display 'Old' 
 

 CREATE PROCEDURE usp_UpdateProjectName
    @ProjectId BIGINT,
    @VariableValue INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check the value of the variable
    IF @VariableValue = 2
    BEGIN
        -- When the variable value is 2, insert another record into tblProject
        INSERT INTO tblProject (Name, Code, ExamYear)
        VALUES ('New Project', 'NP0001', 2023);
    END
    ELSE IF @VariableValue = 10
    BEGIN
        -- When the variable value is 10, change the ProjectName to 'Project_New'
        UPDATE tblProject
        SET Name = 'Project_New'
        WHERE ProjectId = @ProjectId;
    END
END

exec usp_UpdateProjectName @ProjectId=5,@VariableValue=2


-------------------------
--ASSIGNMENT 10
-----------------------
--1.Consider table tblEmployeeDtls and write a stored procedure to generate 
--bonus to employees for the given date  as below: 
--A)One month salary  if Experience>10 years  
--B)50% of salary  if experience between 5 and 10 years  
--C)Rs. 5000  if experience is less than 5 years 
--Also, return the total bonus dispatched for the year as output parameter. 

ALTER PROCEDURE usp_emp
(@EmployeeID INT)
AS 
BEGIN 

DECLARE 
		@EmployeeName varchar(20),
		@Experiance INT,
		@Bonus INT

SELECT 
		@EmployeeName = EmployeeName,
		@Experiance = DATEDIFF(YY,JoiningDate,Getdate())
		FROM tblEmployeeDtlC 

IF (@Experiance > 10 )
BEGIN 
	SET @Bonus = 1000
END 
ELSE IF (@Experiance > 5 AND @Experiance < 10)
BEGIN 
	SET @Bonus = 500 
END 
ELSE IF (@Experiance < 5)
BEGIN 
	SET  @Bonus = 300 
END 

UPDATE tblEmployeeDtlC 
SET Salary = Salary + @Bonus
WHERE EmployeeID = @EmployeeID

END 

--DECLARE @Bonus INT

EXEC usp_emp @EmployeeID=11

SELECT * FROM tblEmployeeDtlC

-----------------
--2.Create a stored procedure that returns a sales report for a given time period 
--for a given Sales Person. Write commands to invoke the procedure 

alter PROC usp_pr2 (@sid INT)
AS
BEGIN
IF(@sid IN (SELECT snum FROM salesmen))
BEGIN
SELECT * 
FROM salesmen
WHERE  snum = @sid 
END
ELSE
PRINT'incorrect id '
END

EXEC usp_pr2 @sid=15

----------------------------------------

--3.Also generate the month and maximum ordervalue booked by the given 
--salesman(use output parameter) 
--Tables 
--SALESMAN 
--SalesmanNo, Customerno, Orderno 
--Customers 
--CustomerNo,CustomerName, SalesmanNo, OrderNo 
--Orders 
--Orderno, ProductNo, Qty, CustomerNo, OrderDate 
--Products 
--ProdctNo, ProductName, UnitPrice,Discount 



create PROC pr3(@startdate DATE,@enddate DATE,@sid INT,
@month VARCHAR(10) OUTPUT,@max INT OUTPUT)
AS
BEGIN
	IF(@sid IN (SELECT sid FROM Salesman))
		BEGIN
		SELECT TOP 1 @month = DATENAME(MONTH,Sldate),@max = Amount 
		FROM Sale
		WHERE Sid = @sid
		ORDER BY Amount DESC
		END
	ELSE
	PRINT'Salesman not exists'
END

select * from Salesman

DECLARE @month VARCHAR(10),@Max_Amt INT
EXEC pr3 '2020/01/01','2023/11/10',101,@month OUTPUT,@Max_Amt OUTPUT

SELECT @month AS MONTH,@Max_Amt AS MAX_Amt

----------------------

-----trigger --------------
--------------------
--Write a Trigger to Alert the user whenever there is an update in tblEmployeedtls  
--table 
ALTER trigger trgdemo
 on tblProject 
 for insert,update ,delete 
 as 
 begin 

 print 'alert an opertations on table '

 end 

 update tblProject 
 set Name = 'updated'
 where ProjectId = 2

 INSERT INTO tblProject(ProjectId,Name,Code,ExamYear) VALUES 
(22,'CW-YE-GCEA-2022','PJ0020',2022)

delete tblProject 
where ProjectId =1

select * from tblProject

----------------------------
--insert --
CREATE TABLE empaudit(
Id int primary key,
auditdate date)

CREATE TRIGGER  tr_insert
on tblProject
for INSERT 
AS 
BEGIN 
DECLARE @Id int 

SELECT @Id = ProjectId
from inserted 
insert into empaudit values (110,'04/05/2022')

end 

insert into tblProject values (31,'GCEA-2022','PJ0001',2029)

select * from tblProject

------------------------------------------------
--delete--
create TABLE empaudit(
Id int primary key,
auditdate date)

alter TRIGGER  tr_insert
on tblProject
for delete 
AS 
BEGIN 
DECLARE @Id int 
SELECT @Id = ProjectId
from deleted 

insert into empaudit values (111,'04/05/2022')

end 

insert into tblProject values (40,'GCEA-2022','PJ0001',2029)

select * from tblProject

-------------------------------------------------------------
CREATE CLUSTERED INDEX 