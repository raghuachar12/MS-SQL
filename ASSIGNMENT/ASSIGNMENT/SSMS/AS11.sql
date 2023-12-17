
--ASSIGNMENT 11 --

CREATE TABLE theater_dtls(

Th_id INT PRIMARY KEY IDENTITY(1,1),
Th_name varchar(20),
Location varchar(20))

CREATE TABLE show_dtls(
show_id INT PRIMARY KEY ,
Th_id int references theater_dtls(Th_id),
show_date date,
show_time time,
movie_name varchar(20),
ticket_cost int,
ticket_avilable int )

CREATE TABLE user_dtls(
user_id INT PRIMARY KEY,
user_name varchar(15),
password varchar(15),
age int ,
gender char,
email_id varchar(15),
phone_no bigint)

CREATE TABLE booking_dtls(
booking_id INT PRIMARY KEY,
user_id INT references user_dtls(user_id),
show_id INT references show_dtls(show_id),
number_of_ticket INT ,
total_amt INT )

SELECT * FROM theater_dtls
SELECT * FROM show_dtls
SELECT * FROM user_dtls
SELECT * FROM booking_dtls


-----Q1 

alter PROCEDURE USP_PR1(
@userid int,@showid int,@no_of_ticket int)
AS 
BEGIN 
IF(@userid IN (SELECT user_id FROM user_dtls ))
	IF(@showid IN (SELECT show_id FROM show_dtls))
		IF(@no_of_ticket in (SELECT number_of_ticket FROM booking_dtls  ) )
		BEGIN
		declare @total int
		set @total  = @no_of_ticket * (select ticket_cost from show_dtls where show_id =@showid)
		INSERT INTO booking_dtls values (21,@userid,@showid,@no_of_ticket,@total)
		UPDATE show_dtls SET ticket_avilable=ticket_avilable-@no_of_ticket
						WHERE show_id=@ShowID
		END
		ELSE RETURN -1 
	ELSE RETURN -2
ELSE RETURN -3

END 

exec USP_PR1 @userid=3,@showid=1,@no_of_ticket=4

select * from booking_dtls

--------Q2 

CREATE FUNCTION UDF_gtemovie
(@movie_name varchar(10),@loc varchar(10))
RETURNS @Moviedtl TABLE
(movie_name VARCHAR(10),show_date DATE,show_id INT)
as 
begin
	INSERT INTO @Moviedtl 
	SELECT sd.movie_name,sd.show_date,sd.show_id

	FROM theater_dtls th join show_dtls sd 
	on th.Th_id = sd.Th_id join booking_dtls bd 
	on bd.show_id = sd.show_id join user_dtls ud on bd.user_id = ud.user_id
	where sd.movie_name = @movie_name or th.Location =@loc
	return 
end 

select * from dbo.UDF_gtemovie('spiderman' ,'mys')

----------------------------- ------