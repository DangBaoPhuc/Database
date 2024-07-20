drop database if exists humanResourceManagement;
create database humanResourceManagement;
use humanResourceManagement;

create table employees(
employeeID varchar(3) not null primary key,
lastName varchar(20) not null,
middleName varchar(20) null,
firstName varchar(20) not null,
dateOfmBirth	date not null,
gender varchar(5) not null,
salary decimal not null,
address varchar(100) NOT NULL,
managerID varchar(3) ,
departmentID int


);
create table department(
departmentID int PRIMARY KEY,
departmentName varchar(10)  NOT NULL,
managerID varchar(3) ,
date0fEmployment date NOT NULL
-- ,
-- foreign key (managerID) references employees(employeeID)

);

create table departmentAddress(
departmentID int ,

address varchar(30) ,
primary key (departmentID,address),
foreign key (departmentID) references department(departmentID)
);
create table projects(
projectID int PRIMARY KEY,
projectName varchar(30) NOT NULL,
projectAddress varchar(100) NOT NULL,
departmentID int,
foreign key (departmentID) references department(departmentID)
);

create table ASSIGNMENT(
employeeID varchar(3) ,
 projectID int,
workingHour float NOT NULL,
primary key (employeeID,projectID),
foreign key (employeeID) references employees(employeeID),
foreign key (projectID) references projects(projectID)
);

create table RELATIVE(
employeeID varchar(3) ,
 relativeName varchar(50),
gender varchar(5) NOT NULL,

 date0fBirth date NULL,
 relationship varchar(30) NOT NULL,
 primary key (employeeID,relativeName),
 foreign key (employeeID) references  employees(employeeID)
 
);

INSERT INTO employees  VALUES
(123, 'Dinh', 'Ba', 'Tien', '1995-09-01', 'Nam', 30000, '731 Tran Hung Dao Q1 TPHCM', 333, 5),
(333, 'Nguyen', 'Thanh', 'Tung', '1945-12-08', 'Nam', 40000, '638 Nguyen Van Cu Q5 TPHCM', 888, 5),
(453, 'Tran', 'Thanh', 'Tam', '1962-07-31', 'Nam', 25000, '543 Mai Thi Luu Ba Dinh Ha Noi', 333, 5),
(666, 'Nguyen', 'Manh', 'Hung', '1952-09-15', 'Nam', 38000, '975 Le Lai P3 Vung Tau', 333, 5),
(777, 'Tran', 'Hong', 'Quang', '1959-03-29', 'Nam', 25000, '980 Le Hong Phong Vung Tau', 987, 4),
(888, 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', 55000, '450 Trung Vuong My Tho TG', NULL, 1),
(987, 'Le', 'Thi', 'Nhan', '1931-06-20', 'Nu', 43000, '291 Ho Van Hue Q.PN TPHCM', 888, 4),
(999, 'Bui', 'Thuy', 'Vu', '1958-07-19', 'Nam', 25000, '332 Nguyen Thai Hoc Quy Nhon', 987, 4);

INSERT INTO DEPARTMENT VALUES
(1, 'Quan ly', 888, '1971-06-19'),
(4, 'Dieu hanh', 777, '1985-01-01'),
(5, 'Nghien cuu', 333, '1978-05-22');
alter table department add foreign key(managerID) references employees(employeeID);
alter table employees add  foreign key(managerID) references employees(employeeID);
alter table employees add  foreign key(departmentID) references department(departmentID);




INSERT INTO departmentAddress VALUES
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');



INSERT INTO projects
VALUES 
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM ', 5),
(10, 'Tin hoc hoa', 'HA NOI ', 4),
(20, 'Cap Quang	', 'VUNG TAU', 1),
(30, 'Dao tao ', 'HA NOI ', 4);


INSERT INTO ASSIGNMENT
VALUES 
('123', 1, 22.5),
('123', 2, 7.5),
('123', 3,10),
('123', 10, 10),
('333', 20, 10),
('333', 1, 20),
('453', 2, 20),
('666', 3, 40),
('888', 20, 0),
('987', 20, 15);

INSERT INTO relative
VALUES 
('123', 'Chau', 'Nu', STR_TO_DATE('31-12-1978', '%d-%m-%Y'), 'Con gai'),
('123', 'Duy', 'Nam', STR_TO_DATE('1-1-1978', '%d-%m-%Y'), 'Con trai'),
('123', 'Phuong', 'Nu', STR_TO_DATE('5-5-1957', '%d-%m-%Y'), 'Vo chong'),
('333', 'Duong', 'Nu', STR_TO_DATE('5-3-1948', '%d-%m-%Y'), 'Vo chong'),
('333', 'Quang', 'Nu', STR_TO_DATE('4-5-1976', '%d-%m-%Y'), 'Con gai'),
('333', 'Tung', 'Nam', STR_TO_DATE('25-10-1973', '%d-%m-%Y'), 'Con trai'),
('987', 'Dang', 'Nam', STR_TO_DATE('29-2-1932', '%d-%m-%Y'), 'Vo chong');


select * from employees;
select * from department;
select * from departmentAddress;
select * from projects;
select * from ASSIGNMENT;
select * from RELATIVE;































