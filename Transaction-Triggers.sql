CREATE DATABASE BankDB;
USE BankDB;


create table accounts(
account_id int not null primary key ,
account_holder varchar(50) not null,
balance decimal(10,2)
);

INSERT INTO accounts (account_id, account_holder, balance) VALUES
(1, 'Ram Sharma', 50000.50),
(2, 'Shyam Thapa', 72000.75),
(3, 'Sita Gurung', 45000.00),
(4, 'Gita Rai', 98000.25),
(5, 'Bikash Karki', 61000.60),
(6, 'Anita Magar', 83000.90),
(7, 'Ramesh Shrestha', 54000.40),
(8, 'Puja Tamang', 76000.10),
(9, 'Dipak Bhandari', 30000.00),
(10, 'Kiran Adhikari', 89000.80);

-- Write a transaction that transfers Rs. 5000 from Ram's account to Shyam's account.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE account_holder = 'Ram Sharma';

UPDATE accounts
SET balance = balance + 5000
WHERE account_holder = 'Shyam Thapa';

COMMIT;

-- Write a transaction that transfers Rs. 10000 from Shyam's account to Sita's account and demonstrate the use of ROLLBACK.
START transaction;

UPDATE accounts
SET balance = balance - 10000
WHERE account_holder = 'Shyam Thapa';

UPDATE accounts
SET balance = balance + 10000
WHERE account_holder = 'Sita Gurung';

ROLLBACK;

-- Write a transaction that demonstrates the use of SAVEPOINT while updating account balance.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 2000
WHERE account_id = 1;

SAVEPOINT sp1;

UPDATE accounts
SET balance = balance + 2000
WHERE account_id = 2;

ROLLBACK TO sp1;

COMMIT;

select * from accounts;

# Triggers

-- 1: Create a table employees with the fields employee_id, name, salary.alter

CREATE TABLE employees(
emp_id INT PRIMARY KEY,
name VARCHAR(100),
salary DECIMAL(10,2)
);

-- 2: Create another table salary_log to record employee salary changes with fields: log_id, emp_id, old_salary, new_salary, updated_at.
CREATE TABLE salary_log(
log_id INT AUTO_INCREMENT PRIMARY KEY,
emp_id INT,
old_salary DECIMAL(10,2),
new_salary DECIMAL(10,2),
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a BEFORE INSERT Trigger on employees that prevents inserting employees whose salary is less than 10000.
Delimiter $$

Create trigger check_salary
before insert on employees
for each row
begin
if new.salary < 10000 then
signal sqlstate '45000'
set message_text = "salary must be atleast 10000";
end if ;
end $$

Delimiter ;

-- Create an AFTER UPDATE trigger on employees that records salary changes into the salary_log table.
Delimiter $$
create trigger log_salary_update
after update on employees
for each row 
begin
insert into salary_log(emp_id, old_salary, new_salary)
values (old.emp_id,old.salary, new.salary);
end $$
Delimiter ;

-- Stored Procedure
-- Create a stored procedure that retrives all records from the employee table.
DELIMITER $$

CREATE PROCEDURE get_all_employees()
BEGIN
    SELECT * FROM employees;
END $$

DELIMITER ;
CALL get_all_employees();

-- Create a stored procedure that inserts a new employee into the employees table using parameters.
DELIMITER $$

CREATE PROCEDURE add_employee(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO employees VALUES (p_id, p_name, p_salary);
END $$

DELIMITER ;

call addEmployee(14, "Hari Yadav", 20000);



-- Create a store procedure that updates the salary of an employee based on employee ID.
DELIMITER $$

CREATE PROCEDURE update_employee_salary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees
    SET salary = p_new_salary
    WHERE emp_id = p_emp_id;
END $$

DELIMITER ;


CALL update_employee_salary(1, 25000);


-- Create a stored procedure that transfers money between two accounts using a transaction.
DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN p_from_account INT,
    IN p_to_account INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE from_balance DECIMAL(10,2);

    SELECT balance INTO from_balance
    FROM accounts
    WHERE account_id = p_from_account;

    IF from_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance for transfer';
    ELSE
        START TRANSACTION;

        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_from_account;

        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_to_account;

        COMMIT;
    END IF;
END $$

DELIMITER ;

CALL transfer_money(1, 2, 5000);





















