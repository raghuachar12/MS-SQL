--ASSIGNMENT 5 
CREATE TABLE PATIENT(
PID INT PRIMARY KEY,
PNAME VARCHAR(20),
CITY VARCHAR(20))

CREATE TABLE DOCTOR(
DID INT PRIMARY KEY,
DNAME VARCHAR(20),
DEPT VARCHAR(20),
SALARY INT)

CREATE TABLE CONSULTATION (
CONID INT PRIMARY KEY,
PID INT FOREIGN KEY (PID) REFERENCES PATIENT (PID),
DID INT FOREIGN KEY (DID) REFERENCES DOCTOR (DID),
FEE INT )

USE hospital

SELECT * FROM PATIENT

SELECT * FROM DOCTOR

SELECT * FROM CONSULTATION

---1--
--Identify the consultation details of patients with the letter ‘e’ anywhere in their name, who 
--have consulted a cardiologist. Write a SQL query to display doctor’s name and patient’s 
--name for the identified consultation details. 

SELECT PNAME,DNAME,CONID FROM PATIENT JOIN CONSULTATION 
ON PATIENT.PID = CONSULTATION.PID JOIN DOCTOR 
ON CONSULTATION.DID = DOCTOR.DID
WHERE PATIENT.PNAME LIKE '%E%'

---2--
--Identify the doctors who have provided consultation to patients from the cities ‘Boston’ 
--and ‘Chicago’. Write a SQL query to display department and number of patients as 
--PATIENTS who consulted the identified doctor(s). 

SELECT CONSULTATION.DID
FROM PATIENT  JOIN CONSULTATION ON PATIENT.PID = CONSULTATION.PID
JOIN DOCTOR ON CONSULTATION.DID = DOCTOR.DID 

GROUP BY CITY 
HAVING CITY IN ('BOSTON','CHICAGO')

--3--
--Identify the cardiologist(s) who have provided consultation to more than one patient. 
--Write a SQL query to display doctor’s id and doctor’s name for the identified 
--cardiologists. 

SELECT DOCTOR.DID,DOCTOR.DNAME
FROM PATIENT JOIN CONSULTATION ON PATIENT.PID = CONSULTATION.PID
JOIN DOCTOR ON CONSULTATION.DID = DOCTOR.DID 
WHERE DOCTOR.DEPT = 'CARDIO'
GROUP BY DOCTOR.DID,DOCTOR.DNAME
HAVING COUNT(*)>1

--4--
--Write a SQL query to combine the results of the following two reports into a single report. 
--The query result should NOT contain duplicate records. 

--Report 1 – Display doctor’s id of all cardiologists who have been consulted by 
--patients. 

--Report 2 – Display doctor’s id of all doctors whose total consultation fee charged 
--in the portal is more than INR 800. 

SELECT DOCTOR.DID ,COUNT(PATIENT.PID) PATIENT_COUNT
FROM PATIENT JOIN CONSULTATION ON PATIENT.PID = CONSULTATION.PID
JOIN DOCTOR ON CONSULTATION.DID = DOCTOR.DID 
WHERE DOCTOR.DEPT = 'CARDIO'
GROUP BY DOCTOR.DID,DOCTOR.DNAME

SELECT DOCTOR.DID, DOCTOR.DNAME,CONSULTATION.FEE
FROM  DOCTOR JOIN CONSULTATION ON DOCTOR.DID = CONSULTATION.DID
WHERE CONSULTATION.FEE > 800

--5--
--Write a SQL query to combine the results of the following two reports into a single report. 
--The query result should NOT contain duplicate records. 

--Report 1 – Display patient’s id belonging to ‘New York’ city who have consulted 
--with the doctor(s) through the portal. 

--Report 2 – Display patient’s id who have consulted with doctors other than 
--cardiologists and have paid a total consultation fee less than INR 1000. 


SELECT PATIENT.PID ,DOCTOR.DID,PATIENT.CITY
FROM PATIENT JOIN CONSULTATION 
ON PATIENT.PID = CONSULTATION.PID JOIN DOCTOR ON DOCTOR.DID = CONSULTATION.DID
WHERE CITY = 'NEW YORK CITY'

SELECT DOCTOR.DID,CONSULTATION.FEE,PATIENT.PID 
FROM  DOCTOR JOIN CONSULTATION ON DOCTOR.DID = CONSULTATION.DID JOIN PATIENT ON PATIENT.PID =  CONSULTATION.PID
WHERE CONSULTATION.FEE > 800 AND DOCTOR.DEPT <> 'CARDIO'