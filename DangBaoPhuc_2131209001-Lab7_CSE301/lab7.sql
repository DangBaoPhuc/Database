use SaleManagerment;


-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman"
-- table.
select city from clients union select city from salesman; 
-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
select city from clients union all select city from salesman; 
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
select city from clients where city = 'Ho Chi Minh' union  select city from salesman where city = 'Ho Chi Minh'; 


-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
select city from clients where city = 'Ho Chi Minh' union all select city from salesman where city = 'Ho Chi Minh'; 

-- 5. SQL statement lists all Clients and salesman.

select Client_Name from clients union all select Salesman_Name from salesman;
-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
select * from
(select Client_Number ID,Client_Name `name`,City city, 'client' `type` from clients where city= "Hanoi"
 union all 
 select Salesman_Number ID,Salesman_Name `name`,City city, 'salesman' `type` from salesman where city= "Hanoi") as T;

-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.


select T.*,count(T.ID) from
(select Client_Number ID,Client_Name `name` from clients
 union all 
 select s.Salesman_Number ID,Salesman_Name `name` from salesman s) as T
		inner join salesorder so on T.ID =so.Client_Number or T.ID= so.Salesman_Number
 group by T.ID, T.name
 having count(T.ID)>1
 order by T.ID;



-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
select  T.*,so.Order_Number from
(select Client_Number ID,Client_Name `name`, 'client' `type` from clients 
 union all 
 select Salesman_Number ID,Salesman_Name `name`, 'salesman' `type` from salesman ) as T
 	inner join salesorder so on T.ID =so.Client_Number or T.ID= so.Salesman_Number
    group by T.ID,T.name,T.type,so.Order_Number 
    order by so.Order_Number 
 ;
-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
select T.ID,T.name,T.City,T.Achieve from
(select Salesman_Number ID,Salesman_Name `name`,City city ,'High Archive' `Achieve` from salesman where Target_Achieved>=60
 union all 
 select Salesman_Number ID,Salesman_Name `name`,City city ,'Low Archive' `Achieve`from salesman where Target_Achieved<60)
 as T;


-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
select T.ID,T.name,T.Quantity,T.Stock from
(select Product_Number ID,Product_Name `name`,Quantity_On_Hand Quantity , 'More 5 pieces in Stock' Stock from product where Quantity_On_Hand >0
 union all 
 select Product_Number ID,Product_Name `name`,Quantity_On_Hand Quantity, 'Less 5 pieces in Stock'  Stock	from product where Quantity_On_Hand =0 )
 as T;


-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores.

			Delimiter $$
			CREATE PROCEDURE get_clients_by_city (IN CityIn varchar(30))

			Begin
			Select * from clients where city=CityIn;
			End$$
			Delimiter ;
			call get_clients_by_city("Hanoi");

-- 12. Drop get_clients _by_city () procedure stores.
-- 3
drop procedure get_clients_by_city;
-- 13. Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”.
Delimiter $$
CREATE PROCEDURE update_the_delivery_status (IN Order_NumberIN varchar(30), StatusIn varchar(30))

Begin
update salesorder so set so.Delivery_Status =StatusIn where so.Order_Number=Order_NumberIN;
Select * from salesorder where Order_Number=Order_NumberIN;
End$$
Delimiter ;
call update_the_delivery_status("O20006","On Way");
call update_the_delivery_status("O20008","On Way");
drop procedure update_the_delivery_status;

-- 14. Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
CREATE PROCEDURE Store_Product()
Begin
Select Product_Number,Product_Name,Total_Quantity from product;
End$$
Delimiter ;
call Store_Product();
drop procedure Store_Product;

-- 15. Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
CREATE PROCEDURE Update_Remarks(Salesman_NumberIn varchar(15),remarksIn varchar(15))
Begin
update salesman set remarks =remarksIn where Salesman_Number=Salesman_NumberIn;
Select Salesman_Number,remarks from salesman;
End$$
Delimiter ;
call Update_Remarks("S008","Bad");
drop procedure Update_Remarks;

-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
CREATE PROCEDURE find_clients(Client_NumberIn varchar(15))
Begin
select * from clients where Client_Number=Client_NumberIn;
End$$
Delimiter ;
call find_clients("C101");
drop procedure find_clients;
select * from clients;

-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name,
-- salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman
-- table.
Delimiter $$
CREATE PROCEDURE salary_salesman(LimitIn int)
Begin
select Salesman_Number,Salesman_Name,Salary from salesman where Salary>15000
limit LimitIn ;
End$$
Delimiter ;
call salary_salesman(2);
call salary_salesman(4);
drop procedure salary_salesman;

