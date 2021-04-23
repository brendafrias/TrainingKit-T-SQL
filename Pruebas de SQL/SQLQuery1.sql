--SELECT--
--TRAER TODO--
--select * from Orders --

--Traer columnas especificas--
--select OrderID, CustomerID, ShipCity from Orders--

--WHERE--
--condicion especifica para una consulta--
--select * from Customers--
--Traer nombres de companias que empiecen con b--
/*
select * from Customers
where CompanyName like 'B%'
*/
--like es como poner =, luego entre comillas ponemos la letra que queremos buscar y %--
/*
select * from Customers
where CustomerID like 'BLAUS'
*/

--ORDER BY--
--ordena el resultado de un select por un campo que espesifique--

--Ordenados segun el contactName--
/*
select * from Customers
where CompanyName like 'B%'
order by ContactName
*/
--ordenado de la z a la a--
/*
select * from Customers
where CompanyName like 'B%'
order by ContactName desc
*/


--GROUP BY--
--permite seleccionar un grupo de registros en base a una consulta select--
--contar cuantos productos tiene cada supplerid--
--para agregar un alias usamos as--
/*
select * from products

select supplierID, COUNT(SupplierID) AS Cantidad
from Products
group by supplierID
order by Cantidad desc
*/


--HAVING--
--filtro en base a datos que ya estan agrupados--
/*
select * from [Order Details]

select OrderID, COUNT(OrderID) AS Cantidad
from [Order Details]
group by OrderID
having Count(*)>2
order by Cantidad desc
*/

--SUB CONSULTAS CON WHERE--
--puedo seleccionar una columna desde otra table usando el where que este relacionada con la primera--
--para ver si estan relacionadas vamos a diagramas de bases de datos--
--creo un nuevo diagrama de base de datos seleccion todas las columnas que quiero usar--

USE [Northwind] EXEC sp_changedbowner 'SA';

select * from Products
select * from Categories
select * from [Order Details]
select * from Suppliers

--ahora seleccionamos algunas columnas de la primera tabla--
select ProductID, ProductName, CategoryID,
		(select CategoryName from Categories
		where CategoryID=Products.CategoryID) as Categoria, --con where indicamos que tienen en comun--
		(select CompanyName from Suppliers
		where SupplierID= Products.SupplierID) as Proveedor,
		(select SUM (UnitPrice) from [Order Details]
		where ProductID = Products.ProductID) as precio
from Products
Order by ProductID

--SUB CONSULTAS CON JOINS--
--Unen cualquier tabla que queramos que tengan algun dato en comun--
select Products.ProductID, ProductName, Products.CategoryID, Categories.CategoryName as Categoria, Suppliers.CompanyName as Proveedor, SUM ([Order Details].UnitPrice) as precio


from Products join Categories on Products.CategoryID=Categories.CategoryID
			  join Suppliers on Products.SupplierID = Suppliers.SupplierID
			  join [Order Details] on Products.ProductID = [Order Details].ProductID

group by Products.ProductID, ProductName, Products.CategoryID, Categories.CategoryName, Suppliers.CompanyName
Order by ProductID
