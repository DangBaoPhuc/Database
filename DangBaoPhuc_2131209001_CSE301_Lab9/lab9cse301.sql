drop database if exists humanResourceManagement;
create database humanResourceManagement;
use humanResourceManagement;


-- II. Creating constraint for database:
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employees add constraint checkgender check (gender like "Nam" or gender like "Nu");

-- 2. Check constraint to value of salary > 0.
alter table employees add constraint check_salary check (salary>0);

-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con
-- gai”, “Me ruot”, “Cha ruot”.
alter table relative add constraint check_relative check (relationship like "Vo chong" or
relationship like "Con trai" or relationship like "Con gai" or relationship like "Me ruot"
or relationship like "Cha ruot");



-- III. Writing SQL Queries.
-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above
-- 30,000 in room 5.
select * from employees where salary >25000 and departmentID ='4'
union (select * from employees where salary >30000 and departmentID ='5');


-- 2. Provide full names of employees in HCM city.
select lastName,middleName,firstName from employees where address like '%HCM%';


-- 3. Indicate the date of birth of Dinh Ba Tien staff.

select  dateOfmBirth from employees where lastName = 'Dinh' and middleName='Ba' and firstName='Tien';
-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this
-- employee is directly managed by "Nguyen Thanh Tung".
Select e.firstName from employees  e 

inner join assignment a on a.employeeID=e.employeeID
inner join projects p on a.projectID= p.projectID
inner join employees e1 on e1.employeeID=e.managerID
where projectName= 'San pham X' and e.departmentID='5'
and e1.firstName='Tung' and e1.lastName='Nguyen' and e1.middleName= 'Thanh' ;


-- 5. Find the names of department heads of each department.
select lastName,middleName,firstName from employees e inner join department d on d.managerID=e.managerID;

-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName,
-- departmentID, date0fEmployment.
select p.projectID, p.projectName, p.projectAddress, p.departmentID ,d.departmentName ,d.managerID,d.date0fEmployment  from projects p inner join
 department d on d.departmentID= p.departmentID ;

-- 7. Find the names of female employees and their relatives.
select lastName,middleName,firstName , r.relativeName from employees e inner join relative r on  e.employeeID=r.employeeID ;


