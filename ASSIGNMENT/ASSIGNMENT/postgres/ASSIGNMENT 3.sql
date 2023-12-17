CREATE TABLE departmentss
(
   department_id INT PRIMARY KEY,
   department_name VARCHAR(100));
   
   
CREATE TABLE studentss
(
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100),
  student_department INT,
  stipend INT,
  CONSTRAINT fk_student FOREIGN KEY(student_department) REFERENCES departmentss(department_id));
  
 INSERT INTO departmentss VALUES(1,'SCIENCE')
 INSERT INTO departmentss VALUES
(2,'Commerce'),
(3,'Bio-Chemistry'),
(4,'Bio-Medical'),
(5,'Fine Arts'),
(6,'Literature'),
(7,'Animation'),
(8,'Marketing');

INSERT INTO studentss VALUES
(1,'Hadria',7,2000),
(2,'Trumann',2,2000),
(3,'Earlie',3,2000),
(4,'Monika',4,2000),
(5,'Aila',5,2000),
(6,'Trina',5,2000),
(7,'Esteban',3,2000),
(8,'Camilla',1,2000),
(9,'Georgina',4,2000),
(10,'Reed',6,16000),
(11,'Northrup',7,2000),
(12,'Tina',2,2000),
(13,'Jonathan',	2,2000),
(14,'Renae,'7,2000),
(15,'Sophi',6,16000),
(16,'Rayner',3,2000),
(17,'Mona',6,16000),
(18,'Aloin',5,2000),
(19,'Florance',5,2000),
(20,'Elsie',5,2000);

SELECT * FROM departmentss

SELECT * FROM studentss

--PROCEDURES
--1
--1.Write a stored procedure to insert values into the student table ans also update the student_department to 7 when the student_id
--is between 400 and 700.


CREATE or REPLACE PROCEDURE Q1 (IN SID INT,IN SNAME VARCHAR(20),DID INT,STIPEND INT)
AS $$
BEGIN 

	INSERT INTO studentss (student_id,student_name,student_department,stipend) VALUES 
	(SID,SNAME,DID,STIPEND);
	
	IF SID <700 AND SID >400 THEN 
	
	UPDATE studentss  
	SET student_department = 777
	WHERE student_id = SID;
	END IF;

END;
$$ LANGUAGE plpgsql;

CALL Q1(334,'RAHUL',3,2200)

SELECT * FROM studentss

--2
--2.Write a procedure to update the department name to 'Animation' when the department id is 7. This command has to be committed.
--Write another statement to delete the record from the students table based on the studentid passed as the input parameter.This statement should not be committed.
 
CREATE or REPLACE PROCEDURE Q2 (IN SID INT )
AS $$
BEGIN 

	UPDATE departmentss  
	SET department_name = 'ANIMATION-NEW'
	WHERE department_id = 7;
	COMMIT;

	BEGIN 
	DELETE FROM studentss WHERE student_id=SID;
	ROLLBACK ;
	END ;

END;
$$ LANGUAGE plpgsql;

CALL Q2(10)

SELECT * FROM studentss

--3.Write a procedure to display the sum,average,minimum and maximum values of the column stipend from the students table.

CREATE OR REPLACE PROCEDURE Q3(INOUT SUM1 INT ,INOUT MIN1 INT,INOUT MAX1 INT ,INOUT AVG1 INT )
AS $$
BEGIN
	SELECT SUM(stipend),MIN(stipend),AVG(stipend),MAX(stipend) INTO SUM1,MIN1,MAX1,AVG1 
	  FROM studentss;

END ;
$$ LANGUAGE plpgsql;

CALL Q3(0,0,0,0)



--SUBQUERY--
--1.Fetch all the records from the table students where the stipend is more than 'Florence'

SELECT * FROM 
studentss 
WHERE stipend >= (SELECT stipend 
				  FROM studentss 
				  WHERE student_name = 'Camilla')
				  
--2 Return all the records from the students table who get more than the minimum stipend for the department 'FineArts'.

