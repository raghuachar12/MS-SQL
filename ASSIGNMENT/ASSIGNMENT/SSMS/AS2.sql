--ASSIGNMENT 2 

create table tbl1EmployeeDtlC1
(
employeeid int primary key,
employeename varchar(50) not null,
designation varchar(50) not null,
joiningdate date not null default getdate(),
emailid varchar(25) not null unique,
phoneno varchar(10) not null,
salary int not null check(salary>15000),
departmentid int,
foreign key(departmentid) references tbldepartmentC(DepartmentId)
)
select * from tbl1EmployeeDtlC
insert into tbl1EmployeeDtlC1 values(1010,'Akash','DB','2018/07/02','akash@gmail.com',7813063222,16000,10)
insert into tbl1EmployeeDtlC1 values(1011,'Manju','HR','2019/06/01','manju@gmail.com',9988776432,20000,20)
insert into tbl1EmployeeDtlC1 values(1012,'Ganesh','L&D','2020/03/20','ganeshu@gmail.com',9847676432,25000,30)
insert into tbl1EmployeeDtlC1 values(1013,'Raghveer','Testing','2016/01/04','raghu@gmail.com',6163876432,25000,40)

-------Table-2---tblDeparmentC----

create table tbldepartmentC1
(
DepartmentId int primary key,
DepartmentName varchar(50) not null,
Location varchar(50) not null
)

select * from tbldepartmentC
insert into tbldepartmentC1 values(10,'Hr','Mysuru')
insert into tbldepartmentC1 values(20,'DB','Mysuru')
insert into tbldepartmentC1 values(30,'L&D','Mysuru')
insert into tbldepartmentC1 values(40,'Testing','Shivmogga')

---Table-3-tblSubjectDtl---

create table tblSubjectDtl
(
subjectid int primary key,
SubjectName varchar(50) not null
)
insert into tblSubjectDtl values (10,'SQL') 
insert into tblSubjectDtl values (20,'JAVA')
insert into tblSubjectDtl values (30,'PYTHON')
insert into tblSubjectDtl values (40,'HTML')
select * from  tblSubjectDtl

--TABLE-4--tblStudentDtl----

create table tblStudentDtl
(
Studentid int primary key,
SubjectName varchar(50) not null,
)
EXEC sp_rename 'tblStudentDtl.SubjectName','Studentname'
select * from tblStudentDtl
insert into  tblStudentDtl values(10,'SQL')
insert into  tblStudentDtl values(20,'JAVA')
insert into  tblStudentDtl values (40,'HTML')

--5-Table--tblStudentSubMarks----

create table tblStudentSubMarks
(
studentid int,
Subjectid varchar(50),
marks Decimal not null,
Primary key(studentid,Subjectid),
Foreign key(studentid) references tblStudentDtl (studentid),
)

insert into tblStudentSubMarks values(10,01,70.5)
insert into tblStudentSubMarks values(20,02,75)

select * from tbl1EmployeeDtlC1 
select * from tblDepartmentC1
select * from tblSubjectDtl
select * from tblStudentDtl 
select * from tblStudentSubMarks