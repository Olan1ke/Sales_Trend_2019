----Clean the combine table
--- 1. Change Price_Each to Two Decimal place

UPDATE Combined_Sales_2019
SET Price_Each = ROUND(Price_Each, 2);

--- 2. Changing the Order_date to proper format
Select Order_date, Convert(date,order_date)
From Combined_Sales_2019;

Alter Table Combined_Sales_2019
Add order_date_2 date;

Update Combined_Sales_2019
Set order_date_2 = Convert(date,order_date);

Alter Table Combined_Sales_2019
Drop Column Order_Date;

EXEC sp_rename 'Combined_Sales_2019.Order_date_2 ', 'order_date', 'COLUMN';

Select * From Combined_Sales_2019;

--- 3. Remove duplicate

WITH CTE AS (
    SELECT *,
             ROW_NUMBER() OVER 
		    (PARTITION BY Order_Id,
						  Product,
						  Quality_Ordered,
						  Price_Each,
						  Purchased_Address,
						  order_date
			ORDER BY (SELECT NULL)) AS rn
    FROM Combined_Sales_2019
)
DELETE FROM CTE WHERE rn > 1;

Select * From Combined_Sales_2019;



 ---- 4. Create a Month column

Alter Table Combined_Sales_2019
Add Month varchar(50);
  
UPDATE Combined_Sales_2019
SET Month = Datename(month,order_Date) ;

Select * From Combined_Sales_2019;

--- 5. Create a City column


Select
PARSENAME(Replace(Purchased_Address, ',','.'), 2)
From Combined_Sales_2019

Alter Table Combined_Sales_2019
Add City nvarchar (50);

Update Combined_Sales_2019
Set City = PARSENAME(Replace(Purchased_Address, ',','.'), 2)

Select * From Combined_Sales_2019;


--- 6. Create a revenue column

Select Quality_Ordered * Price_Each As Revenue
From Combined_Sales_2019;

Alter Table Combined_Sales_2019
Add Revenue float;

Update Combined_Sales_2019
Set Revenue = Quality_Ordered * Price_Each;

Select * From Combined_Sales_2019;