SELECT * 
FROM studentss 
WHERE stipend > (SELECT MIN(stipend) 
				   FROM studentss 
				   WHERE student_department IN (SELECT department_id 
											   from departmentss 
											   where department_name = 'Fine Arts'))
											   
											   
--1.Using a subquery, list the name of the employees, paid more than 'Fred Costner' from employees.

SELECT student_name 
FROM studentss 
WHERE stipend > (SELECT stipend 
					FROM studentss 
					WHERE student_name = 'Georgina' )
					
--2 Find all employees who earn more than the average salary in their department.

SELECT * 
FROM studentss 
WHERE stipend > (SELECT AVG(stipend) 
				FROM studentss )
				
-------------->>EMP TABLE<<------------------ 

CREATE TABLE EMP1(
eid INT ,
ename varchar(10),
salary int ,
mgrid int ,
depid int )

INSERT INTO EMP1 VALUES (6,'ANI',19000,3,20)

SELECT * FROM EMP1

--1 Using a subquery, list the name of the employees, paid more than 'Fred Costner' from employees.

SELECT eid,ename 
FROM EMP1 
WHERE salary > (SELECT salary 
					FROM EMP1 
					WHERE ename = 'ABI')
					
--2 Find all employees who earn more than the average salary in their department.

SELECT ename,eid,depid
FROM EMP1 
WHERE salary > (SELECT AVG(salary)
			   FROM EMP1 )
			
--3 Write a query to select those employees who does not work in those department where the 
--managers of ID between 100 and 200 works.

SELECT * 
FROM EMP1 
WHERE depid NOT IN (SELECT depid 
				   FROM EMP1
				   WHERE mgrid in (1,2))
				   
--4 Find employees who have at least one person reporting to them.

SELECT E1.ename,E1.eid 
FROM EMP1 E1 join  EMP1 E2
ON E1.eid = E2.mgrid
GROUP BY E1.eid ,E1.ename
ORDER BY E1.eid 

SELECT * FROM EMP1

--------------------------------------------------------------------------------------------

--CTE 

--1.Write a query to fetch the student_name,stipend and department_name from the students and departments
--table where the student_id is between 1 to 5 AND stipend is in the range of 2000 to 4000.

WITH Q1 AS (
	SELECT S.student_name,S.stipend,D.department_name 
	FROM studentss S JOIN departmentss D
	ON S.student_department = D.department_id
	WHERE D.department_id BETWEEN 1 AND 5 
	AND S.stipend BETWEEN 2000 AND 4000
)

SELECT * FROM Q1 

SELECT * FROM studentss

--2 .Write a query to fetch the sum value of the stipend from the students table based on the department_id 
--where the departments 'Animation' and 'Marketing' should not be included and 
--the sum value should be less than 4000.

WITH Q2 AS (
	SELECT SUM(stipend),student_department
	FROM studentss S JOIN departmentss D
	ON D.department_id = S.student_department
	WHERE D.department_name NOT IN ('Animation','Marketing')
	GROUP BY student_department
	HAVING SUM(stipend)<4000
)

SELECT student_department FROM Q2

--3 3.Using the concept of multiple cte,
--fetch the maximum value, minimm value, average and 
--sum of the stipend based on the department and return all the values.

WITH ONE AS (
	SELECT MAX(stipend),student_department
	FROM studentss 
	GROUP BY student_department
	ORDER BY student_department
),
TWO AS (
	SELECT MIN(stipend),student_department
	FROM studentss 
	GROUP BY student_department
	ORDER BY student_department
),
THREE AS (
	SELECT SUM (stipend),student_department
	FROM studentss 
	GROUP BY student_department
	ORDER BY student_department
),
FOUR AS (
SELECT ROUND(AVG(stipend)),student_department
	FROM studentss 
	GROUP BY student_department
	ORDER BY student_department
)

SELECT * 
FROM ONE A JOIN TWO B ON A.student_department = B.student_department 
JOIN THREE C ON B. student_department = C.student_department 
JOIN FOUR D ON C.student_department = D.student_departmentk   

--------


