-- 1. Create database and use it
CREATE DATABASE dbemp;
USE dbemp;

-- 2. Create employee table with proper data types & constraints
CREATE TABLE employee (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    DateOfBirth DATE NOT NULL,
    Designation VARCHAR(30),
    DepartmentName VARCHAR(30),
    ManagerID VARCHAR(10),
    JoinedDate DATE,
    Salary DECIMAL(10,2)
);

-- 3. Insert at least two employee records
INSERT INTO employee (
    EmployeeID, FirstName, LastName, Gender, DateOfBirth,
    Designation, DepartmentName, ManagerID, JoinedDate, Salary
) VALUES
('002', 'Season', 'Thapa', 'M', '1996-04-02',
 'Engineer', 'Software Engineering', '005', '2022-11-02', 50000),
('005', 'Srijana', 'Sharma', 'F', '2000-04-02',
 'Manager', 'Software Engineering', NULL, '2021-01-02', 90000);

SELECT * FROM employee;

-- 4. Update gender of employee whose EmployeeID is 003
-- (This will update only if EmployeeID = '003' exists)
UPDATE employee
SET Gender = 'M'
WHERE EmployeeID = '003';

-- 5. Display employees older than 25 years
SELECT 
    FirstName,
    CURDATE() AS CurrentDate,
    DateOfBirth,
    TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS Age
FROM employee
WHERE TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) > 25;

-- 6. Find the oldest employee
SELECT *
FROM employee
WHERE DateOfBirth = (
    SELECT MIN(DateOfBirth) FROM employee
);

-- 7. Find the youngest employee
SELECT *
FROM employee
WHERE DateOfBirth = (
    SELECT MAX(DateOfBirth) FROM employee
);

-- 8. Display maximum salary department-wise
SELECT DepartmentName, MAX(Salary) AS MaxSalary
FROM employee
GROUP BY DepartmentName;

-- 9. Display minimum salary department-wise
SELECT DepartmentName, MIN(Salary) AS MinSalary
FROM employee
GROUP BY DepartmentName;

-- 10. List employees who act as managers
SELECT *
FROM employee
WHERE EmployeeID IN (
    SELECT DISTINCT ManagerID FROM employee
    WHERE ManagerID IS NOT NULL
);

-- 11. Update employee first name
UPDATE employee
SET FirstName = 'Aashish'
WHERE EmployeeID = '002';

-- 12. Delete employee from list
-- (Runs safely only if EmployeeID = '010' exists)
DELETE FROM employee
WHERE EmployeeID = '010';

-- 13. LIKE operator example
SELECT *
FROM employee
WHERE FirstName LIKE '%o%';

-- 14. Select TOP (MySQL uses LIMIT, not TOP)
SELECT FirstName
FROM employee
LIMIT 2;

select orders.orderiId, 
customers.customerID,
from orders, customers
where orders.customerId = customer.customerId;