-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead
-- department (departmentID), the full name of the manager (lastName, middleName,
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the
-- Employees.

 select p.projectID,p.departmentID,e.lastName,e.middleName,e.firstName,e.address,e.dateOfBirth from projects p 
 inner join department d on p.departmentID =d.departmentID inner join employees e on d.managerID=e.employeeID
 where projectAddress like '%Ha Noi%';
 
-- 9. For each employee, include the employee's full name and the employee's line manager.

-- 10. For each employee, indicate the employee's full name and the full name of the head of the
-- department in which the employee works.
select e.lastName,e.middleName,e.firstName,departmentName from employees e inner join department d
on d.departmentID = e.departmentID;
-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of
-- the projects in which the employee participated, if any.
select e.lastName,e.middleName,e.firstName,p.projectName from employees e inner join assignment a
on a.employeeID = e.employeeID inner join projects p on p.projectID=a.projectID;
-- 12. For each scheme, list the scheme name (projectName) and the total number of hours
-- worked per week of all employees attending that scheme.
select projectName , sum(workingHour) from projects p inner join assignment a
on a.projectID = p.projectID inner join employees e on e.employeeID = a.employeeID
group by projectName ;

-- 13. For each department, list the name of the department (departmentName) and the average
-- salary of the employees who work for that department.
select departmentName,avg(salary) from department d inner join employees  e on d.departmentID =e.departmentID
group by departmentName;


-- 14. For departments with an average salary above 30,000, list the name of the department and
-- the number of employees of that department.
select departmentName,count(employeeID) from department d inner join employees  e on d.departmentID =e.departmentID
group by departmentName
having avg(salary)>30000;
-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh'
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
SELECT DISTINCT p.projectID
FROM projects p
 JOIN ASSIGNMENT a ON p.projectID = a.projectID
JOIN employees e ON a.employeeID = e.employeeID
JOIN department d ON p.departmentID = d.departmentID
 JOIN employees h ON d.managerID = h.employeeID
WHERE e.lastName = 'Dinh'
   OR h.lastName = 'Dinh';
-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
select e.lastName,e.middleName,e.firstName from employees e inner join relative r
on r.employeeID = e.employeeID
group by   e.lastName,e.middleName,e.firstName
having count(*)>2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
SELECT e.lastName, e.middleName, e.firstName
FROM employees e
WHERE e.employeeID NOT IN (SELECT r.employeeID FROM RELATIVE r);

-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
select e.lastName,e.middleName,e.firstName from employees e inner join department d
on d.managerID = e.employeeID inner join relative r on r.employeeID = e.employeeID

group by   e.lastName,e.middleName,e.firstName
having count(*)>1;
-- 19. Find the surname (lastName) of unmarried department heads.
select distinct e.lastName from employees e inner join relative r 
on e.employeeID = r.employeeID 
where relativeName not like 'Con gai'and relativeName not like 'Con trai'and  relativeName not like 'Vo chong';

-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary
-- is above the average salary of the "Research" department.
select e.lastName,e.middleName,e.firstName from employees e inner join  
department d on d.departmentID=e.departmentID
where e.salary > (select avg(salary) from employees) and departmentName='Nghien cuu';


-- 21. Indicate the name of the department and the full name of the head of the department with
-- the largest number of employees.
select d.departmentName,e.lastName,e.middleName,e.firstName
 from department d inner join employees e on e.employeeID = d.managerID
 group by d.departmentName,e.lastName,e.middleName,e.firstName
 order by count(*) desc
 limit 1;



-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of
-- employees who work on a project in 'HCMC' but the department they belong to is not
-- located in 'HCMC'.
select e.lastName,e.middleName,e.firstName,e.address
 from employees e inner join assignment a on e.employeeID = a.employeeID
inner join projects p on a.projectID= p.projectID 
inner join departmentaddress d on d.departmentID= p.departmentID
where projectAddress like '%HCM%' and d.address not like'%HCM%';


	-- 23. Find the names and addresses of employees who work on a scheme in a city but the
	-- department to which they belong is not located in that city.
    SELECT distinct e.lastName, e.middleName, e.firstName, e.address
FROM employees e
JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
JOIN projects p ON a.projectID = p.projectID
JOIN department d ON e.departmentID = d.departmentID
JOIN departmentAddress da ON d.departmentID = da.departmentID
WHERE p.projectAddress <> da.address;
-- 24. Create procedure List employee information by department with input data
-- departmentName.
drop procedure if exists listImployeeInformation ;
Delimiter $$
create procedure listImployeeInformation(In departmentNameIn varchar(30))
begin
select * from employees e inner join department d on e.departmentID=d.departmentID
where departmentName = departmentNameIn;

end $$
Delimiter ;
call listImployeeInformation('Quan ly') ;
CALL listImployeeInformation('Nghien cuu');

-- 25. Create a procedure to Search for projects that an employee participates in based on the
-- employee's last name (lastName).
drop procedure if exists SearchForProject ;
Delimiter $$
create procedure SearchForProject(In lastNameIn varchar(30))
begin
select p.projectName from projects p inner join assignment a on a.projectID=p.projectID inner join  employees e on e.employeeID=a.employeeID
where e.lastName=lastNameIn;

end $$
Delimiter ;
call SearchForProject('Dinh') ;

-- 26. Create a function to calculate the average salary of a department with input data
-- departmentID.
drop Function if exists AVGSalary ;
Delimiter $$
create Function AVGSalary( departmentIDIn varchar(30))
returns decimal(10,4)
DETERMINISTIC
begin
declare avgSalary decimal(10,4);
select avg(salary) into avgSalary from employees e inner join department d on d.departmentID = e.departmentID
where d.departmentID=departmentIDIn;
return avgSalary;
end $$
Delimiter ;
select AVGSalary(4) as avgSalary;


-- 27. Create a function to Check if an employee is involved in a particular project input data is
-- employeeID, projectID.

drop Function if exists checkInvolvedProject ;
Delimiter $$
create Function checkInvolvedProject( employeeIDIn varchar(30),projectIDIn varchar(30))
returns boolean
DETERMINISTIC
begin
declare checkInvonvelved boolean;
select case when exists (select 1 from assignment where employeeID =employeeIDIn and projectID=projectIDIn )
then true else false end into checkInvonvelved;
return checkInvonvelved;
end $$
Delimiter ;
select checkInvolvedProject('123','1') as checkInvolve;

