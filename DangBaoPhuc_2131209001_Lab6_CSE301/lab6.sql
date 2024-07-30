use SaleManagerment;



-- 1. How to check constraint in a table?

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'clients';
-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information
-- about product name and its buying price.
create table ProductCost as select Product_Name,Cost_Price from product;
select * from ProductCost;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter table product add column profit float;
select * from product;
update product set profit=(Sell_Price-Cost_Price)/Cost_Price*100;

-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.

alter table salesman add column remarks varchar(15);
update salesman
set remarks = case when Target_Achieved/Sales_Target >=0.75 then 'Good'
 else case when Target_Achieved/Sales_Target>=0.5 then 'Average' else 'Poor'end end ;
 
 
select * from salesman;

-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
-- 7. Find the total quantity for each product. (Query)
select Quantity_On_Hand+Quantity_Sell as total  from product ; 

-- 8. Add a new column and find the total quantity for each product.
alter table product add column Total_Quantity int;
update product 
set Total_Quantity= Quantity_On_Hand+Quantity_Sell;
select * from product;

-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
alter table product add column Discount_Rate int;
update product 
set Discount_Rate=case when Quantity_On_Hand>10 then 10 else 5 end;
-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is
-- between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
update product 
set Discount_Rate=case when Quantity_On_Hand>=20 then 10 else case when Quantity_On_Hand>=10 then 5
else case when  Quantity_On_Hand>5 then 3 else 0 end end end;

-- 11. The first number of pin code in the client table should be start with 7.

alter table clients add constraint check_Pincode
 check(Pincode like '7%');


-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.

create view clients_view as select * from clients where city like 'Thu Dau Mot';
select * from clients_view;
-- 13. Drop the “client_view”.
drop view if exists clients_view;

-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
drop view if exists clients_order;
create view clients_order as select c.*,sod.* from clients c  join salesorder so on
 so.Client_Number=c.Client_Number  join  salesorderdetails sod on sod.Order_Number=so.Order_Number
 where city like 'Thu Dau Mot';
select * from clients_order;


-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average
-- sell price.
drop view if exists Product_view;
create view Product_view as select * from product p
where p.Sell_Price > (select avg(Sell_Price) from product);
select * from Product_view;
-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,
-- product price, quantity order) were sold by them.
drop view if exists salesman_view;
create view salesman_view as select s.*,p.Product_Name,p.Cost_Price,sod.Order_Quantity from product p
inner join salesorderdetails sod on sod.Product_Number=p.Product_Number
inner join salesorder so on so.Order_Number =sod.Order_Number
inner join salesman s on  s.Salesman_Number=so.Salesman_Number;

select * from salesman_view;
-- 17. Creates a view name as sale_view that show all salesman information and product (product names,
-- product price, quantity order) were sold by them with order_status = 'Successful'.
drop view if exists sale_view;
create view sale_view as select s.*,p.Product_Name,p.Cost_Price,sod.Order_Quantity from product p
inner join salesorderdetails sod on sod.Product_Number=p.Product_Number
inner join salesorder so on so.Order_Number =sod.Order_Number
inner join salesman s on  s.Salesman_Number=so.Salesman_Number
where so.Order_Status ='Successful';

select * from sale_view;

-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
drop view if exists sale_amount_view;
CREATE VIEW sale_amount_view AS
    SELECT 
        s.*,sum(sod.Order_Quantity)
    FROM
        product p
            INNER JOIN
        salesorderdetails sod ON sod.Product_Number = p.Product_Number
            INNER JOIN
        salesorder so ON so.Order_Number = sod.Order_Number
            INNER JOIN
        salesman s ON s.Salesman_Number = so.Salesman_Number
    WHERE
        so.Order_Status = 'Successful'
	group by  s.Salesman_Number
    having sum(sod.Order_Quantity)>=20;

select * from sale_amount_view;

-- II. Additional assignments about Constraint
-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
alter table clients add constraint check_paid_due
check (Amount_Paid>=0 and Amount_Due>=0);


-- 20. Remove the constraint from pincode;
alter table clients drop constraint check_Pincode;



-- 21. The sell price and cost price should be unique.
alter table product add constraint check_unique_sellcost
 unique(Sell_Price , Cost_Price);

-- 22. The sell price and cost price should not be unique.
alter table product drop constraint check_unique_sellcost;

-- 23. Remove unique constraint from product name.
alter table product drop constraint Product_Name;

-- 24. Update the delivery status to “Delivered” for the product number P1007.
update salesorder so join salesorderdetails sod on sod.Order_Number = so.Order_Number 
set so.Delivery_Status='Delivered'
where sod.Product_Number = "P1007" ;


-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
-- 3
update clients c  
set c.Address='Phu Hoa', c.City='Thu Dau Mot'
where c.Client_Number='C104' ;

-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
alter table Product add column Exp_Date date;

-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table Clients add column Phone varchar(15);

-- 28. Update remarks as “Good” for all salesman.
update salesman 
set remarks= 'Good';

-- 29. Change remarks to "bad" whose salesman number is "S004".
update salesman 
set remarks= 'Bad'
where Salesman_Number='S004' ;

-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table Clients modify Phone varchar(10);

-- 31. Delete the “Phone” column from “Clients” table.
alter table Clients drop Phone;
-- 32. alter table Clients drop column Phone;
alter table Clients drop Phone;
-- 33. Change the sell price of Mouse to 120.
update product 
set Sell_price=120
where product_Name='Mouse' ;
-- 34. Change the city of client number C104 to “Ben Cat”.
update clients c  
set c.City='Ben Cat'
where c.Client_Number='C104' ;
-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15%
-- discount. Othrwise, no discount.
update product 
set Discount_Rate=case when Quantity_On_Hand>5 then 10 else case when Quantity_On_Hand>10 then 15
else 0 end end;
