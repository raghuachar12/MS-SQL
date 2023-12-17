---PostgreSQL Triggers
/*
A PostgreSQL trigger is a function invoked automatically whenever an event associated with a table occurs. 
An event could be any of the following: INSERT, UPDATE, DELETE or TRUNCATE. 
A trigger is a special user-defined function associated with a table. 
To create a new trigger, you define a trigger function first, and then bind this trigger function to a table.
The difference between a trigger and a user-defined function is that a trigger is automatically invoked when a triggering event occurs.
*/

---PostgreSQL trigger types
PostgreSQL provides two main types of triggers:

1. Row-level triggers
2. Statement-level triggers.

The differences between the two kinds are how many times the trigger is invoked and at what time.
For example, if you issue an UPDATE statement that modifies 20 rows, the row-level trigger will be invoked 20 times, while the statement-level trigger will be invoked 1 time.


---When to use triggers
1. Triggers are useful in case the database is accessed by various applications, and you want to keep the cross-functionality within the database that runs automatically whenever the data of the table is modified.
2. you can use triggers to maintain complex data integrity rules which cannot implement elsewhere except at the database level. 

Lets learn how to:
	1. Create trigger
	2. Drop trigger
	3. Alter trigger
	4. Enable trigger
	5. Disable trigger
	
	
---CREATE TRIGGER
	A trigger function is similar to a regular user-defined function. However, a trigger function does not take any arguments and has a return value with the type trigger.

--The following illustrates the syntax of creating trigger function and creating trigger 

CREATE FUNCTION trigger_function() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
BEGIN
   -- trigger logic
END;
$$

CREATE TRIGGER trigger_name 
   {BEFORE | AFTER} { event }
   ON table_name
   [FOR [EACH] { ROW | STATEMENT }]
       EXECUTE PROCEDURE trigger_function
	   
--Example:

DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
   id INT GENERATED ALWAYS AS IDENTITY,
   first_name VARCHAR(40) NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   PRIMARY KEY(id)
);

INSERT INTO employees (first_name, last_name)
VALUES ('John', 'Doe');

INSERT INTO employees (first_name, last_name)
VALUES ('Lily', 'Bush');

INSERT INTO employees (first_name, last_name)
VALUES ('Kumar', 'Mishra');

INSERT INTO employees (first_name, last_name)
VALUES ('Kumar', 'Mishra');

INSERT INTO employees (first_name, last_name)
VALUES ('Dilip', 'Acharya'),
('Tilak', 'Arya'),
('Anuj', 'Kapoor');

SELECT * FROM employees;

/*
Suppose that when the name of an employee changes, you want to log the changes in a separate table called employee_audits 
*/
DROP TABLE IF EXISTS employee_audits;
CREATE TABLE employee_audits (
   id INT GENERATED ALWAYS AS IDENTITY,
   employee_id INT NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   changed_on TIMESTAMP(6) NOT NULL
);

/*
First, create a new function called log_last_name_changes:
*/

CREATE OR REPLACE FUNCTION log_last_name_changes()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.last_name <> OLD.last_name THEN
		 INSERT INTO employee_audits(employee_id,last_name,changed_on)
		 VALUES(OLD.id,OLD.last_name,now());
	END IF;

	RETURN NEW;
END;
$$

---Create Trigger
CREATE TRIGGER last_name_changes
  BEFORE UPDATE
  ON employees
  FOR EACH ROW
  EXECUTE PROCEDURE log_last_name_changes();
  
 
---Suppose that Lily Bush changes her last name to Lily Brown.

UPDATE employees
SET last_name = 'Brown'
WHERE ID = 2;

SELECT * FROM employees;

SELECT * FROM employee_audits;

-----------------------------------------------------------------------------------------------------------------------------

----DROP TRIGGER
To delete a trigger from a table, you use the DROP TRIGGER statement with the following syntax:

DROP TRIGGER [IF EXISTS] trigger_name 
ON table_name [ CASCADE | RESTRICT ];

By default, the DROP TRIGGER statement uses RESTRICT;

--Example:

