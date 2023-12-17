--PostgreSQL Views
Views are pseudo-tables.
A view is a stored query. 
A view can be accessed as a virtual table in PostgreSQL. 
In other words, a PostgreSQL view is a logical table that represents data of one or more underlying tables through a SELECT statement.
The view name should be unique in a database.
A view does not store data physically like a table except for a materialized view.

---*******************************************************************************************
---A view can be very useful in some cases such as:

* A view helps simplify the complexity of a query because you can query a view, which is based on a complex query, using a simple SELECT statement.
* Like a table, you can grant permission to users through a view that contains specific data that the users are authorized to see.
* A view provides a consistent layer even the columns of the underlying table change.

---Creating PostgreSQL Views
To create a view, we use  CREATE VIEW statement. 
The simplest syntax of the CREATE VIEW statement is as follows:

CREATE VIEW Name AS   
Select column1, Column2...Column N From tables   
Where conditions; 

CREATE VIEW view_name AS 
query;

CREATE TABLE department(
dep_id SERIAL PRIMARY KEY,
dep_name VARCHAR(50));

INSERT INTO department(dep_name)
VALUES('Admin'),
('Sales'),
('Accounts'),
('Production'),
('Marketing'),
('Management');

SELECT * FROM department;

--DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
emp_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
phone VARCHAR(50) NOT NULL,
dep_id INTEGER REFERENCES department(dep_id),
salary NUMERIC  NOT NULL
);

INSERT INTO employees(first_name,last_name,email,phone,dep_id,salary)
VALUES
('John', 'Doe','johndoe@gmail.com','9876543210',1,250000),
('Lily', 'Bush','lilly@gmail.com','9854321674',1,250000),
('Kumar', 'Mishra','kumar07@gmail.com','7342556987',2,50000),
('Dilip', 'Acharya','acharyadilip@yahoo.com','7676524320',2,50000),
('Tilak', 'Arya','tilaktilak@gmail.com','6363546354',3,30000),
('Anuj', 'Kapoor','kapooranuj05@yahoo.com','6378952341',3,30000),
('Rahul','Jain','rahuljain@gamil.com','9876763251',4,70000),
('Nigam','Arora','nihamarora@yahoo.com','9960501580',4,70000),
('Ahan','Kapoor','ahankapoor@yahoo.com','9343536323',5,20000),
('Arya','Malik','aryamalik@gamil.com','9737568742',6,100000),
('Kumud','Khurana','kumudkhurana@gamil.com','8446351067',6,100000),
('Kamakshi','Vijay','kamakshivijay@gamil.com','9910805021',5,20000);
-- ('Arundhati','Varma','arundhativarma@gamil.com');;

SELECT e.dep_id,SUM(e.salary)
FROM employees e
GROUP BY e.dep_id;

CREATE VIEW vw_employee AS 
SELECT 
	e.emp_id,e.first_name || ' ' || e.last_name AS name,e.email
	FROM
	employees e;
	
	SELECT * FROM vw_employee;
	
	
-- SELECT 
-- 	emp_id,first_name || ' ' || last_name AS name,e.salary,e.dep_id
-- 	FROM
-- 	employees e
-- 	INNER JOIN department d
-- 	ON d.dep_id = e.dep_id;

----View using multiple tables
CREATE VIEW vw_employee_details AS
SELECT 
	e.first_name || ' ' || e.last_name AS name,d.dep_id,SUM(e.salary)
	FROM
	employees e
	INNER JOIN department d
	ON d.dep_id = e.dep_id
	GROUP BY d.dep_id;
	
	SELECT * FROM vw_employee_details

----View to check the departments(Using aggregate function)
CREATE OR REPLACE VIEW vw_empsalary AS
	SELECT 
	emp_id,e.salary,e.dep_id,e.email,count(e.dep_id) AS noofdepartments
	FROM
	employees e
	INNER JOIN department d
	ON d.dep_id = e.dep_id
	GROUP BY emp_id,e.salary,e.dep_id;
	
	SELECT * FROM vw_empsalary

--we can use columns to fetch data similar to table
	select v.emp_id from vw_empsalary v

-----********************************************************************************

---Changing PostgreSQL Views
To change the defining query of a view, you use the CREATE VIEW statement with OR REPLACE addition as follows:

