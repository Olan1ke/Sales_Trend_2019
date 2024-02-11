
Select * From Sales_January_2019;
Select * From Sales_February_2019;
Select * From Sales_March_2019;
Select * From Sales_April_2019;
Select * From Sales_May_2019;
Select * From Sales_June_2019;
Select * From Sales_July_2019;
Select * From Sales_August_2019;
Select * From Sales_September_2019;
Select * From Sales_October_2019;
Select * From Sales_November_2019;
Select * From Sales_December_2019;

---- Cleaning the dataset
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

--- Joining the tables

-----Use Union to combine all the tables

Select * From Sales_January_2019
Union All
Select * From sales_feb_2019
Union All
Select * From Sales_March_2019
Union All
Select * From Sales_April_2019
Union All
Select * From Sales_May_2019
Union All
Select * From Sales_June_2019
Union All
Select * From Sales_July_2019
Union All
Select * From Sales_August_2019
Union All
Select * From Sales_September_2019
Union All
Select * From Sales_October_2019
Union All
Select * From Sales_November_2019
Union All
Select * From Sales_December_2019;

----Create another tables

Create table Combined_Sales_2019(Order_Id int,Product nvarchar(50),
Quality_Ordered tinyint,Price_Each float,order_Date datetime2(7),
Purchased_Address nvarchar(50))

Insert Into Combined_Sales_2019
Select * From Sales_January_2019
Union All
Select * From sales_feb_2019
Union All
Select * From Sales_March_2019
Union All
Select * From Sales_April_2019
Union All
Select * From Sales_May_2019
Union All
Select * From Sales_June_2019
Union All
Select * From Sales_July_2019
Union All
Select * From Sales_August_2019
Union All
Select * From Sales_September_2019
Union All
Select * From Sales_October_2019
Union All
Select * From Sales_November_2019
Union All
Select * From Sales_December_2019
Where Order_ID is not null;

Select * From Combined_Sales_2019;

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

---Data Modelling

--- 1. Create a Month column

Alter Table Combined_Sales_2019
Add Month varchar(50);
  
UPDATE Combined_Sales_2019
SET Month = Datename(month,order_Date) ;

Select * From Combined_Sales_2019;

--- 2. Create a City column


Select
PARSENAME(Replace(Purchased_Address, ',','.'), 2)
From Combined_Sales_2019

Alter Table Combined_Sales_2019
Add City nvarchar (50);

Update Combined_Sales_2019
Set City = PARSENAME(Replace(Purchased_Address, ',','.'), 2)

Select * From Combined_Sales_2019;


--- 3. Create a revenue column

Select Quality_Ordered * Price_Each As Revenue
From Combined_Sales_2019;

Alter Table Combined_Sales_2019
Add Revenue float;

Update Combined_Sales_2019
Set Revenue = Quality_Ordered * Price_Each;

Select * From Combined_Sales_2019;


---- Problem Statement

--- As the Analyst, you are tasked to utilize your analytical and presentation skills to uncover trends and patterns for the 2019 sales year. Generate key sales metrics.

--- 1. Total Revenue for year 2019

SELECT SUM(Revenue) AS Total_Revenue_For_Year_2019
FROM Combined_Sales_2019;

--- 2. Total Quatity Sold
SELECT SUM(Quality_Ordered) AS Total_Quantity_Sold_For_Year_2019
FROM Combined_Sales_2019;

--- 3. Average price per product

SELECT Product, AVG(Revenue / Quality_ordered) AS Average_Price_Per_Product
FROM  Combined_Sales_2019
GROUP BY Product
Order By Average_Price_Per_Product Desc;

--- 4. Number of product sold
SELECT COUNT(DISTINCT Product) AS Distinct_Number_of_Products_Sold
FROM Combined_Sales_2019;


--- 5. Number sold per product
SELECT Product,COUNT(Product) AS Number_of_Products_Sold
FROM Combined_Sales_2019
Where Product is not null
GROUP BY Product
Order By Number_of_Products_Sold Desc;

--- 6. Revenue by product
SELECT Product, Sum(Revenue) As Total_Revenue_per_Product
FROM Combined_Sales_2019
Where Product is not null
GROUP BY Product
Order By Total_Revenue_per_Product Desc;

--- 7. Number of city 
SELECT COUNT(DISTINCT City) AS Distinct_Number_of_City
FROM Combined_Sales_2019;

--- The Accountant reported that we made loss in the month of April, May, June and July as compared to other month. Is this true? What happened? Show monthly sales performance


SELECT Month, SUM(Revenue) AS Total_Revenue,Sum(Quality_Ordered) As Total_Quality_Ordered
FROM Combined_Sales_2019
WHERE Month IS NOT NULL
GROUP BY Month
ORDER BY Total_Revenue DESC;

--- The Assistant manager suggested that we should place more marketing attention on the following cities - Los Angeles, New York, Atlanta, San Francisco and Seattle as they seem to generate more revenue. From the result of your analysis, do you agree with this? Should we proceed with the suggestion? 

SELECT City, SUM(Revenue) AS Total_Revenue
FROM Combined_Sales_2019
WHERE City IS NOT NULL
GROUP BY City
ORDER BY Total_Revenue DESC;
