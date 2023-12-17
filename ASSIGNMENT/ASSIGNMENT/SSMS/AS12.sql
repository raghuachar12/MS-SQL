
--ASSIGNMENT 12 -- 

--1.Each department has only five Subjects 
--2.Some subjects can be a common subject between the departments 
--3.Student can take test/assessment on the subjects as per his department 
--4.Student can attempt only once in each subject 
--5.The Pass marks is variable, a student must pass in all subjects  to Pass 
--6.Grades are based on the percentage of scores, those above 79% would be graded as distinction 
--Those with 60 and above percentage would be graded as first class and those who score above 
--50% are graded as second class, the remaining are classified as Just passed 
--Grades are awarded only to those who pass in all subjects 

CREATE TABLE tblDepartment
(
	DepartmentId INT PRIMARY KEY,
	DepartmentName VARCHAR(50)
)

CREATE TABLE tblSubjects
(	
	SubId INT PRIMARY KEY,
	Subject VARCHAR(50)
)

CREATE TABLE tblDepartmentSubjects
(
	SlNo INT PRIMARY KEY,
	DepartmentId INT
		FOREIGN KEY REFERENCES tblDepartment(DepartmentID),
	SubId INT 
		FOREIGN KEY REFERENCES tblSubjects(SubId)
)

CREATE TABLE tblStudentMaster
(
	ID INT PRIMARY KEY,
	Name VARCHAR(50),
	DateOfJoin DATE,
	DepartMent INT 
		FOREIGN KEY REFERENCES tblDepartment(DepartmentID)
)
DROP TABLE 




INSERT INTO tblDepartment
VALUES
(1,'CSE'),(2,'ECE'),(3,'ME'),(4,'IS')

INSERT INTO tblSubjects
VALUES
(1001,'C Program'),
(1002,'Python'),
(1003,'Computer Networks'),
(1004,'DBMS'),
(1005,'Web Technology'),
(1006,'Data Mining'),
(1007,'Big Data Analytics'),
(1008,'Arduino Programming'),
(1009,'Digital Electronics'),
(1010,'Computer Fundamentals'),
(1011,'Basic Electronics'),
(1012,'Thermodynamics'),
(1013,'Kinametics'),
(1014,'Dynametics'),
(1015,'MOM')

INSERT INTO tblDepartmentSubjects
VALUES
(1,1,1001),(2,1,1002),(3,1,1003),(4,1,1004),(5,1,1005),
(6,4,1006),(7,4,1007),(8,4,1001),(9,4,1002),(10,4,1005),
(11,3,1012),(12,3,1013),(13,3,1014),(14,3,1015),(15,3,1001),
(16,2,1008),(17,2,1009),(18,2,1010),(19,2,1011),(20,2,1001)




CREATE TABLE tblMarks
(
	Id INT IDENTITY(1,1),
	StudentID INT FOREIGN KEY REFERENCES tblStudentMaster(ID),
	SubjectID INT
		FOREIGN KEY REFERENCES tblSubjects(SubId),
	DoE DATE,
	Scores INT,
	CONSTRAINT Pk_stusub PRIMARY KEY(StudentId,SubjectId)
)


INSERT INTO tblMarks
(StudentID,SubjectID,DoE,Scores)
VALUES
(101,1002,'11-19-2023',70),
(101,1003,'11-19-2023',20),
(101,1004,'11-19-2023',30),

(102,1008,'11-19-2023',70),
(102,1009,'11-19-2023',40),
(102,1010,'11-19-2023',30),
(102,1001,'11-19-2023',30),

(103,1012,'11-19-2023',70),
(103,1013,'11-19-2023',40),
(103,1015,'11-19-2023',30),
(103,1001,'11-19-2023',30)


INSERT INTO tblStudentMaster
VALUES
(101,'Sathish','05-15-2020',1),
(102,'Balraju','10-5-2020',2),
(103,'Chethan','1-15-2020',3)


SELECT * FROM tblDepartment 

SELECT * FROM tblSubjects

SELECT * FROM tblDepartmentSubjects

SELECT * FROM tblStudentMaster


ALTER FUNCTION dbo.GetStudentResultsByDepartment
(
    @DepartmentId INT,
    @PassMarks INT
)
RETURNS @Results TABLE
(
    StudentId INT,
    Name NVARCHAR(50),
    TotalMarks INT,
    Percentage DECIMAL(5, 2),
    SubjectsPassed INT,
    SubjectsAttempted INT,
    Result NVARCHAR(10),
    Grade NVARCHAR(15)
)
AS
BEGIN
    INSERT INTO @Results
    SELECT
        sm.Id AS StudentId,
        sm.Name,
        ISNULL(SUM(m.Scores), 0) AS TotalMarks,
        ISNULL(CONVERT(DECIMAL(5, 2), AVG(m.Scores)), 0) AS Percentage,
        ISNULL(SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END), 0) AS SubjectsPassed,
        COUNT(m.SubjectId) AS SubjectsAttempted,
        CASE
            WHEN COUNT(m.SubjectId) = SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END) THEN 'FAIL'
            ELSE 'PASS'
        END AS Result,
        CASE
            WHEN COUNT(m.SubjectId) = SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END) AND AVG(m.Scores) >= 80 THEN 'Distinction'
            WHEN COUNT(m.SubjectId) = SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END) AND AVG(m.Scores) >= 60 THEN 'First Class'
            WHEN COUNT(m.SubjectId) = SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END) AND AVG(m.Scores) >= 50 THEN 'Second Class'
		    WHEN COUNT(m.SubjectId) = SUM(CASE WHEN m.Scores >= @PassMarks THEN 1 ELSE 0 END) AND AVG(m.Scores) >= 40 THEN 'Pass Class'
            ELSE 'Just Passed'
        END AS Grade
    FROM
        tblStudentMaster sm
    LEFT JOIN
        tblMarks m ON sm.Id = m.StudentId
    WHERE
        sm.Department = @DepartmentId
    GROUP BY
        sm.Id, sm.Name;

    RETURN;
END


 SELECT * FROM DBO.GetStudentResultsByDepartment (1,40)
 

