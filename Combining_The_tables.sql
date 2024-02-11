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