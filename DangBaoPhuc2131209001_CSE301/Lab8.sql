use SaleManagerment;


-- 1. Create a trigger before_total_quantity_update to update total quantity of product when
-- Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004
-- have Quantity_On_Hand = 30, quantity_sell =35.
drop  trigger if exists before_total_quantity_update;
DELIMITER //

CREATE TRIGGER before_total_quantity_update
BEFORE UPDATE ON Product
FOR EACH ROW
BEGIN
  IF OLD.Quantity_On_Hand <> NEW.Quantity_On_Hand OR OLD.Quantity_Sell <> NEW.Quantity_Sell THEN
    SET NEW.Total_Quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
  END IF;
END;
//
DELIMITER ;
UPDATE Product
SET Quantity_On_Hand = 30, Quantity_Sell = 35
WHERE Product_Number = 'P1004';
select * from product 
where  Product_Number = 'P1004';
-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
alter table salesman add column PER_MARKS decimal(15,4);
Delimiter //
create trigger before_remark_salesman_update
before update on salesman
for each row
begin
 SET NEW.PER_MARKS = (Old.target_achieved * 100) / Old.Sales_Target;
end;

//
DELIMITER ;
Update salesman SET target_achieved = 80, sales_target = 100
WHERE Salesman_Number = 'S001';
select * from salesman;



-- 3. Create a trigger before_product_insert to insert a product in product table.

Delimiter //
create trigger before_product_insert
before insert on product
for each row
begin
 -- Ensure that Product_Name starts with 'P'
  IF LEFT(NEW.Product_Name, 1) <> 'P' THEN
    SET NEW.Product_Name = CONCAT('P', NEW.Product_Name);
  END IF;

  -- Ensure that all required fields are not NULL
  IF NEW.Product_Number IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Product_Number cannot be NULL';
  END IF;

  IF NEW.Product_Name IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Product_Name cannot be NULL';
  END IF;

  IF NEW.Quantity_On_Hand IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Quantity_On_Hand cannot be NULL';
  END IF;

  IF NEW.Quantity_Sell IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Quantity_Sell cannot be NULL';
  END IF;

  IF NEW.Sell_Price IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Sell_Price cannot be NULL';
  END IF;

  IF NEW.Cost_Price IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cost_Price cannot be NULL';
  END IF;

  -- Calculate profit if not provided
  IF NEW.profit IS NULL THEN
    SET NEW.profit = (NEW.Sell_Price - NEW.Cost_Price) * NEW.Quantity_Sell;
  END IF;

  -- Calculate Total_Quantity
  SET NEW.Total_Quantity = NEW.Quantity_On_Hand - NEW.Quantity_Sell;

  -- Ensure Discount_Rate is between 0 and 100
  IF NEW.Discount_Rate IS NULL THEN
    SET NEW.Discount_Rate = 0; -- Default value for Discount_Rate if not provided
  ELSEIF NEW.Discount_Rate > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Discount Rate cannot be greater than 100%';
  END IF;
  
  -- Ensure Exp_Date is not NULL if you want to enforce a default date
  IF NEW.Exp_Date IS NULL THEN
    SET NEW.Exp_Date = CURDATE() + INTERVAL 365 DAY; -- Set a default expiry date one year from now
  END IF;

  
  
end;

//
DELIMITER ;

INSERT INTO product (
    Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, 
    Sell_Price, Cost_Price
) 
VALUES (
    'P18', 'aa', 100, 20, 50.00, 30.00
);

-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as
-- "Successful".
Delimiter //
create trigger before_delivery_status_update
before update on salesorder
for each row
begin
 if New.Delivery_Status="Delivered" then set NEw.Order_Status="Successful";
 end if;
end;

//
DELIMITER ;

update salesorder set Delivery_Status="Delivered" where Order_Number='O20002';
select * from salesorder where Order_Number='O20002';




-- 	5. Create a trigger to update the remarks "Good" when a new salesman is inserted.
Delimiter //
create trigger before_remark_status_update
before insert on salesman
for each row
begin
 set New.remarks ='Good';

end;

//
DELIMITER ;



-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.

Delimiter //
create trigger before_pincode_status_update
before update on clients
for each row
begin
  IF LEFT(NEW.Pincode, 1) <> '7' THEN
   SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pincode need to start with 7  ';
  END IF;
end;

//
DELIMITER ;
-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
Delimiter //
CREATE TRIGGER after_client_delete
AFTER DELETE ON clients
FOR EACH ROW
BEGIN
  -- Update the city to 'Unknown' in the client_details table when a client is deleted
  UPDATE clients
  SET city = 'Unknown';
END;
//
DELIMITER ;	
-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product
-- table.
Delimiter //
CREATE TRIGGER after_product_insert
AFTER insert ON product
FOR EACH ROW
BEGIN
  UPDATE product
  SET profit = (Sell_Price-Cost_Price)*Quantity_Sell
  , total_quantity =total_quantity+Quantity_On_Hand ;