CREATE TABLE staff(
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
	username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO staff(staff_id,first_name,last_name,username,email)
VALUES 
(1,'Rahul','Jain','rahuljain','rahuljain@gamil.com'),
(2,'Nigam','Arora','nigamarora','nihamarora@gamil.com'),
(3,'Ahan','Kapoor','ahankapoor','ahankapoor@gamil.com'),
(4,'Arya','Malik','aryamalik','aryamalik@gamil.com'),
(5,'Kumud','Khurana','kumudkhurana','kumudkhurana@gamil.com'),
(6,'Kamakshi','Vijay','kamakshivijay','kamakshivijay@gamil.com'),
(7,'Arundhati','Varma','arundhativarma','arundhativarma@gamil.com');


SELECT * FROM staff;


CREATE FUNCTION check_staff_user()
    RETURNS TRIGGER
AS $$
BEGIN
    IF length(NEW.username) < 8 OR NEW.username IS NULL THEN
        RAISE EXCEPTION 'The username cannot be less than 8 characters';
    END IF;
	
    IF NEW.first_name IS NULL THEN
        RAISE EXCEPTION 'Username cannot be NULL';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER username_check 
    BEFORE INSERT OR UPDATE
ON staff
FOR EACH ROW 
    EXECUTE PROCEDURE check_staff_user();
	
	
INSERT INTO staff(staff_id,first_name,last_name,username,email)
VALUES 
(8,'abc','def','abcdef','abcdef@gamil.com');

INSERT INTO staff(staff_id,first_name,last_name,username,email)
VALUES 
(9,null,'def','abcdefgh','abcdefgh@gamil.com');
	
	
DROP TRIGGER username_check
ON staff;

----------------------------------------------------------------------------------------------------------------------------------

----ALTER TRIGGER
The ALTER TRIGGER statement allows you to rename a trigger. The following shows the syntax of the ALTER TRIGGER statement:

ALTER TRIGGER trigger_name
ON table_name 
RENAME TO new_trigger_name;

---Example:

DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
   employee_id INT GENERATED ALWAYS AS IDENTITY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   salary decimal(11,2) not null default 0,
   PRIMARY KEY(employee_id)
);

INSERT INTO employees(first_name, last_name, salary)
VALUES('John','Doe',100000);

SELECT * FROM employees;

CREATE OR REPLACE FUNCTION check_salary()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL  
  AS
$$
BEGIN
	IF (NEW.salary - OLD.salary) / OLD.salary >= 1 THEN
		RAISE 'The salary increment cannot that high.';
	END IF;

	RETURN NEW;
END;
$$

CREATE TRIGGER before_update_salary
  BEFORE UPDATE
  ON employees
  FOR EACH ROW
  EXECUTE PROCEDURE check_salary();
  
UPDATE employees
SET salary = 200000
WHERE employee_id = 1;


Finally, use the ALTER TRIGGER statement to rename the before_update_salary trigger to salary_before_update:

ALTER TRIGGER before_update_salary
ON employees
RENAME TO salary_before_update;

-----------------------------------------------------------------------------------------------------------------------
---Replacing triggers
PostgreSQL doesn’t support the OR REPLACE statement that allows you to modify the trigger definition like the function that will be executed when the trigger is fired.

In order to do so, you can use the DROP TRIGGER and CREATE TRIGGER statements. You can also wrap these statements in a transaction.

----------------------------------------------------------------------------------------------------------------------------

---Disable Triggers
To disable a trigger, you use the ALTER TABLE DISABLE TRIGGER statement:

ALTER TABLE table_name
DISABLE TRIGGER trigger_name | ALL

ALTER TABLE employees
DISABLE TRIGGER log_last_name_changes;

ALTER TABLE employees
DISABLE TRIGGER ALL;

SELECT * FROM employees;

UPDATE employees
SET last_name = 'Kumar'
WHERE ID = 7;

SELECT * FROM SELECT * FROM employee_audits;


----------------------------------------------------------------------------------------------------------------------------

---Enable Trigger
To enable a trigger or all triggers associated with a table, you use the ALTER TABLE ENABLE TRIGGER statement:

ALTER TABLE table_name
ENABLE TRIGGER trigger_name |  ALL;

ALTER TABLE employees
ENABLE TRIGGER salary_before_update;

SELECT * FROM employees;

UPDATE employees
SET last_name = 'Kumar'
WHERE ID = 7;

SELECT * FROM SELECT * FROM employee_audits;

ALTER TABLE employees
ENABLE TRIGGER ALL;

------------------------------------------------------------------------------------------------------------------------------





























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































..............................................................................................................................................................................................................................................................................................................000


