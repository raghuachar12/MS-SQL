
USE DB 
/* 1.Display all the employees data by sorting the date of joining in the ascending order and 
then by name in descending order. */
SELECT * FROM tbl1EmployeeDtlC1
SELECT * FROM tblDepartment

/*2.Modify the column name EmployeeName to Employee_FirstName and also add another 
column Employee_LastName   */
USE DB

select * 
from tbl1EmployeeDtlC1
ORDER BY joiningdate,employeename DESC

--2--
EXEC sp_rename 'tblEmployeeDtlC1.employeename','tblEmployeeDtlC1.Employee_FirstName','COLUMN'

EXEC sp_rename 'tblEmployeeDt1.lastname','Employee_LastName','COLUMN'

/*3.Write a query to change the table name to Employees.  */
EXEC sp_rename 'tblEmployeeDtlC1','EMPLOYEES'
select * 
from EMPLOYEES

ALTER TABLE EMPLOYEES ADD location VARCHAR(10)


/*4.Write a query to update the salary of those employees whose location is ‘Mysore’ to 35000.  */
update EMPLOYEES 
set salary='35000'
where employeeid=1010

/*5.Write a query to disassociate all trainees from their department  */
update EMPLOYEES
set Departmentid=null
where designation='Trainee software engineeer'

/*6.Write a query which adds another column ‘Bonus’ to the table Employees where the bonus 
is equal to the salary multiplied by ten. Update the value only when the experience is two 
years or above. */
ALTER TABLE EMPLOYEES
ADD Bonus int 

Update EMPLOYEES
Set Bonus=Salary*10
Where DATEDIFF(yyyy,joiningdate,getdate())>=2

/*7.Display name and salary of top 5 salaried employees from Mysore and Hyderabad. */
select Top 5 salary,employeename
from employees
where location='Mysore' OR location='BIRUR'

/*8.Display name and salary of top 3 salaried employees(Include employees with tie) */
Select TOP 3 WITH TIES salary,employeename 
from employees
ORDER BY SALARY DESC

/*9.Display top 1% salaried employees from Noida and Bangalore */
select TOP 1 PERCENT salary,employeename
from employees
where location='Mysore' and location='MYSORE'

/*10.Find average and total salary for each job. */
select designation,sum(salary) AS Total,avg(salary) As Avreage
from employees
Group By designation

/*11.Find highest salary of all departments. */
select Designation,max(salary) As Higest
from employees
group by designation

/*12. Find minimum salary of all departments. */
select designation,min(salary)As Minimum
from employees
group by designation

/*13. Find difference in highest and lowest salary for all departments. */
select designation,max(salary) As Higest,min(salary) As Lowest
from employees
group by designation

/*14.  Find average and total salary for trainees */
select Designation,AVG(salary) As Avreage,sum(salary) As Total
From employees
Group By designation

--15--
select count(DISTINCT(Designation)) As Total_Diff_jobs
from employees
where departmentid=30

--16--
select designation,max(salary),min(salary)
from employees

--17--
select designation,count(*) As Employeees,avg(salary*12) As Annual_salary
from employees
Group By Designation

--18-
select count(*)
from EMPLOYEES a
where joiningdate in (select joiningdate from EMPLOYEES where a.employeeid != employeeid)

--##select departmentid,salary,count(*) As samesalary from employees group by departmentid,salary
--##select * from employees
--19--
select count(*)
from EMPLOYEES a
where joiningdate in  (select joiningdate from EMPLOYEES where a.employeeid != employeeid)

--20--
select Departmentid,count(employeeid)
from employees a
where salary in(select salary from employees where a.employeeid !=employeeid)
group by DepartmentId

---21--
select count(employeeid) As Above 
from employees
where DATEDIFF(yyyy,joiningdate,GETDATE())>35
GROUP BY Departmentid

SELECT * from EMPLOYEES
SELECT * FROM tblDepartment
-----------------------------------------------------
 --ASSIGNMENT 4 

--1-- Display all employees with their Department Names(Exclude the Employees not allocated with Department)

select employeename,DepartmentName
from EMPLOYEES JOIN tblDepartment
ON EMPLOYEES.departmentid=tblDepartment.DepartmentId 

select * from  Employees SELECT * FROM tblDepartment

--2-- Display employees joined in the year 2020 with their Department Names

select employeename,DepartmentName,joiningdate
from EMPLOYEES,tblDepartment
where EMPLOYEES.DepartmentID=tblDepartment.DepartmentID and datepart(yyyy,joiningdate)=2020

--3-- Display employees who work in their hometown  with their Department Names(Exclude the employees not allocated with department)

select employeename,DepartmentName,Employees.Location
from Employees,tblDepartment
where Employees.DepartmentID=tblDepartment.DepartmentID and Employees.Location=tblDepartment.DepartmentLocation

--4-- Display All Departments with their employees(Include departments without Employees too)

select  employeename,DepartmentName
from Employees right outer join tblDepartment
on Employees.DepartmentID=tblDepartment.DepartmentID
	 
--5-- Display all employees with their department locations(Include employees who are not allocated with department)

select employeename,DepartmentName,Employees.Location
from Employees LEFT join tblDepartment
on Employees.DepartmentID=tblDepartment.DepartmentID and Employees.Location=tblDepartment.DepartmentLocation