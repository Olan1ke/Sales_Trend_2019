-- Cleaning February Table
-- 1. Create another table
select 
  concat(  
    datepart(day, Order_ID),
    datepart(month, Order_ID),
    right( datepart(year, Order_ID), 2)
  ) as order_id,
  Product,
  Quantity_Ordered,
  Price_Each,
  Order_Date,
  Purchase_Address
into sales_feb_2019
from Sales_February_2019 ;
  
  Select * From sales_feb_2019;

 -- 2. Populate the table

 Select a.order_id, a.Price_Each,b.order_id,b.Price_Each
 From sales_feb_2019 a
 join sales_feb_2019 b
 on a.order_id=b.order_id
 And a.Price_Each <> b.Price_Each
Where a.order_id = ' ';