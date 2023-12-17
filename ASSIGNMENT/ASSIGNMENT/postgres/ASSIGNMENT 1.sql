select * from tblactor

select * from tbldirector

select * from tblmovies 

--ASSIGNMENT--
--1-Display Movie name, movie language and release date from movies table. --

select m.movie_name,m.movie_lang,m.release_date
from tblmovies m

--2-Display only 'Kannada' movies from movies table. 

select m.movie_name,m.movie_lang,m.release_date
from tblmovies m
where m.movie_lang in ('KANNDA','TAMIL')

--3-Display movies released before 1st Jan 2011. 

select m.movie_name,m.movie_lang,m.release_date
from tblmovies m
where EXTRACT(year from m.release_date)='2023'
and EXTRACT(month from m.release_date)=10

--4-Display Hindi movies with movie duration more than 150 minutes. 


select m.movie_name,m.movie_lang,m.release_date
from tblmovies m
where m.movie_length > 150 and m.movie_lang = 'HINDI'

--5-Display movies of director id 3 or Kannada language.  

select d.dir_id,d.first_name,d.last_name
from tbldirector d 
where d.dir_id = 3

--6-Display movies released in the year 2023. 

select m.movie_name,m.movie_lang,m.release_date
from tblmovies m
where EXTRACT(year from m.release_date)= 2023

--7-Display movies that can be watched below 15 years. 

select m.movie_name,m.movie_lang,m.release_date
from tblmovies m
where m.movie_certifecate = 'B'

--8-Display movies that are released after the year 2015 and directed by directorid 3.

select m.movie_name,m.movie_lang,m.release_date ,m.dir_id 
from tblmovies m 
where EXTRACT(year from m.release_date)>='2022'
and m.dir_id = 3 

--9-Display all other language movies except Hindi language. 

select m.movie_name,m.movie_lang,m.release_date ,m.dir_id 
from tblmovies m 
where m.movie_lang <> 'HINDI'

--10-Display movies whose language name ends with 'u'. 

select m.movie_name,m.movie_lang,m.release_date ,m.dir_id ,m
from tblmovies m
where movie_lang ilike '%l'

--11-Display movies whose language starts with 'm'. 

select m.movie_name,m.movie_lang,m.release_date ,m.dir_id ,m
from tblmovies m
where movie_lang ilike 't%'

--12-Display movies with language name that has only 5 characters. 

select m.movie_name,m.movie_lang,m.release_date ,m.dir_id ,m
from tblmovies m
where movie_lang ilike '_____'

--13-Display the actors who were born before the year 1980. 

select fname ,lname 
from tblactor
where dob <= '1980-12-01'

--14-Display the youngest actor from the actors table.  

--SELECT MAX(dob)
--FROM tblactor

SELECT fname,lname
from tblactor
order by dob desc 
limit 1

select * from tblactor limit 3

--15-Display the oldest actor from the actors table. 

SELECT fname,lname
from tblactor
order by dob  
limit 1

--16-Display all the female actresses whose ages are between 30 and 35. 

select fname 
from tblactor 
where gender = 'F' and 
WHERE Extract('year'from age(current_date,date_of_birth)) --BETWEEN 30 AND 35

--17-Display the actors whose movie ids are in 1 to 5.

SELECT fname,actor_id,movie_id
FROM tblactor
WHERE movie_id in (1,2,3,4,5) 

--18-Display the longest duration movie from movies table.  
select movie_name,max(movie_length)
from tblmovies
group by movie_name
limit 1 

--19-Display the shortest duration movie from movies table. 

select movie_name,min(movie_length)
from tblmovies
group by movie_name
limit 1 

--20-Display the actors whose name starts with vowels.

select fname,lname
from tblactor
where substring(fname,1,1) In ('A','E','I','O','U')

--21-Display all the records from tblactors by sorting the data based on the fist_name in the 
--ascending order and date of birth in the descending order.  */
update tblactor
set fname = 'new ',lname = 'new'
where actor_id = 7

SELECT * 
FROM tblactor
ORDER BY fname,dob desc

--22-Write a query to  return the data related to movies by arranging the data in ascending order 
--based on the movie_id and also fetch the data from the fifth value to the twentieth value. */ 

select *
FROM tblmovies
ORDER by movie_id					
OFFSET 3
LIMIT 6


--END--
--------------------------------------------------------------------------------------------
select * from tblactor

select * from tbldirector

select * from tblmovies 


CREATE VIEW vw_actor
AS 
SELECT fname,lname 
FROM tblactor
WHERE actor_id > 3

SELECT fname 
FROM vw_actor
----------------------------
#tbltemp

SELECT fname,lname,actor_id 
INTO #tbltemp
FROM tblactor

---------------------------

SELECT fname,totalcount FROM (
SELECT fname,lname,actor_id,count(*) as totalcount 
FROM tblactor	
GROUP BY actor_id
) 
AS tblactor

------------------------------

with tblactorr
AS 
(
SELECT fname,actor_id,count(*) as totalcount 
FROM tblactor
GROUP BY actor_id
) 

select fname,actor_id ,totalcount
FROM tblactorr 
WHERE totalcount > 0

-------------------------------

with tblacto
AS 
(
SELECT fname,actor_id
FROM tblactor

) 
Update tblacto set fname = 'new' where actor_id = 1


