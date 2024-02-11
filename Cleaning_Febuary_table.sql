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

 