END;
//
DELIMITER ;	


-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
Delimiter //
CREATE TRIGGER after_deliver_order_insert
AFTER insert ON salesorder
FOR EACH ROW
BEGIN
  UPDATE salesorder
  SET Delivery_Status ='On Way';
END;
//
DELIMITER ;		


-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be ‘Good’.
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered
-- 'Poor'.
Delimiter //
CREATE TRIGGER before_remark_salesman_update_onPer_mark
Before update ON salesman
FOR EACH ROW
BEGIN
if new.PER_MARKS >=75 then set new.remarks='Good';
elseif new.PER_MARKS >=50 then set  new.remarks='Average';	
else set new.PER_MARKS='Poor';

end if;
END;
//
DELIMITER ;	

-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
Delimiter //
CREATE TRIGGER before_deliverydate_greater
Before update ON salesorder
FOR EACH ROW
BEGIN
if new.Delivery_Date >new.Order_Date then 
 SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Delivery_Date cannot be greater then Order_Date'; 
end if;
END;
//
DELIMITER ;	


-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity).
Delimiter //
CREATE TRIGGER update_Quantity_On_Hand
After update ON salesorderdetails
FOR EACH ROW
BEGIN
update product set product.Quantity_On_Hand=product.Quantity_On_Hand-salesorderdetails.Order_Quantity;
END;
//
DELIMITER ;	


-- 1. Find the average salesman’s salary.
DELIMITER $$
CREATE FUNCTION avgSalary ()
RETURNS decimal(15,4)
DETERMINISTIC
BEGIN
declare avgValue decimal(15,4);
select avg(Salary) into avgValue from salesman;
RETURN avgValue;
END$$

DELIMITER ;
SELECT avgSalary() AS average_salary;

-- 2. Find the name of the highest paid salesman.

drop  function if exists HighestPaidSalesMan;
DELIMITER $$
CREATE FUNCTION HighestPaidSalesMan()
RETURNS varchar(30)
DETERMINISTIC
BEGIN
 DECLARE salesman_nameHighest varchar(30);
    SELECT Salesman_Name INTO salesman_nameHighest
    FROM salesman
    ORDER BY salary DESC
    LIMIT 1;

    RETURN salesman_nameHighest;
END$$

DELIMITER ;

SELECT HighestPaidSalesMan() AS highest_paid_salesman_name;


-- 3. Find the name of the salesman who is paid the lowest salary.

drop  function if exists LowestPaidSalesMan;
DELIMITER $$
CREATE FUNCTION LowestPaidSalesMan()
RETURNS varchar(30)
DETERMINISTIC
BEGIN
 DECLARE salesman_nameLowest varchar(30);
    SELECT Salesman_Name INTO salesman_nameLowest
    FROM salesman
    ORDER BY salary asc
    LIMIT 1;

    RETURN salesman_nameLowest;
END$$

DELIMITER ;

select LowestPaidSalesMan() as lowest;

-- 4. Determine the total number of salespeople employed by the company.

drop  function if exists totalSalesman;
DELIMITER $$
CREATE FUNCTION totalSalesman()
RETURNS int
DETERMINISTIC
BEGIN
 DECLARE totalSalesman int;
    SELECT count(*) INTO totalSalesman
    FROM salesman;

    RETURN totalSalesman;
END$$

DELIMITER ;
select totalSalesman() as total;
-- 5. Compute the total salary paid to the company's salesman.
DELIMITER $$
CREATE FUNCTION totalSalary()
RETURNS int
DETERMINISTIC
BEGIN
 DECLARE totalSalary int;
    SELECT sum(salary) INTO totalSalary
    FROM salesman;

    RETURN totalSalary;
END$$

DELIMITER ;
select totalSalary() as totalSalary;

-- 6. Find Clients in a Province
DELIMITER $$
CREATE FUNCTION find(provinceIn varchar(30))
RETURNS text
DETERMINISTIC
BEGIN
   DECLARE client_list TEXT;
   SELECT GROUP_CONCAT(name SEPARATOR ', ') INTO client_list
    FROM clients
    WHERE province like provinceIn;
    RETURN totalSalary;
END$$

DELIMITER ;



-- 7. Calculate Total Sales
drop function if exists TotalSales;
DELIMITER $$
CREATE FUNCTION TotalSales( )
RETURNS int
DETERMINISTIC
BEGIN
   DECLARE TotalSales int;
   SELECT count(*)   into TotalSales
    FROM salesorder;

    RETURN TotalSales;
END$$

DELIMITER ;
select TotalSales() as totalSales;

-- 8. Calculate Total Order Amount

DELIMITER $$
CREATE FUNCTION TotalOrder( )
RETURNS int
DETERMINISTIC
BEGIN
   DECLARE TotalOrder int;
   SELECT sum(Order_Quantity)   into TotalOrder
    FROM salesorderdetails;

    RETURN TotalOrder;
END$$

DELIMITER ;
select TotalOrder() as TotalOrder;