-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
CREATE PROCEDURE MAX_SALARY()
Begin
select max(Salary) from salesman;
End$$
Delimiter ;
call MAX_SALARY();

drop procedure MAX_SALARY;

-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder
-- table.
Delimiter $$
CREATE PROCEDURE find_OrderStatus(In Order_StatusIn varchar(30))
Begin
select * from salesorder where Order_Status=Order_StatusIn ;
End$$
Delimiter ;
call find_OrderStatus("Successful");

drop procedure find_OrderStatus;

-- 20. Create a stored procedure to calculate and update the discount rate for orders.
Delimiter $$
CREATE PROCEDURE calculate_and_update_the_discount_rate(In ProductNumberIN varchar(30),DiscountRateIN int)
Begin
update product set Discount_Rate=DiscountRateIN where Product_Number=ProductNumberIN;
select * from product where Product_Number=ProductNumberIN ;
End$$
Delimiter ;
call calculate_and_update_the_discount_rate('P1001',100);

drop procedure calculate_and_update_the_discount_rate;

-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;SALARY = 20000.
Select count(*) `Salary <20000` from salesman where salary <20000;
Select count(*) `Salary >20000` from salesman where salary >20000;
Select count(*) `Salary =20000` from salesman where salary =20000;

-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.

drop procedure totalSales;
Delimiter $$
CREATE PROCEDURE totalSales(In Salesman_NumberIN varchar(30))
Begin

select sum(Order_Quantity) from salesman s inner join
salesorder so on so.Salesman_Number =s.Salesman_Number inner join
salesorderdetails sod on sod.Order_Number=so.Order_Number
where s.Salesman_Number=Salesman_NumberIN;
End$$
Delimiter ;
call totalSales('S001');



-- 23. Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
drop procedure AddProduct;
Delimiter $$
CREATE PROCEDURE AddProduct(In Product_NumberIN varchar(15), Product_NameIN varchar(25), Quantity_On_HandIN int, Quantity_SellIN int, Sell_PriceIN DECIMAL(15 , 4 ), Cost_PriceIN DECIMAL(15 , 4 ))
Begin

 INSERT INTO product (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price)
    VALUES (Product_NumberIN, Product_NameIN, Quantity_On_HandIN, Quantity_SellIN, Sell_PriceIN, Cost_PriceIN);
End$$
Delimiter ;
call AddProduct('P001','Product A', 100, 10, 20.50, 15.00);
select * from product;


-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
drop procedure CalculateOrderValueAndClassification;
DELIMITER $$
CREATE PROCEDURE CalculateOrderValueAndClassification(
    IN p_Order_Number varchar(15),
    OUT p_TotalValue DECIMAL(10, 2),
    OUT p_OrderStatus VARCHAR(10)
)
BEGIN
    declare v_Product_Number varchar(15);
    declare v_Order_Quantity int;
    declare v_Sell_Price decimal(15, 4);
    declare v_TotalValue decimal(15, 4) default 0;
    declare done int default 0;

    -- Declare cursor to iterate over products in the order
    DECLARE cur_OrderDetails CURSOR FOR
    SELECT p.Sell_Price, sod.Order_Quantity
    FROM SalesOrderDetails sod
    inner join product p on
    p.Product_Number= sod.Product_Number
    WHERE Order_Number = sod.Order_Number;

    -- Declare a handler to handle the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur_OrderDetails;

    -- Loop through the products in the order
    read_loop: LOOP
        FETCH cur_OrderDetails INTO v_Sell_Price, v_Order_Quantity;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the total value
        SET v_TotalValue = v_TotalValue + (v_Sell_Price * v_Order_Quantity);
    END LOOP;

    SET p_TotalValue = v_TotalValue;
    -- Close the cursor
    CLOSE cur_OrderDetails;

    -- Classify the order based on the total value
    CASE
        WHEN v_TotalValue >= 10000 THEN
            SET p_OrderStatus = 'Large';
        WHEN v_TotalValue >= 5000 THEN
            SET p_OrderStatus = 'Medium';
        ELSE
            SET p_OrderStatus = 'Small';
    END CASE;
END $$

DELIMITER ;
CALL CalculateOrderValueAndClassification('O20015', @TotalValue, @OrderStatus);
SELECT @TotalValue AS TotalValue, @OrderStatus AS OrderStatus;


