#DAYANANDASHABARI S - 22BTRCL045

#Task -1 DDL
create database SQL_Project;
use SQL_Project;
create table Customers
	(CustomerID int primary key,
	 FirstName varchar(50),
     LastName varchar(50),
     Email varchar(100),
     Phone varchar(20),
     Address varchar(100));
     
create table Employee
	(EmployeeID int primary key,
	 FirstName varchar(50),
     LastName varchar(50),
     Age int,
     Salary int);

alter table Employee add (Email varchar(100) not null);
alter table Employee modify age varchar(3);
alter table Employee add constraint salary check(salary >= 0);
drop table customers;

#Task -2 DML
create table Customers
	(CustomerID int primary key,
	 FirstName varchar(50),
     LastName varchar(50),
     Email varchar(100),
     Phone varchar(20),
     Address varchar(100));

insert into Customers values
	(101, "John", "Doe", "johndoe@example.com", 123-456-7890, "123 Main Street"),
	(102, "Jane", "Smith", "janesmith@example.com", 987-654-3210, "456 Elm Avenue"),
    (103, "Robert", "Johnson", "robertjohnson@example.com", 555-123-4567, "789 Oak Drive");
    
insert into Customers values(104, "Sarah", "Williams", "j'sarahwilliams@example.com", 111-222-3333, "789 Maple Street");

update Customers set phone = 987-654-3210 where CustomerID = 101;
delete from customers where CustomerID = 103;
select * from customers;