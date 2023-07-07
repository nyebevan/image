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

-- use this code as a template when needing to do multi table join.
-- just comment out thos etables not needed.
--select *
--from SalesLT.Customer c
--join	SalesLT.CustomerAddress ca
--	on c.CustomerID = ca.CustomerID
--join	SalesLT.Address a
--	on ca.AddressID = a.AddressID
--join SalesLT.SalesOrderHeader oh
--	on c.CustomerID = oh.CustomerID
--join SalesLT.SalesOrderDetail od
--	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on od.ProductID = p.ProductID
--join SalesLT.ProductCategory pc
--	on p.ProductCategoryID = pc.ProductCategoryID
--join SalesLT.Address ads
--	on oh.ShipToAddressID = ads.AddressID

--======================================================================================
-- EASY 
--======================================================================================
--1. Show the first name and the email address of customer with CompanyName 'Bike World'
select FirstName, EmailAddress
from SalesLT.Customer
where CompanyName = 'Bike World'
group by FirstName, EmailAddress

--2. Show the CompanyName for all customers with an address in City 'Dallas'.
select CompanyName
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
where a.City = 'Dallas'

--3. How many items with ListPrice more than $1000 have been sold?
select COUNT(*)
from SalesLT.SalesOrderHeader oh
join	SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on p.ProductID = od.ProductID
where p.ListPrice > 1000

--4. Give the CompanyName of those customers with orders over $100000. 
--   Include the subtotal plus tax plus freight.
select c.CompanyName, oh.TotalDue
from SalesLT.SalesOrderHeader oh
--join	SalesLT.SalesOrderDetail od
--	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on p.ProductID = od.ProductID
join SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
where oh.TotalDue > 100000

-- since there are only 32 orders and each order is a unique cistomer then the following code
-- is not really necessary since group by aggregates the sales for each customer
-- but if there is only one order for each customer aggregate is not needed and where works
select count(distinct CustomerID) from SalesLT.SalesOrderHeader
select c.CompanyName, sum( oh.TotalDue )
from SalesLT.SalesOrderHeader oh
--join	SalesLT.SalesOrderDetail od
--	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on p.ProductID = od.ProductID
join SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
	group by c.CompanyName
having  sum(oh.TotalDue) > 100000

--5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
select c.CompanyName, p.Name, od.OrderQty
from SalesLT.SalesOrderHeader oh
join	SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on p.ProductID = od.ProductID
join SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
where p.Name = 'Racing Socks, L'
and
c.CompanyName = 'Riding Cycles'
--======================================================================================
-- MEDIUM
--======================================================================================
--6. A "Single Item Order" is a customer order where only one item is ordered. 
--   Show the SalesOrderID and the UnitPrice for every Single Item Order.
select  od.SalesOrderID
	, od.UnitPrice
	--,  count(od.SalesOrderDetailID)
from SalesLT.SalesOrderHeader oh
join	SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on p.ProductID = od.ProductID
join SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
group by od.SalesOrderID, od.UnitPrice
having  count(od.SalesOrderDetailID) = 1


--7. Where did the racing socks go? List the product name and the CompanyName for
--   all Customers who ordered ProductModel 'Racing Socks'.
select p.Name, c.CompanyName
from SalesLT.SalesOrderHeader oh
join	SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on p.ProductID = od.ProductID
join SalesLT.ProductModel pm
	on p.ProductModelID = pm.ProductModelID
join SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
where pm.Name = 'Racing Socks'


--8. Show the product description for culture 'fr' for product with ProductID 736.
select pd.Description
from SalesLT.ProductModelProductDescription pmd
join	SalesLT.ProductModel pm
	on pmd.ProductModelID = pm.ProductModelID
join	SalesLT.ProductDescription pd
	on pmd.ProductDescriptionID = pd.ProductDescriptionID
join	SalesLT.Product p
	on p.ProductModelID = pm.ProductModelID
where p.ProductID = 736
and Culture = 'Fr'


--9. Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. 
--   For each order show the CompanyName and the SubTotal and the total weight of the order.
select c.CompanyName,  oh.SubTotal, sum(p.Weight * od.orderqty) as [Total Weight]
from SalesLT.SalesOrderHeader oh
join	SalesLT.Customer c
	on c.CustomerID = oh.CustomerID
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
group by c.CompanyName,  oh.SubTotal
order by oh.SubTotal

--10. How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?
select SUM ( od.OrderQty) [Cranksets sold in London]
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
join SalesLT.ProductCategory pc
	on p.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Cranksets' and  a.City = 'London'

select SUM ( od.OrderQty) [Cranksets sold in London]
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
join SalesLT.ProductCategory pc
	on p.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Cranksets' and  a.City = 'London'



--======================================================================================
-- HARD
--======================================================================================
--11. For every customer with a 'Main Office'
--    in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address
--    - if there is no shipping address leave it blank. Use one row per customer.
select a.AddressLine1 as [Main Office], ads.AddressLine1 as [Ship Address]
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
--join SalesLT.SalesOrderDetail od
--	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on od.ProductID = p.ProductID
--join SalesLT.ProductCategory pc
--	on p.ProductCategoryID = pc.ProductCategoryID
join SalesLT.Address ads
	on oh.ShipToAddressID = ads.AddressID
where 
	ca.AddressType = 'Main Office'
and 
	a.City = 'Daly City'

