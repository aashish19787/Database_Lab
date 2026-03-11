CREATE DATABASE TechSolutionDB;
USE TechSolutionDB;

CREATE TABLE Department (
DeptID INT PRIMARY KEY,
DeptName VARCHAR(50) NOT NULL,
Location VARCHAR(50)
);

CREATE TABLE Employee (
EmpID INT PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Gender CHAR(1),
Salary INT,
HireDate DATE,
DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Project (
ProjectID INT PRIMARY KEY AUTO_INCREMENT,
ProjectName VARCHAR(30),
StartDate DATE,
EndDate DATE,
Budget INT
);

CREATE TABLE Works_on (
EmpID INT,
ProjectID INT,
HoursWorked INT,
FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- Insert at least 5 records into each table. 
INSERT INTO Department VALUES
(1, 'Human Resources', 'Kathmandu'),
(2, 'IT', 'Pokhara'),
(3, 'Finance', 'Lalitpur'),
(4, 'Marketing', 'Butwal'),
(5, 'Research', 'Chitwan');

INSERT INTO Employee VALUES
(101, 'Ram', 'Sharma', 'M', 50000, '2022-01-15', 1),
(102, 'Sita', 'Thapa', 'F', 60000, '2021-03-10', 2),
(103, 'Hari', 'Karki', 'M', 55000, '2020-07-20', 3),
(104, 'Gita', 'Gurung', 'F', 52000, '2023-02-12', 4),
(105, 'Bikash', 'Rai', 'M', 58000, '2021-11-05', 5);

INSERT INTO Project (ProjectName, StartDate, EndDate, Budget) VALUES
('Website Development', '2024-01-01', '2024-06-01', 100000),
('Mobile App', '2024-02-15', '2024-08-30', 150000),
('Database System', '2024-03-10', '2024-07-20', 120000),
('Marketing Campaign', '2024-04-01', '2024-09-01', 90000),
('AI Research', '2024-05-01', '2024-12-31', 200000);

INSERT INTO Works_on VALUES
(101, 1, 20),
(102, 2, 35),
(103, 3, 30),
(104, 4, 25),
(105, 5, 40);

-- Update the salary of an employee whose EmpID = 102 by increasing it by 10%. 
UPDATE Employee SET Salary = Salary * 1.10 WHERE EmpID = 102;

-- Delete a project whose ProjectID = 5.
DELETE FROM Project WHERE ProjectID = 5; 


-- Display all employees who earn more than 50,000.
SELECT EmpID, FirstName, LastName, Salary FROM Employee WHERE Salary > 50000;

-- Display FirstName, LastName, and Salary of employees sorted by Salary in descending order.
SELECT FirstName, LastName, Salary FROM Employee ORDER BY Salary DESC;

-- Display employees who belong to the IT Department. 
SELECT * FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
WHERE D.DeptName = 'IT';

-- Show the total number of employees in each department.
SELECT D.DeptName, COUNT(E.EmpID) AS TotalEmployees
FROM Department D
LEFT JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptName;

-- Display employees who were hired after January 1, 2022.
SELECT * FROM Employee WHERE HireDate > '2022-01-01';

-- Display employee names along with their department names.
SELECT E.FirstName, E.LastName, D.DeptName
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID;

-- Show the employees and the projects they are working on.
SELECT E.FirstName, E.LastName, P.ProjectName, W.HoursWorked
FROM Employee E
JOIN Works_on W ON E.EmpID = W.EmpID
JOIN Project P ON W.ProjectID = P.ProjectID; 

-- Display projects names with the total hours worked by employees.
SELECT P.ProjectName, SUM(W.HoursWorked) AS TotalHours
FROM Project P
JOIN Works_on W ON P.ProjectID = W.ProjectID
GROUP BY P.ProjectName;

-- Find the average salary of employees in each department.
SELECT D.DeptName, AVG(E.Salary) AS AvgSalary
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptName;

-- Display the department with the highest number of employees.
SELECT D.DeptName, COUNT(E.EmpID) AS TotalEmployees
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptName
ORDER BY TotalEmployees DESC
LIMIT 1;

-- Find the employees whose salary is greater than the average salary of all employees.
SELECT EmpID, FirstName, LastName, Salary
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee);

-- Create a view named HighSalaryEmployees that shows employees with salary greater than 60,000.
CREATE VIEW HighSalaryEmployees AS
SELECT EmpID, FirstName, LastName, Salary, DeptID
FROM Employee
WHERE Salary > 60000;

SELECT * FROM HighSalaryEmployees;

-- Create an index on the LastName column of the Employee table.  
CREATE INDEX idx_LastName
ON Employee (LastName);


SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM Project;
SELECT * FROM Works_on;