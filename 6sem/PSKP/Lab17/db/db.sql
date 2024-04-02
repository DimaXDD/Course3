create database Lab17;
use Lab17;

--drop table USERS;

create table USERS (
	id INT IDENTITY(1,1) primary key,
    username nvarchar(255) not null,
    password nvarchar(255) not null,
	info nvarchar(255) not null,
);


select * from USERS;

TRUNCATE TABLE USERS;