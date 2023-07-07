--This data is based on Microsoft's AdventureWorks database.
--Customer(CustomerID, FirstName, MiddleName, LastName, CompanyName, EmailAddress)
--CustomerAddress(CustomerID, AddressID, AddressType)
--Address(AddressID, AddressLine1, AddressLine2, City, StateProvince, CountyRegion, PostalCode)
--SalesOrderHeader(SalesOrderID, RevisionNumber, OrderDate, CustomerID, BillToAddressID, ShipToAddressID, ShipMethod, SubTotal, TaxAmt, Freight)
--SalesOrderDetail(SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
--Product(ProductID, Name, Color, ListPrice, Size, Weight, ProductModelID, ProductCategoryID)
--ProductModel(ProductModelID, Name)
--ProductCategory(ProductCategoryID, ParentProductCategoryID, Name)
--ProductModelProductDescription(ProductModelID, ProductDescriptionID, Culture)
--ProductDescription(ProductDescriptionID, Description)

--======================================================================================
-- EASY 
--======================================================================================
--1. Show the first name and the email address of customer with CompanyName 'Bike World'

--2. Show the CompanyName for all customers with an address in City 'Dallas'.

--3. How many items with ListPrice more than $1000 have been sold?

--4. Give the CompanyName of those customers with orders over $100000. 
--   Include the subtotal plus tax plus freight.

--5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'

--======================================================================================
-- MEDIUM
--======================================================================================
--6. A "Single Item Order" is a customer order where only one item is ordered. 
--   Show the SalesOrderID and the UnitPrice for every Single Item Order.

--7. Where did the racing socks go? List the product name and the CompanyName for
--   all Customers who ordered ProductModel 'Racing Socks'.

--8. Show the product description for culture 'fr' for product with ProductID 736.

--9. Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. 
--   For each order show the CompanyName and the SubTotal and the total weight of the order.

--10. How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

--======================================================================================
-- HARD
--======================================================================================
--11. For every customer with a 'Main Office'
--    in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address
--    - if there is no shipping address leave it blank. Use one row per customer.

--12. For each order show the SalesOrderID and SubTotal calculated three ways:
--		A) From the SalesOrderHeader
--		B) Sum of OrderQty*UnitPrice
--		C) Sum of OrderQty*ListPrice

--13. Show the best selling item by value.

--14. Show how many orders are in the following ranges (in $):
--RANGE      Num Orders      Total Value
--    0-  99
--  100- 999
-- 1000-9999
--10000-

--15. Identify the three most important cities. 
--    Show the break down of top level product category against city.

--======================================================================================
-- RESIT
--======================================================================================
--1. List the SalesOrderNumber for the customer 'Good Toys' 'Bike World'

--2. List the ProductName and the quantity of what was ordered by 'Futuristic Bikes'

--3. List the name and addresses of companies containing the word 'Bike' (upper or lower case) and
--   companies containing 'cycle' (upper or lower case). Ensure that the 'bike's are listed before
--   the 'cycles's.

--4. Show the total order value for each CountryRegion. List by value with the highest first.

--5. Find the best customer in each region.

