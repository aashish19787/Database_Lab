CREATE DATABASE classworkDB;
use classworkDB;

create table Persons(
personID int not null auto_increment primary key,
lastName varchar(50),
firstName varchar(50),
age int
);

drop table Persons;
drop database classworkDB;


create table Orders(
OrderID int not null,
OrderNumber int not null,
PersonID int,
PRIMARY KEY (orderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons(PersonID)
);


drop table Orders;

select * from Persons;
select * from Orders;


alter table Persons add email varchar(55);

insert into Persons (lastName, firstName, age) values ('Thapa','Aashish',19),('Nepal','Asmit',20);
insert into Orders (OrderId, OrderNumber, PersonID) values (1, 4375,1);

update Persons set email = 'aashish@gmail.com' where personID = 1;
 
SELECT 
    Persons.personID,
    Persons.firstName,
    Persons.lastName,
    Persons.age,
    Persons.email,
    Orders.OrderID,
    Orders.OrderNumber
FROM Persons
INNER JOIN Orders
ON Persons.personID = Orders.PersonID;

SELECT 
    Persons.personID,
    Persons.firstName,
    Persons.lastName,
    Persons.age,
    Persons.email,
    Orders.OrderID,
    Orders.OrderNumber
FROM Persons
LEFT JOIN Orders
ON Persons.personID = Orders.PersonID;

SELECT 
    Persons.personID,
    Persons.firstName,
    Persons.lastName,
    Persons.age,
    Persons.email,
    Orders.OrderID,
    Orders.OrderNumber
FROM Persons
Right JOIN Orders
ON Persons.personID = Orders.PersonID;

