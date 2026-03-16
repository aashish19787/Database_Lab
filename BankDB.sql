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
START transaction;

update accounts
set account = balance - 2000
where account_id = 1;
savepoint sp1;
update accounts set balance = balance = 2000
where account_id = 2;
rollback to sp1;
commit;





select * from accounts;