select c.CustomerID, ca.AddressType, a.city
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
--join SalesLT.SalesOrderDetail od
--	on oh.SalesOrderID = od.SalesOrderID
--join SalesLT.Product p
--	on od.ProductID = p.ProductID
--join SalesLT.ProductCategory pc
--	on p.ProductCategoryID = pc.ProductCategoryID
--join SalesLT.Address ads
--	on oh.ShipToAddressID = ads.AddressID
where 
	ca.AddressType = 'Main Office'
and 
	a.City = 'Daly City'

select * from SalesLT.CustomerAddress
--12. For each order show the SalesOrderID and SubTotal calculated three ways:
--		A) From the SalesOrderHeader
select oh.SalesOrderID, oh.SubTotal
from SalesLT.SalesOrderHeader oh

--		B) Sum of OrderQty*UnitPrice
select oh.SalesOrderID, SUM( od.orderqty * od.unitprice)
from SalesLT.SalesOrderHeader oh
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
group by oh.SalesOrderID

--		C) Sum of OrderQty*ListPrice
select oh.SalesOrderID, SUM( od.orderqty * p.ListPrice)
from SalesLT.SalesOrderHeader oh
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
group by oh.SalesOrderID

--13. Show the best selling item by value.
select  top 1 p.name, SUM(od.orderqty * od.unitprice ) as [Total Value of Sales]
from SalesLT.SalesOrderHeader oh
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
group by p.name
order by [Total Value of Sales] desc

--14. Show how many orders are in the following ranges (in $):
--RANGE      Num Orders      Total Value
--    0-  99
--  100- 999
-- 1000-9999
--10000-
select 
case
	when TotalDue between 0 and 99 then '0-99'
	when TotalDue between 100 and 999 then '100-999'
	when TotalDue between 1000 and 9999 then '1000-9999'
	else '10000-'
end as 'Order Value'
, count(*) as 'Number'
from SalesLT.SalesOrderHeader
group by
case
	when TotalDue between 0 and 99 then '0-99'
	when TotalDue between 100 and 999 then '100-999'
	when TotalDue between 1000 and 9999 then '1000-9999'
	else '10000-'
end


--15. Identify the three most important cities. 
--    Show the break down of top level product category against city.
--presumambly this means in terms of sales? if so...
select p.ProductCategoryID as 'child', p.ParentProductCategoryID as 'parent'
from SalesLT.ProductCategory c
cross join SalesLT.ProductCategory p
where p.ParentProductCategoryID is not null
on c.ParentProductCategoryID = p.ParentProductCategoryID

select oh.TotalDue, pc.name as 'Category', a.City
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
join SalesLT.ProductCategory pc
	on p.ProductCategoryID = pc.ProductCategoryID
where pc.Name in (
	select Name from SalesLT.ProductCategory where ParentProductCategoryID is null
)
group by grouping sets (  a.City, pc.name)

--======================================================================================
-- RESIT
--======================================================================================
--1. List the SalesOrderNumber for the customer 'Good Toys' 'Bike World'
select oh.SalesOrderID
from SalesLT.SalesOrderHeader oh
--where oh.CustomerID in (
--	select CustomerID from SalesLT.Customer where CompanyName in ('Good Toys', 'Bike World')
--)

join SalesLT.Customer c
on oh.CustomerID = c.CustomerID
where c.CompanyName in ('Good Toys', 'Bike World')

select CustomerID from SalesLT.Customer where CompanyName in ('Good Toys', 'Bike World')

--2. List the ProductName and the quantity of what was ordered by 'Futuristic Bikes'
select p.Name, od.OrderQty
from SalesLT.SalesOrderHeader oh
	join SalesLT.Customer c
		on oh.CustomerID = c.CustomerID
	join SalesLT.SalesOrderDetail od
		on od.SalesOrderID = oh.SalesOrderID
	join SalesLT.Product p
		on p.ProductID = od.ProductID
where c.CompanyName = 'Futuristic Bikes'

--3. List the name and addresses of companies containing the word 'Bike' (upper or lower case) and
--   companies containing 'cycle' (upper or lower case). Ensure that the 'bike's are listed before
--   the 'cycles's.
select c.CompanyName, a.AddressLine1, a.AddressLine2, a.City, a.CountryRegion, a.PostalCode
, PATINDEX( '%bike%', c.CompanyName) as 'bike'
from SalesLT.Customer c
	join SalesLT.CustomerAddress ca
		on c.CustomerID = ca.CustomerID
	join SalesLT.Address a
		on ca.AddressID = a.AddressID
where lower(c.CompanyName) like '%bike%'
or lower(c.CompanyName) like '%cycle%'
order by bike desc

--4. Show the total order (SalesOrderHeader) value for each CountryRegion (Address). List by value with the highest first.
select sum(oh.TotalDue), a.CountryRegion 
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.Address ads
	on oh.ShipToAddressID = ads.AddressID
group by a.CountryRegion;



--5. Find the best customer in each region.
select sum(oh.TotalDue), a.CountryRegion 
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.Address ads
	on oh.ShipToAddressID = ads.AddressID
group by a.CountryRegion;


--
create view vw_demo as (
select *
from SalesLT.Customer c
join	SalesLT.CustomerAddress ca
	on c.CustomerID = ca.CustomerID
join	SalesLT.Address a
	on ca.AddressID = a.AddressID
join SalesLT.SalesOrderHeader oh
	on c.CustomerID = oh.CustomerID
join SalesLT.SalesOrderDetail od
	on oh.SalesOrderID = od.SalesOrderID
join SalesLT.Product p
	on od.ProductID = p.ProductID
join SalesLT.ProductCategory pc
	on p.ProductCategoryID = pc.ProductCategoryID
join SalesLT.Address ads
	on oh.ShipToAddressID = ads.AddressID )