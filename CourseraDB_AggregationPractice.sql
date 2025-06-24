CREATE DATABASE Coursera
USE Coursera

CREATE TABLE Instructors ( 
    InstructorID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 
CREATE TABLE Courses ( 
    CourseID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    InstructorID INT, 
    CategoryID INT, 
    Price DECIMAL(6,2), 
    PublishDate DATE, 
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
); 
CREATE TABLE Students ( 
    StudentID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Enrollments ( 
    EnrollmentID INT PRIMARY KEY, 
    StudentID INT, 
    CourseID INT, 
    EnrollDate DATE, 
    CompletionPercent INT, 
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), 
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) 
); 

-- Instructors 
INSERT INTO Instructors VALUES 
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'), 
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21'); 
-- Categories 
INSERT INTO Categories VALUES 
(1, 'Web Development'), 
(2, 'Data Science'), 
(3, 'Business'); 
-- Courses 
INSERT INTO Courses VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'), 
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'), 
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'), 
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01'); 
-- Students 
INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'), 
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'), 
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10'); 
-- Enrollments 
INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5), 
(2, 202, 102, '2023-04-15', 80, 4), 
(3, 203, 101, '2023-04-20', 90, 4), 
(4, 201, 102, '2023-04-22', 50, 3), 
(5, 202, 103, '2023-04-25', 70, 4), 
(6, 203, 104, '2023-04-28', 30, 2), 
(7, 201, 104, '2023-05-01', 60, 3); 

-- ANSWERS =============================================================================================
-- 1. What is the difference between GROUP BY and ORDER BY? 
-- • GROUP BY groups rows for aggregation, while ORDER BY sorts the final result set.
-- 2.	Why do we use HAVING instead of WHERE when filtering aggregate results? 
-- •	HAVING is used to filter aggregated results because WHERE cannot filter after aggregation.
-- 3.	What are common beginner mistakes when writing aggregation queries? 
-- •	A common mistake is using WHERE instead of HAVING to filter aggregated values.
-- 4.	When would you use COUNT(DISTINCT ...), AVG(...), and SUM(...) together? 
-- •	Use COUNT(DISTINCT ...), AVG(...), and SUM(...) together to get different summary insights in one query.
-- 5.	How does GROUP BY affect query performance, and how can indexes help?
--•	GROUP BY can slow performance on large datasets, but indexing the grouped columns can improve speed.
--------------------------------------------------------------------------------------------------------
-- Beginner Level --
-- 1. Count total number of students --
SELECT COUNT(StudentID) FROM Students

-- 2. Count total number of enrollments --
SELECT COUNT(EnrollmentID) FROM Enrollments

-- 3. Find average rating of each course --
SELECT AVG(RATING),CourseID FROM Enrollments
GROUP BY CourseID

-- 4. Total number of courses per instructor --
SELECT COUNT(CourseID),  InstructorID FROM Courses
GROUP BY InstructorID

-- 5. Number of courses in each category --
SELECT COUNT(CourseID),  CategoryID FROM Courses
GROUP BY CategoryID

-- 6. Number of students enrolled in each course --
SELECT COUNT(StudentID),CourseID FROM Enrollments
GROUP BY CourseID

-- 7. Average course price per category --
SELECT AVG(Price),CategoryID FROM Courses
GROUP BY CategoryID

-- 8. Maximum course price --
SELECT MAX(Price) FROM Courses

-- 9. Min, Max, and Avg rating per course --
SELECT MIN(Rating)AS MINRating,MAX(Rating)AS MaxRating,AVG(Rating) AS AVG_Rating, CourseID FROM Enrollments
GROUP by CourseID

-- 10. Count how many students gave rating = 5 --
SELECT COUNT(Rating), StudentID FROM Enrollments
WHERE Rating = 5 
GROUP BY StudentID

--------------------------------------------------------------------------------------------------------
-- Intermediate Level --
-- 1. Average completion percent per course --
SELECT AVG(CompletionPercent) AS CompletionPercent, CourseID FROM Enrollments
GROUP BY CourseID

-- 2. Find students enrolled in more than 1 course --
SELECT StudentID FROM Enrollments
GROUP BY StudentID
HAVING COUNT(CourseID) > 1

-- 3. Calculate revenue per course (price * enrollments) --
SELECT C.CourseID, COUNT(EnrollmentID) AS Total_Enrolments, Price, COUNT(EnrollmentID)*Price AS Revenue
FROM Enrollments E, Courses C
WHERE E.CourseID = C.CourseID
GROUP BY Price,C.CourseID

-- 4. List instructor name + distinct student count --
SELECT FullName, COUNT(E.StudentID) AS Students_Count
FROM Enrollments E, Instructors I, Courses C
WHERE I.InstructorID = C.InstructorID AND E.CourseID = C.CourseID
GROUP BY FullName

-- 5. Average enrollments per category --
SELECT CategoryName,COUNT(EnrollmentID) AS All_Enrollments, COUNT(EnrollmentID) / COUNT( DISTINCT C.CourseID) AS AVG_Enrollments
FROM Categories Ct, Courses C, Enrollments E
WHERE Ct.CategoryID = C.CategoryID AND C.CourseID = E.CourseID
GROUP BY CategoryName

-- 6. Average course rating by instructor --
SELECT FullName AS Instructor_Name, AVG(CAST(Rating AS Decimal)) AS AVG_Rating
FROM Instructors I, Courses C, Enrollments E
WHERE I.InstructorID = C.InstructorID AND C.CourseID = E.CourseID
GROUP BY FullName

-- 7. Top 3 courses by enrollment count --
SELECT TOP 3 CourseID, COUNT(CourseID) AS Enrollments_Count
FROM Enrollments
GROUP BY CourseID
ORDER BY Enrollments_Count DESC

-- 8. Average days students take to complete 100% (use mock logic) --
SELECT AVG(DATEDIFF(DAY, S.JoinDate , E.EnrollDate)) AS AvgCompletionDays
FROM Students S, Enrollments E
WHERE S.StudentID = E.StudentID AND E.CompletionPercent  >= 90

-- 9. Percentage of students who completed each course --
SELECT 
    CourseID, CAST(SUM(CASE WHEN CompletionPercent = 100 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS CompletionPercentage
FROM Enrollments
GROUP BY CourseID;

-- 10. Count courses published each year --
SELECT YEAR(PublishDate) AS YEAR, COUNT(YEAR(PublishDate)) AS NO_Courses_each_year
FROM Courses
GROUP BY YEAR(PublishDate)
