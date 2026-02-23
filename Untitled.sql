-- ================================================
-- Employee Management System - MySQL Database Schema
-- Complete with User Authentication
-- ================================================

CREATE DATABASE IF NOT EXISTS employee_management_system;
USE employee_management_system;

-- ================================================
-- Table: users (Authentication)
-- Stores login credentials for all users
-- ================================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    user_type ENUM('ADMIN', 'EMPLOYEE') NOT NULL,
    employee_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_employee_id (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================
-- Table: employees
-- Stores employee information
-- ================================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    contact_no VARCHAR(10) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    position VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_contact (contact_no),
    INDEX idx_department (department)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================
-- Table: tasks
-- Stores task assignments
-- ================================================
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    task_name VARCHAR(200) NOT NULL,
    description TEXT,
    status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    employee_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    INDEX idx_status (status),
    INDEX idx_employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================
-- Table: attendance
-- Stores daily attendance records
-- ================================================
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Leave', 'Late', 'Absent') DEFAULT 'Present',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_attendance (employee_id, attendance_date),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    INDEX idx_date (attendance_date),
    INDEX idx_status (status),
    INDEX idx_employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================
-- Add Foreign Key Constraint: users -> employees
-- ================================================
ALTER TABLE users
ADD CONSTRAINT fk_user_employee 
FOREIGN KEY (employee_id) REFERENCES employees(employee_id) 
ON DELETE CASCADE;

-- ================================================
-- Insert Default Admin Account
-- Username: admin
-- Password: password
-- ================================================
INSERT INTO users (username, password, user_type, employee_id, is_active) 
VALUES ('admin', 'password', 'ADMIN', NULL, TRUE);

-- ================================================
-- Sample Employees with Login Credentials
-- ================================================

-- Employee 1: John Doe
INSERT INTO employees (first_name, middle_name, last_name, date_of_birth, contact_no, email, address, position, department) 
VALUES ('John', 'Michael', 'Doe', '1990-05-15', '9876543210', 'john.doe@company.com', '123 Main Street, New York, NY 10001', 'Software Developer', 'IT');

INSERT INTO users (username, password, user_type, employee_id, is_active) 
VALUES ('john.doe', 'john123', 'EMPLOYEE', LAST_INSERT_ID(), TRUE);

-- Employee 2: Jane Smith
INSERT INTO employees (first_name, middle_name, last_name, date_of_birth, contact_no, email, address, position, department) 
VALUES ('Jane', NULL, 'Smith', '1988-08-22', '9876543211', 'jane.smith@company.com', '456 Oak Avenue, Los Angeles, CA 90001', 'HR Manager', 'HR');

INSERT INTO users (username, password, user_type, employee_id, is_active) 
VALUES ('jane.smith', 'jane123', 'EMPLOYEE', LAST_INSERT_ID(), TRUE);

-- Employee 3: Robert Johnson
INSERT INTO employees (first_name, middle_name, last_name, date_of_birth, contact_no, email, address, position, department) 
VALUES ('Robert', 'James', 'Johnson', '1992-03-10', '9876543212', 'robert.johnson@company.com', '789 Pine Road, Chicago, IL 60601', 'Accountant', 'Finance');

INSERT INTO users (username, password, user_type, employee_id, is_active) 
VALUES ('robert.johnson', 'robert123', 'EMPLOYEE', LAST_INSERT_ID(), TRUE);

-- ================================================
-- Sample Tasks
-- ================================================
INSERT INTO tasks (task_name, description, status, employee_id) VALUES
('Develop Login Module', 'Create secure login functionality with authentication', 'In Progress', 1),
('Recruitment Drive', 'Conduct interviews for 5 new positions', 'In Progress', 2),
('Prepare Q1 Report', 'Compile and analyze first quarter performance data', 'Pending', 3);

-- ================================================
-- Sample Attendance Records
-- ================================================
INSERT INTO attendance (employee_id, attendance_date, status, remarks) VALUES
(1, '2026-02-10', 'Present', 'On time'),
(2, '2026-02-10', 'Present', 'On time'),
(3, '2026-02-10', 'Late', 'Traffic delay'),
(1, '2026-02-11', 'Present', 'On time'),
(2, '2026-02-11', 'Leave', 'Sick leave'),
(3, '2026-02-11', 'Present', 'On time'),
(1, '2026-02-19', 'Present', 'On time'),
(2, '2026-02-19', 'Present', 'On time'),
(3, '2026-02-19', 'Late', 'Overslept');

-- ================================================
-- Views for Reporting
-- ================================================

-- View: Employee with Login Info
CREATE OR REPLACE VIEW employee_login_view AS
SELECT 
    e.employee_id,
    e.first_name,
    e.middle_name,
    e.last_name,
    CONCAT(e.first_name, ' ', IFNULL(CONCAT(e.middle_name, ' '), ''), e.last_name) AS full_name,
    e.email,
    e.contact_no,
    e.position,
    e.department,
    u.user_id,
    u.username,
    u.is_active AS account_active
FROM employees e
LEFT JOIN users u ON e.employee_id = u.employee_id
WHERE u.user_type = 'EMPLOYEE';

-- View: User Summary
CREATE OR REPLACE VIEW user_summary AS
SELECT 
    u.user_id,
    u.username,
    u.user_type,
    u.is_active,
    CASE 
        WHEN u.user_type = 'EMPLOYEE' AND u.employee_id IS NOT NULL THEN 
            (SELECT CONCAT(first_name, ' ', last_name) FROM employees WHERE employee_id = u.employee_id)
        WHEN u.user_type = 'ADMIN' THEN 'System Administrator'
        ELSE 'Unknown'
    END AS full_name
FROM users u;

-- ================================================
-- Stored Procedures
-- ================================================

-- Procedure: Create Employee with Login
DELIMITER //
CREATE PROCEDURE CreateEmployeeWithLogin(
    IN p_first_name VARCHAR(50),
    IN p_middle_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_dob DATE,
    IN p_contact VARCHAR(10),
    IN p_email VARCHAR(100),
    IN p_address TEXT,
    IN p_position VARCHAR(100),
    IN p_department VARCHAR(100),
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100),
    OUT p_employee_id INT,
    OUT p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_employee_id = -1;
        SET p_user_id = -1;
    END;
    
    START TRANSACTION;
    
    -- Insert employee
    INSERT INTO employees (first_name, middle_name, last_name, date_of_birth, contact_no, email, address, position, department)
    VALUES (p_first_name, p_middle_name, p_last_name, p_dob, p_contact, p_email, p_address, p_position, p_department);
    
    SET p_employee_id = LAST_INSERT_ID();
    
    -- Insert user credentials
    INSERT INTO users (username, password, user_type, employee_id, is_active)
    VALUES (p_username, p_password, 'EMPLOYEE', p_employee_id, TRUE);
    
    SET p_user_id = LAST_INSERT_ID();
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Authenticate User
DELIMITER //
CREATE PROCEDURE AuthenticateUser(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100)
)
BEGIN
    SELECT 
        u.user_id,
        u.username,
        u.user_type,
        u.employee_id,
        u.is_active,
        CASE 
            WHEN u.user_type = 'EMPLOYEE' THEN 
                (SELECT CONCAT(first_name, ' ', last_name) FROM employees WHERE employee_id = u.employee_id)
            ELSE 'Administrator'
        END AS display_name
    FROM users u
    WHERE u.username = p_username 
      AND u.password = p_password 
      AND u.is_active = TRUE;
END //
DELIMITER ;

-- ================================================
-- Triggers
-- ================================================

-- Trigger: Validate employee age before insert
DELIMITER //
CREATE TRIGGER validate_employee_age_before_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.date_of_birth, CURDATE()) < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee must be at least 18 years old';
    END IF;
END //
DELIMITER ;

-- Trigger: Deactivate user when employee deleted
DELIMITER //
CREATE TRIGGER deactivate_user_on_employee_delete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    UPDATE users SET is_active = FALSE WHERE employee_id = OLD.employee_id;
END //
DELIMITER ;

-- ================================================
-- Indexes for Performance
-- ================================================
CREATE INDEX idx_user_type ON users(user_type);
CREATE INDEX idx_is_active ON users(is_active);
CREATE INDEX idx_employee_name ON employees(last_name, first_name);

-- ================================================
-- Database Info
-- ================================================
SELECT 'Database schema created successfully!' AS status;
SELECT COUNT(*) AS admin_users FROM users WHERE user_type = 'ADMIN';
SELECT COUNT(*) AS employee_users FROM users WHERE user_type = 'EMPLOYEE';
SELECT COUNT(*) AS total_employees FROM employees;
