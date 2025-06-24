--CREATE DATABASE CompanyDB

USE CompanyDB

CREATE TABLE Employee(
SSN INT PRIMARY KEY IDENTITY(1,1),
Fname NVARCHAR(20),
Lname NVARCHAR(20),
gender CHAR(1) CHECK(gender IN ('M','F')),
birthDate Date,
supervisor INT FOREIGN KEY REFERENCES Employee(SSN) 
)

CREATE TABLE Department(
Dnum INT PRIMARY KEY IDENTITY (1,1),
Dname NVARCHAR(30),
ManagerSSN INT FOREIGN KEY REFERENCES Employee(SSN),
hiringDate Date,
)

CREATE TABLE DEP_LOC(
Dnum INT FOREIGN KEY (Dnum) REFERENCES Department(Dnum),
loc NVARCHAR(50),
PRIMARY KEY(Dnum,loc)
)

CREATE TABLE Project(
projectID INT PRIMARY KEY IDENTITY(1,1),
projactName NVARCHAR(40),
loc NVARCHAR(50),
city NVARCHAR(30),
depNum INT FOREIGN KEY REFERENCES Department(Dnum)
)

CREATE TABLE Emp_Project(
SSN INT FOREIGN KEY REFERENCES Employee(SSN),
projectNum INT FOREIGN KEY REFERENCES Project(projectID),
workingHours INT,
PRIMARY KEY(SSN, projectNum)
)

CREATE TABLE Dependents(
dependentNum INT PRIMARY KEY IDENTITY(1,1),
birthDate Date,
gender CHAR(1) CHECK(gender IN ('M','F')),
ssn INT FOREIGN KEY REFERENCES Employee(SSN)
)

ALTER TABLE Employee
ADD DepNum INT

ALTER TABLE Employee
ADD CONSTRAINT FK_Emp_Dep FOREIGN KEY (DepNum) REFERENCES Department(Dnum)

INSERT INTO Employee( Fname,Lname,gender,birthDate,supervisor) VALUES
('Ali', 'Al-Balushi', 'M', '1990-03-12', NULL),
('Fatma', 'Al-Zahra', 'F', '1988-07-22', 1),
('Hassan', 'Al-Harthy', 'M', '1995-11-05', 1),
('Salma', 'Al-Mandhari', 'F', '1992-04-30', 2),
('Omar', 'Al-Lawati', 'M', '1987-09-18', 1),
('Laila', 'Al-Muqbali', 'F', '1993-02-14', 3),
('Khalid', 'Al-Hinai', 'M', '1991-01-09', 2);

INSERT INTO Department(Dname, ManagerSSN,hiringDate) VALUES
('Human Resources', 1, '2015-06-01'),
('Finance', 2, '2016-09-15'),
('IT', 3, '2017-03-20'),
('Marketing', 4, '2018-01-10'),
('Logistics', 5, '2019-11-05');

INSERT INTO DEP_LOC(Dnum, loc) VALUES
(1, 'Muscat'),
(1, 'Sohar'),
(2, 'Muscat'),
(3, 'Salalah'),
(3, 'Nizwa'),
(4, 'Ibri'),
(5, 'Sur');

INSERT INTO Project(projactName,loc,city,depNum) VALUES
('ERP System Upgrade', 'IT Office 3A', 'Muscat', 3),
('New HR Portal', 'Main Building', 'Muscat', 1),
('Financial Audit 2025', 'Finance Wing', 'Sohar', 2),
('Marketing Campaign Q3', 'Marketing Hub', 'Salalah', 4),
('Warehouse Expansion', 'Logistics Center', 'Nizwa', 5),
('Recruitment Drive', 'Training Room B1', 'Ibri', 1);

INSERT INTO Emp_Project(SSN,projectNum,workingHours) VALUES
(1, 1, 20),
(2, 1, 15),
(3, 2, 25),
(4, 3, 18),
(5, 4, 30),
(6, 5, 12),
(7, 6, 10),
(1, 2, 10),
(3, 3, 8),
(2, 4, 16);

INSERT INTO Dependents(birthDate,gender,ssn) VALUES
('2010-06-15', 'F', 1),
('2015-03-22', 'M', 1),
('2012-09-05', 'F', 2),
('2016-12-10', 'M', 3),
('2018-01-20', 'F', 4),
('2014-11-11', 'M', 5),
('2020-07-30', 'F', 6),
('2011-04-09', 'M', 7);

SELECT * FROM Employee

SELECT * FROM Department

SELECT * FROM DEP_LOC

SELECT * FROM Project

SELECT * FROM Emp_Project

SELECT * FROM Dependents

UPDATE Employee SET depNum = 1 WHERE SSN = 1;

UPDATE Employee SET depNum = 2 WHERE SSN = 2;

UPDATE Employee SET depNum = 3 WHERE SSN = 3;

UPDATE Employee SET depNum = 4 WHERE SSN = 4;

UPDATE Employee SET depNum = 5 WHERE SSN = 5;

UPDATE Employee SET depNum = 3 WHERE SSN = 6;

UPDATE Employee SET depNum = 2 WHERE SSN = 7;