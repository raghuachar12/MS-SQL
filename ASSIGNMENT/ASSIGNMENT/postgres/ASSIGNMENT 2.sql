select * from tblactor

select * from tbldirector

select * from tblmovies 

--1.List the different languages of movies. 
 
 SELECT DISTINCT movie_lang 
 from tblmovies 
 
--2.Display the unique first names of all directors in ascending order by 
--their first name and then for each group of duplicates, keep the first row in the 
--returned result set. 

SELECT DISTINCT first_name
FROM tbldirector
ORDER BY first_name  
 
 select * from tbldirector
--3. write a query to retrieve 4 records starting from the fourth one, to 
--display the actor ID, name (first_name, last_name) and date of birth, and 
--arrange the result as Bottom N rows from the actors table according to their 
--date of birth.   

SELECT actor_id,CONCAT(fname,lname)
FROM tblactor 
ORDER BY dob desc 
OFFSET 3
LIMIT 4

--4.Write a query to get the first names of the directors who holds the letter 
--'S' or 'J' in the first name.     

SELECT fname 
FROM tblactor 
WHERE fname LIKE '%S%' OR fname LIKE '%J%'
 
--5.Write a query to find the movie name and language of the movie of all 
--the movies where the director name is Joshna. 

SELECT movie_name , movie_lang 
FROM  tblmovies m1  join tbldirector d  
ON m1.dir_id = d.dir_id
WHERE first_name='JOSH'

--6 Write a query to find the number of directors available in the movies table. 

SELECT COUNT(dir_id)
FROM tblmovies

--7 Write a query to find the total length of the movies available in the 
--movies table. 

SELECT SUM(movie_length)
FROM tblmovies

--8Write a query to get the average of movie length for all the directors 
--who are working for more than 1 movie. 

SELECT * AVG(movie_length),dir_id
FROM tblmovies
GROUP BY dir_id
--HAVING COUNT(movie_id)>1

--9 Write a query to find the age of the actor vijay for the year 2001-04-10. 

SELECT AGE('2001-04-10',dob) from tblactor
WHERE fname = 'VIJAY'

--10 Write a query to fetch the week of this release date 2020-10-10 
--13:00:10. 

SELECT EXTRACT(WEEK FROM  TIMESTAMP '2020-10-10') AS WEEK 

--11-Write a query to fetch the day of the week and year for this release date 
2020-10-10 13:00:10.        

SELECT TO_CHAR(TIMESTAMP '2020-10-10','DAY'),EXTRACT(YEAR FROM TIMESTAMP '2020-10-10')

--12
--Write a query to convert the given string '20201114' into date and time.

SELECT CAST('20201114' AS DATE)

--13 TIMESTAMP

SELECT(CURRENT_DATE)

--14 Display Today's date with time. 

SELECT(now())

--15 Write a query to add 10 Days 1 Hour 15 Minutes to the current date. 

SELECT CURRENT_TIMESTAMP + INTERVAL '10 Days 1 Hour 15 Minutes' AS NEW_TIME

--16 Write a query to find the details of those actors who contain eight or 
--more characters in their first name.

SELECT fname 
FROM tblactor 
WHERE LENGTH(fname) > 8 

--17 Write a query to join the text 'movie' with the movie_name column. 

SELECT CONCAT(' MOVIE_ ',movie_name) FROM  tblmovies

--18Write a query to get the actor id, first name and birthday month of an 
--actor.

SELECT actor_id, fname, EXTRACT(MONTH FROM dob) 
FROM tblactor
order by actor_id
SELECT EXTRACT (HOUR FROM CURRENT_TIME)
--19 Write a query to get the actor id, last name to discard the last three 
--characters. 

SELECT actor_id, LEFT(lname, LENGTH(lname) - 3) 
FROM tblactor;
 
--20 Write a query that displays the first name and the character length of 
--the first name for all directors whose name starts with the letters 'A', 'J' or 'V'. 
---Give each column an appropriate label. Sort the results by the directors' first 
--names. 


SELECT fname,LENGTH(fname)
FROM tblactor
WHERE fname ILIKE 'A%' OR fname ILIKE 'J%' OR fname ILIKE 'V%'
ORDER BY fname


--21.Write a query to display the first word in the movie name if the movie 
--name contains more than one words. 
   
SELECT
movie_name
FROM tblMovies
where movie_name like'% %'
   
--22 Write a query to display the actors name with movie name. 

SELECT n.fname,m.movie_name 
from tblactor n join tblmovies m 
on n.movie_id = m.movie_id
 
--23 Write a query to make a join with three tables movies, actors, and 
--directors to display the movie name, director name, and actors date of birth. 
 
 SELECT movie_name,first_name,dob
 from tblactor t join tblmovies m 
 ON t.movie_id = m.movie_id
 join tbldirector d
 ON m.dir_id = d.dir_id
 
 --24 Write a query to make a join with two tables directors and movies to 
--display the status of directors who is currently working for the movies above 1 

SELECT m.dir_id,count(movie_id) 
from tbldirector d join tblmovies m
ON d.dir_id = m.dir_id
GROUP BY m.dir_id 
having count(*)>1

--25 Write a query to make a join with two tables movies and actors to get 
--the movie name and number of actors working in each movie. 

SELECT m.movie_name, COUNT(a.actor_id) 
FROM tblmovies m JOIN tblactor a 
ON m.movie_id = a.movie_id
GROUP BY m.movie_name;
 

--26.Write a query to display actor id, actors name (first_name, last_name)  
--and movie name to match ALL records from the movies table with each 
--record from the actors table.     


SELECT a.actor_id, a.fname, a.lname, m.movie_name
FROM tblactor a
CROSS JOIN tblmovies m;

-- 27. Write a query to display the below requirement.   
-- Fetch employee id and first name of who work in a department with the employee's having 
-- ‘u’ in the  last_name. 

SELECT * FROM Employees

select employee_id,first_name,department_id
from employees
where
	last_name ilike '%m%'
	AND
	Department_Id IS NOT NULL;
	
	!= NULL 

-- 28.the employee who is getting highest pay in the specific department. 

select first_name,department_id
from employees 
group by department_id,first_name,salary
having salary=max(salary)

select * from departments
-- 29. the details of different employees who have atleast one person reporting to them.
select * 
from employees
where employee_id in (select manager_id
					from employees )
					

-- 30. the departments which was formed but it does not have employees working in 
-- them currently.   
select D.department_name,e.first_name
from departments d
left join employees e on d.department_id=e.department_id
where e.department_id is null

-------------------------------------------------
select * from tblactor

select * from tbldirector

select * from tblmovies 

create view vw_one as 
select movie_name,movie_id
from tblmovies join tbldirector using (dir_id)

select * from vw_one

insert into vw_one (movie_name,movie_id)values('new',10)

create view vw_two as 
select movie_name,movie_id
from tblmovies --join tbldirector using (dir_id)

insert into vw_two values(10,null, null, null, null, null, 2)

create table sample(
id int ,
name varchar)

create table sample1(
addr varchar,
pincode int)

insert into sample1 (addr,pincode) values ('smg',123456)

create view vw_three as 
select * 
from sample cross join sample1 
-
insert into vw_three values (2)

-------------------------------------------------