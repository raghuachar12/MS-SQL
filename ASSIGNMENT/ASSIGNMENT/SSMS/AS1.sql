USE DB 

--ASSIGNMENT 1

CREATE TABLE tblDepartment(
DepartmentId INT PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL,
DepartmentLocation VARCHAR(50) NOT NULL);

--	Creating the table tblEmployee
--DROP TABLE tblEmployee;

CREATE TABLE tblEmployee(
EmployeeId INT PRIMARY KEY,
EmployeeName VARCHAR(50) NOT NULL,
Designation VARCHAR(50) NOT NULL,
JoiningDate DATETIME NOT NULL,
EmailId VARCHAR(50) UNIQUE NOT NULL,
Salary INT NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES tblDepartment(DepartmentId));

INSERT INTO tblDepartment VALUES
(10, 'Development', 'Mysore'),
(20, 'Finance', 'Delhi'),
(30, 'Marketing', 'Banglore'),
(40, 'Testing', 'Manglore'),
(50, 'Management', 'Udupi');

INSERT INTO tblEmployee VALUES
(1000, 'Raghu', 'Software Engineer', '2019-10-16','prajwal@excelindia.com', 50000,10),
(1001, 'Sagar', 'Trainee Software Engineer', '2022-01-12','Sagar@excelindia.com', 35000,10),
(1002, 'Nishanth', 'Business Analysts', '2021-04-12','Nishanth@excelindia.com', 48000,20),
(1003, 'Raghu', 'Business Analysts', '2022-02-01','Raghu@excelindia.com', 16000,20),
(1004, 'Sushil', 'Copywriter', '2022-01-12','Sushil@excelindia.com', 15000,30),
(1005, 'Pavithra', 'Copywriter', '2019-10-12','Pavithra@excelindia.com', 38000,30),
(1006, 'Vatsala', 'Teacher', '2020-08-14','Vatsala@excelindia.com', 13000,NULL),
(1007, 'Subramanya', 'Teacher', '2019-09-18','Subramanya@excelindia.com', 19000,NULL),
(1008, 'Akash', 'Software Tester', '2017-09-08','Akash@excelindia.com', 38000,40),
(1009, 'Raj Shekara', 'Software Tester', '2017-09-08','Rajshekara@excelindia.com', 21000,50);


--2-Display Table information. 
select * from tblEmployee
select * from tblEmployee
delete from  tblEmployee where EmployeeId=1000


--3 Display Employee’s name,  EmployeeId, departmentId  from tblEmployee 
select EmployeeName,EmployeeId,Departmentid from tblEmployee

--4  Display Employee’s name,  EmployeeId, departmentId  of department 20 and 40. 
select EmployeeName,EmployeeId,Departmentid from tblEmployeeDt1 where DepartmentId in (20,10)

--5 Display information about all ‘ Trainees Software Engineer’  having salary less than 20000. 
select * from tblEmployee where Designation = 'Trainee software engineeer' and Salary<=20000

--6  Display information about all employees of department 30 having salary greater than 20000.
select * from tblEmployee where DepartmentId = 30 and salary>=20000

--7 Display list of employees who are not allocated with Department. 
select * from tblEmployee where DepartmentId is null

--8 Display name and department of all ‘ Business Analysts’. 
select EmployeeName,Departmentid  from tblEmployee where Designation = 'HR'

--9 Display name, Designation and salary of all the employees of department 30 who earn 
more than 20000 and less than 40000
select EmployeeName,Designation,salary from tblEmployee where DepartmentId = 30 and salary BETWEEN 20000 and 40000

--10 Display unique job of tblEmployee. 
select distinct(designation) from tblEmployee

--11 Display list of employees who earn more than 20000 every year of department 20 and 30. 
select Salary from tblEmployee where Salary*12>20000 and DepartmentId in (20,30)

--12 List Designation, department no and Joined date in the format of Day, Month, and Year of department 20. 
select Designation,DepartmentId,Format(JoiningDate,'d/mm/yyyy') from tblEmployee where DepartmentId = 20

--13 Display employees whose name starts with an vowel 
select employeename from tblEmployee where employeename like '[aeiou]%'

--14 Display employees whose name is less than 10 characters 
select employeename from tblEmployee where len(employeename)<10

--15 Display employees who have ‘N’ in their name 
select employeename from tblEmployee where employeename like '%N%'

--16 Display the employees with more than three years of experience 
select * from tblEmployee where ( DATEPART(YYYY,getdate()))-(DATEPART(YYYY,JoiningDate))>3
---Using Date diff

--17 Display employees who joined on Monday 
select * from tblEmployee where datepart(day,JoiningDate)=17

--18 Display employees who joined on 1st. 
select top 1 * from tblEmployee order by JoiningDate

---19 Display all Employees joined in January 
select * from tblEmployee where datename(dd,JoiningDate)=13 

---20 Display Employees with their Initials. 
select concat(employeename,'') from tblEmployee


