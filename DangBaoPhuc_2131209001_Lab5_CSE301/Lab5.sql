
use SaleManagerment;
-- 1. Using Joining table to combine rows from more tables. (NATURAL JOIN, INNER JOIN, LEFT JOIN,
-- RIGHT JOIN, CROSS JOIN, SEFT JOIN)
-- 1. Display the clients (name) who lives in same city.

select a.Client_Name from clients as a inner join clients as b on a.City = b.City and a.Client_Name <> b.Client_Name;

-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select   a.city,a.Client_Name,b.Salesman_Name from clients a inner join salesman b where a.city='Thu Dau Mot' and b.city='Thu Dau Mot';
select distinct a.Client_Name,b.Salesman_Name from clients a, salesman b where a.city='Thu Dau Mot' and b.city='Thu Dau Mot';
-- 3. Display client name, client number, order number, salesman number, and product number for each
-- order.
select distinct b.Client_Name,a.Client_Number,a.Order_Number,a.Salesman_Number,c.Product_Number from salesorder a
 inner join  clients b on  b.Client_Number=a.Client_Number
 inner join salesorderdetails c on  c.Order_Number= a.Order_Number;
-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select a.Client_Number,b.Client_Name,a.Order_Number from salesorder as a inner join clients as b on a.Client_Number =b.Client_Number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by
-- them.
select a.Client_Number,a.Client_Name,count(b.Client_Number)  from clients a inner join salesorder b on a.Client_Number=b.Client_Number
group by a.Client_Number,a.Client_Name
 ;
-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select a.Client_Number,a.Client_Name,count(b.Client_Number)  from clients a inner join salesorder b on a.Client_Number=b.Client_Number
group by a.Client_Number,a.Client_Name
having count(b.Client_Number)>2
 ;
-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select a.Client_Number,a.Client_Name,count(b.Client_Number)  from clients a inner join salesorder b on a.Client_Number=b.Client_Number
group by a.Client_Number,a.Client_Name
having count(b.Client_Number)>1
order by a.Client_Number desc
 ;
-- 8. Find the salesman names who sells more than 20 products.
select a.Salesman_Name,sum(c.Order_Quantity) as countquant from salesman a inner join salesorder b on b.Salesman_Number=a.Salesman_Number 
inner join salesorderdetails c on b.Order_Number =c.Order_Number 
group by a.Salesman_Name
having sum(c.Order_Quantity)>20;


-- 9. Display the client information (client_number, client_name) and order number of those clients who
-- have order status is cancelled.

select a.Client_Number,a.Client_Name,b.Order_Number from clients a inner join  salesorder b on a.Client_Number=b.Client_Number 
and Order_Status='Cancelled';
-- 10. Display client name, client number of clients C101 and count the number of orders which were
-- received “successful”.
select a.Client_Number,a.Client_Name,count(*) from clients a inner join  salesorder b 
on a.Client_Number=b.Client_Number
 where a.Client_Number='C101' and b.Order_Status ='Successful'
 group by a.Client_Number;
 
-- 11. Count the number of clients orders placed for each product.
select a.Product_Number,a.Product_Name,count(b.Order_Quantity) from product a inner join salesorderdetails b 
on a.Product_Number=b.Product_Number
group by a.Product_Number,a.Product_Name;


-- 12. Find product numbers that were ordered by more than two clients then order in descending by product
-- number.
select product_number, count(*)
from (
select distinct b.Product_Number, c.client_number
from  salesorderdetails b 
			inner join salesorder c on b.Order_Number= c.Order_Number) as t
group by Product_Number
having count(*)>2
order by Product_Number desc;
-- b) Using nested query with operator (IN, EXISTS, ANY and ALL)

-- 13. Find the salesman’s names who is getting the second highest salary.
select Salesman_Name from salesman where salary=(
select max(b.Salary) from salesman b inner join
salesman c on b.Salary < c.Salary);

-- 14. Find the salesman’s names who is getting second lowest salary.
select Salesman_Name from salesman where salary=(
select min(b.Salary) from salesman b inner join
salesman c on b.Salary > c.Salary);
-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the
-- salesman whose salesman number is S001.
-- 3
select Salesman_Name,salary from salesman where salary>(select salary from salesman where Salesman_Number='S001' );

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select distinct f.Salesman_Name from salesman f inner join salesorder b
on f.Salesman_Number = b.Salesman_Number
inner join salesorderdetails a
on a.Order_Number=b.Order_Number
where a.Product_Number='P1002' ;




-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
select distinct f.Salesman_Name from salesman f inner join salesorder b
on f.Salesman_Number = b.Salesman_Number 
where Client_Number='C108'  and b.Delivery_Status='delivered';
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal
-- to 5.
select distinct f.Product_Name from product f inner join salesorderdetails b
on f.Product_Number = b.Product_Number 
where Order_Quantity=5 ;

-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select distinct f.Salesman_Name,count(*) from salesman f 
inner join salesorder b
on f.Salesman_Number = b.Salesman_Number 
inner join salesorderdetails c 
on b.Order_Number=c.Order_Number
where Product_Number='P1001' or Product_Number='P1002' or Product_Number='P1005'
group by f.Salesman_Name;

-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.

