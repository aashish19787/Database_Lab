create DATABASE	class;
use class;

create table student(
id int not null auto_increment primary key,
first_name varchar(50),
last_name varchar(50),
age int,
address varchar(100),
city varchar (50),
phone varchar(20)

);

insert into student (first_name, last_name, age, address, city, phone) values ('Aashish','Thapa',19,'Kupandole','Lalitpur','9860588177');
insert into student (first_name, last_name, age, address, city, phone) values ('Asmit','Nepal',20,'Imadol','Lalitpur','9864323243');

update student set age = 21 where city = 'Lalitpur';
delete from student where id = 2;
drop table student;
alter table student add email varchar(50);
update student set email = 'asmit.nepal' where id =2;

select * from student;

