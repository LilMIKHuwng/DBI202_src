CREATE DATABASE Sales;
GO
use Sales;
go

CREATE TABLE "Employees" (
	"EmployeeID" "int" IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	"LastName" nvarchar (20) NOT NULL ,
	"FirstName" nvarchar (10) NOT NULL ,
	"BirthDate" "datetime" NULL CHECK (BirthDate < getdate())
)

CREATE TABLE Customers (
    CustomerID int IDENTITY(1, 1) PRIMARY KEY,
    CustomerName VARCHAR(255),
    ContactName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(10),
    Country VARCHAR(50)
)

CREATE TABLE "Orders" (
	"OrderID" "int" IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	"CustomerID" int NULL FOREIGN KEY("CustomerID") REFERENCES Customers("CustomerID"),
	"EmployeeID" "int" NULL FOREIGN KEY("EmployeeID") REFERENCES Employees("EmployeeID"),
	"OrderDate" "datetime" default getdate() 
)

INSERT INTO Employees VALUES('Davolio','Nancy','1968-12-08');
INSERT INTO Employees VALUES('Fuller','Andrew','1952-02-19');
INSERT INTO Employees VALUES('Leverling','Janet','1963-08-30');

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country) VALUES
('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway'),
('Greasy Burger', 'Per Olsen', 'Gateveien 15', 'Sandnes', '4306', 'Norway'),
('Tasty Tee', 'Finn Egan', 'Streetroad 19B', 'Liverpool', 'L1 0AA', 'UK');

INSERT INTO Orders VALUES(1,1,'1996-07-04');
INSERT INTO Orders VALUES(1,1,'1996-07-05');
INSERT INTO Orders VALUES(1,1,'1996-07-08');
INSERT INTO Orders VALUES(2,1,'1996-07-08');
INSERT INTO Orders VALUES(2,2,'1996-07-09');

-- Select ex 1 show all column from table
Select * From "Employees";
Select * From Orders;
Select * From Customers;

-- Select distinct(không trùng) 
Select Country from Customers;

Select Distinct Country from Customers;

-- Select all from Where ( and or )
Select * From Customers where Country='UK' and City='Sandnes';

-- Select count() As[nameColumn] , attri from table group by attri
Select Count(CustomerID) As [Number of Country], Country from Customers Group By Country;
Select Count(CustomerID) from Customers;

-- Select Having là điều kiện nhóm
Select Count(CustomerID), Country From Customers Group By Country Having Count(CustomerID)>=2;
-- Count không dùng cho where
Select Count(CustomerID), Country From Customers Where Count(CustomerID)>=2 Group By Country;
Select Count(Country) cnt From Customers Where Country = 'Norway';
-- 
Select Count(CustomerID) cnt, CustomerName From Customers;

-- Sắp xếp bởi tên tăng dần và giảm dần bởi City
Select CustomerID, Country From Customers Order By CustomerName;
Select CustomerID, Country From Customers Order By CustomerName, City desc;

-- 
Select  Top 2 * From Customers Order By CustomerName desc;

-- Select column_name from table1 Inner Join / Left Join / Right Join  table2 on table1.column_name = table2.column_name
Select OrderID, Orders.CustomerID, CustomerName from Orders Inner Join Customers on Orders.CustomerID = Customers.CustomerID;

-- Left join / is null
Select OrderID, Customers.CustomerID, CustomerName from Customers  Left Join Orders on Orders.CustomerID = Customers.CustomerID where OrderID is null;

-- Right join / 

-- Seft join / 
alter Table Employees 
add SupervisorID int;

update Employees
set SupervisorID = 1
where EmployeeID in (2,3);

--
Select a.EmployeeID, a.FirstName as 'Employee Name', b.EmployeeID as 'Supervisor ID', b.FirstName as 'Supervisor Name'
from Employees a, Employees b
where a.SupervisorID = b.EmployeeID;

-- ID / Country
Select a.CustomerID, a.CustomerName, a.Country 
from Customers a, Customers b
where a.Country = b.Country and a.CustomerID <> b.CustomerID;

--
Select OrderID, CustomerName, FirstName +' '+ LastName EmployeeName, OrderDate 
from Employees e
inner join Orders o on e.EmployeeID = o.EmployeeID
inner join Customers c on c.CustomerID = o.CustomerID;

-- hiển thị danh sách sản phẩm cùng nhãn hàng có giá >=1000
-- 
Select product_name, list_price
from production.products
where list_price > (
	Select AVG (list_price)
	from production.products
	where
		brand_id in (
			Select brand_id
			from production.brands
			where brand_name = 'Strider' or brand_name = 'Trek'
		)
)
order by list_price;

--
Select order_id, order_date,
	( 
	Select MAX (list_price) 
	from sales.order_items i
	where i.order_id = o.order_id
) as max_list_price
from sales.orders o
order by order_id desc;

--
Select 
	AVG(CAST(order_count as float)) average_order_count_by_staff
from
(
	Select	
		staff_id,
		COUNT(order_id) order_count
	from
		Sales.orders
	Group by
		staff_id
) t;

-- 
select CustomerID, first_name, last_name, city 
from Customers inner join Orders 
on Customers.CustomerID=Orders.CustomerID 
where YEAR(order_date) = 2017;

--
Select CustomerID, first_name, last_name, city
from sales.customers c
where 
	exists(
		select customer_id
		from sales.orders o
		where o.customer_id = c.customer_id and Year(order_date)=2017
	)
order by first_name, last_name;

-- 
Select staff_id, COUNT(order_id) order_count
from sales.orders
group by staff_id
having COUNT(order_id) >= ALL (
	Select COUNT(order_id) order_count
	from sales.orders
	group by staff_id
);

-- cùng City khác ID
SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID <> B.CustomerID
AND A.City = B.City
ORDER BY A.City;

Select GETDATE();
Select format(getdate(), 'dd/MM/yyyy');