select distinct f.Salesman_Name from salesman f 
inner join salesorder b
on f.Salesman_Number = b.Salesman_Number 
inner join salesorderdetails c 
on b.Order_Number=c.Order_Number
inner join product p on p.Product_Number=c.Product_Number
where Cost_Price<800 and Quantity_On_Hand>50;



-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average
-- salary.

select distinct f.Salesman_Name,f.salary from salesman f 
where f.salary >(select avg(salary) from salesman);





-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the
-- average amount paid.	
select distinct f.Client_Name,f.Amount_Paid from clients f 
where f.Amount_Paid >(select avg(Amount_Paid) from clients);

-- II. Additional excersice:
-- 23. Find the product price that was sold to Le Xuan.
select  f.Sell_Price from product f 
inner join salesorderdetails a on f.Product_Number= a.Product_Number
inner join salesorder b on a.Order_Number=b.Order_Number
inner join clients c on b.Client_Number=c.Client_Number
where Client_Name='Le Xuan';
-- 24. Determine the product name, client name and amount due that was delivered.
select distinct  f.Product_Name,c.Client_Name,c.Amount_Due from product f 
inner join salesorderdetails a on f.Product_Number= a.Product_Number
inner join salesorder b on a.Order_Number=b.Order_Number
inner join clients c on b.Client_Number=c.Client_Number;



-- 25. Find the salesman’s name and their product name which is cancelled.
select  f.Salesman_Name,p.Product_Name from salesman f 
inner join salesorder b on b.Salesman_Number=f.Salesman_Number
inner join salesorderdetails c on b.Order_Number=c.Order_Number
inner join product p on p.Product_Number = c.Product_Number
where b.Order_Status='Cancelled';


-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
SELECT 
    p.Product_Name,
    p.Sell_Price,
    so.Delivery_Status
FROM
    clients c
inner join
    SalesOrder so ON c.Client_Number = so.Client_Number
inner join
    SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
inner join
    product p ON sod.Product_Number = p.Product_Number
WHERE
    c.Client_Name = 'Nguyen Thanh';

-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information
-- for each customer.
SELECT 
    p.Product_Name,p.Sell_Price,s.Salesman_Name,so.Delivery_Status,sod.Order_Quantity
FROM
    clients c
inner join
    SalesOrder so ON c.Client_Number = so.Client_Number
    inner join
    salesman s on so.Salesman_Number =s.Salesman_Number
inner join
    SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
inner join
    product p ON sod.Product_Number = p.Product_Number;



-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been
-- successful but the items have not yet been delivered to the client.
SELECT 
  s.Salesman_Name, p.Product_Name,so.Order_Date
from
    SalesOrder so 
    inner join
    salesman s on so.Salesman_Number =s.Salesman_Number
inner join
    SalesOrderDetails sod ON so.Order_Number = sod.Order_Number
inner join
    product p ON sod.Product_Number = p.Product_Number
       where so.Order_Status='Successful' and so.Delivery_Status<>'Delivered' ;
 

-- 29. Find each clients’ product which in on the way.
SELECT 
  c.Client_Name, p.Product_Name
from
    clients c
inner join
    salesorder so ON so.Client_Number = c.Client_Number
    inner join
    salesorderdetails sod on so.Order_Number=sod.Order_Number
inner join
    product p ON sod.Product_Number = p.Product_Number
       where  so.Delivery_Status='On Way' ;


-- 30. Find salary and the salesman’s names who is getting the highest salary.
select s.Salesman_Name , s.Salary from salesman s where s.salary = (
select max(Salary) from salesman)
group by s.Salesman_Name , s.Salary;

-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select s.Salesman_Name , s.Salary from salesman s where s.salary = (
select min(a.Salary) from salesman a where a.Salary<> (
select min(b.Salary) from salesman b)
)
group by s.Salesman_Name , s.Salary;


-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more
-- than 9.
select p.Product_Name from product p
inner join salesorderdetails  sod on p.Product_Number=sod.Product_Number
group by  p.Product_Name
having sum(Order_Quantity)>9;


-- 33. Find the name of the customer who ordered the same item multiple times.
select c.Client_Name, p.Product_Name,
    COUNT(*) AS Order_Count
    from clients c
inner join salesorder  s on c.Client_Number = s.Client_Number
inner join salesorderdetails sod on s.Order_Number =sod.Order_Number
inner JOIN
    product p ON sod.Product_Number = p.Product_Number
GROUP BY 
    c.Client_Name, p.Product_Name
HAVING 
    COUNT(*) > 1;



-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average
-- salary and works in any of Thu Dau Mot city.

select s.Salesman_Name,s.Salesman_Number,s.Salary from salesman s where s.Salary<(
select avg(salary) from salesman) and s.city ='Thu Dau Mot';
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to
-- highest.
select  distinct s.Salesman_Name,s.Salesman_Number,s.Salary from salesman s
where s.Salary >(select max(s1.salary) from salesman s1 inner join salesorder so on so.Salesman_Number= s1.Salesman_Number
where so.Order_Status='Cancelled')
order by s.Salary desc;





-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select max(salary) from salesman s where s.salary <(select max(s1.salary) from salesman s1 where s1.salary
<(select max(s2.salary) from salesman s2 where s2.salary<(select max(s2.salary) from salesman s2 where s2.salary)));


-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select min(salary) from salesman s where s.salary >(select min(s1.salary) from salesman s1 where s1.salary
>(select min(s2.salary) from salesman s2));