---OR REPLACE 
CREATE OR REPLACE VIEW vw_empsalary 
AS 
SELECT 
	emp_id,e.salary,e.dep_id
	FROM
	employees e
	INNER JOIN department d
	ON d.dep_id = e.dep_id
	GROUP BY emp_id,e.salary,e.dep_id;
	
	SELECT * FROM vw_empsalary;
	

/*
Note: 
1. You cannot drop an existing column from a view.
2. You can add a column to the existing view.
*/

---ALTER
To change the definition of a view, you use the ALTER VIEW statement.

ALTER VIEW name 
RENAME TO new_name;

ALTER VIEW vw_empsalary 
RENAME TO view_empsalary;

SELECT * FROM vw_empsalary;

SELECT * FROM view_empsalary;

----Removing PostgreSQL Views
To remove an existing view in PostgreSQL, you use DROP VIEW statement as follows:

DROP VIEW IF EXISTS view_name
[CASCADE | RESTRICT]

DROP VIEW [IF EXISTS] view_name1, view_name2,

DROP VIEW  IF EXISTS  vw_empsalary;

/*
Note: To execute the DROP VIEW statement, you must be the owner of the view.
*/
-----*****************************************************************************************

	CREATE TABLE film_category(	
	category_id SERIAL PRIMARY KEY,
	name VARCHAR(50)
	);
	
	INSERT INTO film_category(category_id,name)
	VALUES
	(1,'Comedy'),
	(2,'Horror');
	
	SELECT * FROM film_category;
	
	CREATE TABLE film(
	film_id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	language VARCHAR(20),
	length INTEGER,
	release_year DATE,
	category_id INTEGER REFERENCES film_category(category_id)
	);
	
	INSERT INTO film(title,language,length,release_year,category_id)
	VALUES
	('Sharavanii Subramanya','Kannada',145,'2013-12-21',1),
	('Golmaal','Hindi',150,'2015-02-15',1),
	('Baby''s day out','English',120,'2000-08-01',1),
	('Kanchana','Kannada',165,'2014-06-10',2),
	('Stree','Hindi',135,'2018-04-30',2),
	('The Conjuring','English',160,'2001-03-31',2);
	
	SELECT * FROM film;

----View with containing both the table data
	CREATE VIEW film_master 
AS
SELECT 
	film_id, 
	title, 
	language, 
	length, 
	name as category
FROM 
	film
INNER JOIN film_category 
	USING (category_id);

SELECT * FROM  film_master;

DROP TABLE film;

-----view to get only horror movies----
CREATE VIEW horror_film 
AS
SELECT 
	film_id, 
	title, 
	language, 
	length 
FROM 
	film_master
WHERE 
	category = 'Horror';
	
	SELECT * FROM horror_film;

------view to get comedy movies----
	CREATE VIEW comedy_film 
AS
SELECT 
	film_id, 
	title, 
	language, 
	length 
FROM 
	film_master
WHERE 
	category = 'Comedy';
	
	SELECT * FROM comedy_film;

-----view that returns the number of films by category---
	CREATE VIEW film_category_stat
AS
SELECT 
	name, 
	COUNT(film_id) 
FROM film_category
INNER JOIN film USING (category_id)
GROUP BY name;

SELECT * FROM film_category_stat;

----view that returns the total length of films for each category

CREATE VIEW film_length_stat
AS
SELECT 
	name, 
	SUM(length) film_length
FROM film_category
INNER JOIN film USING (category_id)
GROUP BY name;

SELECT * FROM film_length_stat;

--Lets drop view

DROP VIEW film_master;

DROP VIEW comedy_film,horror_film;



-----*************************************************************************************************
----Creating PostgreSQL Updatable Views
A PostgreSQL view is updatable when it meets the following conditions:

1.The defining query of the view must have exactly one entry in the FROM clause, which can be a table or another updatable view.
2.The defining query must not contain one of the following clauses at the top level: GROUP BY, HAVING, LIMIT, OFFSET, DISTINCT, WITH, UNION, INTERSECT, and EXCEPT.
3.The selection list must not contain any window function , any set-returning function, or any aggregate function such as SUM, COUNT, AVG, MIN, and MAX.

example1:

INSERT INTO film_master(film_id, title, language, length,name )
VALUES(7,'Hereditary','English',145,'Horror');

example2:
CREATE VIEW vw_filmlength
AS
	SELECT 
	film_id,title, 
	SUM(length) as film_length
	FROM film
	GROUP BY film_id,title;
	
	INSERT INTO vw_filmlength(film_id,title,film_length)
	VALUES(8,'Galipata','Kannada',130);

---DROP VIEW IF EXISTS vw_filmbylang
CREATE VIEW vw_filmbylang
AS
	SELECT title,language,category_id
	FROM 
		film
	WHERE 
	category_id = 1;
	
	SELECT * FROM vw_filmbylang;

-----Insert into a table using view----
	INSERT INTO vw_filmbylang(title,language,category_id)
	VALUES('Kirik Party','kannada',1);
	
	SELECT * FROM film;
	SELECT * FROM vw_filmbylang;

---DROP VIEW IF EXISTS vw_filmbylang
---view without where condition
	CREATE VIEW vw_filmbylang
	AS
	SELECT title,language,category_id
	FROM 
		film
		;
	
	SELECT * FROM vw_filmbylang;

	INSERT INTO vw_filmbylang(title,language,category_id)
	VALUES('Hungama','Hindi',1);

---DROP VIEW IF EXISTS vw_filmbylang
	CREATE VIEW vw_filmbylang
	AS
	SELECT title,language
	FROM 
		film
	WHERE 
	category_id = 1
	;
	
	INSERT INTO vw_filmbylang(title,language)
	VALUES('The hangover','English');
	
	UPDATE vw_filmbylang
	SET language = 'Kannada'
	WHERE title = 'The hangover'
	
	SELECT * FROM vw_filmbylang;
	
	SELECT * FROM film;
	
	UPDATE film 
	SET category_id = 1
	WHERE title = 'The hangover';
	
	
					
-----Finally, delete the inserted row using view------
	
	DELETE FROM vw_filmbylang
	WHERE title = 'The hangover';
	
	DELETE FROM vw_filmbylang;
	
	DROP view vw_filmbylang
----******************************************************************************************	

--Materialiized view
A materialized view is a database object. It is created over an SQL query similar to a view.
It does two things:
1. It will store the query used to create a mv.
2. It will store the result/data returned from the mv.

---	DROP MATERIALIZED VIEW IF EXISTS vw_filmbylang
	CREATE  MATERIALIZED VIEW vw_filmbylang
AS
SELECT 
	film_id, 
	title, 
	language, 
	length 	
FROM 
	film
WITH NO DATA;

SELECT * FROM vw_filmbylang;

REFRESH MATERIALIZED VIEW vw_filmbylang;

INSERT INTO vw_filmbylang(film_id, 
	title, 
	language, 
	length 
 )
 VALUES (10,'Leo','English',145)
 
 INSERT INTO film(title,language,length,release_year,category_id)
	VALUES
	('Leo','English',145,'2013-12-21',1)
 
 SELECT * FROM film;

--CREATE UNIQUE INDEX filmbylang ON vw_filmbylang (film_id);

--REFRESH MATERIALIZED VIEW CONCURRENTLY vw_filmbylang;

Example:

CREATE TABLE random_tab(
id integer,
value decimal
);

INSERT INTO random_tab(id,value)
VALUES
(1,random() from generate_series(1,10000000))

INSERT INTO random_tab(id,value)
select 1,random() from generate_series(1,10000000)----1min 13sec

INSERT INTO random_tab(id,value)
select 2,random() from generate_series(1,10000000)

SELECT count(1)
FROM random_tab;

SELECT id,avg(value),count(*)
FROM random_tab
GROUP BY id;

CREATE MATERIALIZED VIEW mv_random_tab
AS
SELECT id,avg(value),count(*)
FROM random_tab
GROUP BY id;

SELECT * FROM mv_random_tab;

DELETE FROM random_tab
WHERE id = 1;

CREATE VIEW vw_random_tab
AS
SELECT id,avg(value),count(*)
FROM random_tab
GROUP BY id;

SELECT * FROM vw_random_tab;

---Difference between view and materialzed view
1. View will only store the select statement when created where as materialzed view will store the returned data along with the select staement.
2. mv every time you execute it is only going to return the data that is already stored corresponding to that mv where as every time you are going to execute view it is going to re execute the query that is associated with the view every single time.

DROP MATERIALIZED VIEW view_name;



	

	
	
	
	
	














