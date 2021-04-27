--Unidad 4--
--Agregar un nuevo provedor a produccion--
USE TSQL2012;
INSERT INTO Production.Suppliers
	(companyname,contactname,contacttitle,address,city,postalcode,country,phone)
	VALUES(N'Supplier XYZ',N'Jiru',N'Head of Security',N'42 Sekimai Musashino-shi',
			N'Tokio',N'01759',N'Japan',N'(02) 4311-2609');

--TABLAS CRUZADAS--
--T1 = n filas, T2 = m filas, la union entre T1 y T2 proporciona una union cruzada y da como
--resultado la siguiente tabla virtual de m x n--

--CROSS JOIN--
SELECT D.n AS theday, S.n AS shiftno 
FROM dbo.Nums AS D
 CROSS JOIN dbo.Nums AS S
WHERE D.n <= 7
 AND S.N <= 3
ORDER BY theday, shiftno;
--Es obligatorio asignarle alias a las tablas--

--UNION INTERNA--
--INNER JOINS--
SELECT S.companyname AS supplier, S.country,
		P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
	INNER JOIN Production.Products AS P
	ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

/*
la siguiente consulta une dos instancias de la
Tabla de HR.Employees para relacionar a los empleados con sus gerentes. (Un gerente también es 
un empleado, de ahí la autounión.
*/
SELECT E.empid,
 E.firstname + N' ' + E.lastname AS emp,
 M.firstname + N' ' + M.lastname AS mgr
FROM HR.Employees AS E
 INNER JOIN HR.Employees AS M
 ON E.mgrid = M.empid
 /*
 Observe el predicado de unión: ON E.mgrid = M.empid. La instancia de empleado tiene el alias E
y la instancia del administrador como M. Para encontrar las coincidencias correctas, el ID de administrador del empleado necesita
para ser igual a la identificación de empleado del gerente.
Tenga en cuenta que solo se devolvieron ocho filas a pesar de que hay nueve filas en la tabla. La
La razón es que el CEO (Sara Davis, ID de empleado 1) no tiene gerente y, por lo tanto, su administrador
la columna es NULL. Recuerde que una combinación interna no devuelve filas que no encuentran coincidencias
*/

--UNIONES EXTERNAS--
--OUTER JOINS--
--Aqui mostrara solo los que sean de Japon--
SELECT
 S.companyname AS supplier, S.country,
 P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
 LEFT OUTER JOIN Production.Products AS P
 ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--Aqui mostrara todos los paises--
SELECT
 S.companyname AS supplier, S.country,
 P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
 LEFT OUTER JOIN Production.Products AS P
 ON S.supplierid = P.supplierid
 AND S.country = N'Japan'

 --El join elimino la fila del director ejecutivo porque no encontro ningun administrador coincidente, si
 --se desea incluirlo se debe usar una convinacion extrerna que preserve el lado que representa a los empleados--
 SELECT E.empid,
 E.firstname + N' ' + E.lastname AS emp,
 M.firstname + N' ' + M.lastname AS mgr
FROM HR.Employees AS E
 LEFT OUTER JOIN HR.Employees AS M
 ON E.mgrid = M.empid
 --TSQL tambien permite una union FULL OUTER JOIN--
 --Esta preserva ambos lados--

 --No devuelve los null--
 SELECT
 S.companyname AS supplier, S.country,
 P.productid, P.productname, P.unitprice,
 C.categoryname
FROM Production.Suppliers AS S
 LEFT OUTER JOIN Production.Products AS P
 ON S.supplierid = P.supplierid
 INNER JOIN Production.Categories AS C
 ON C.categoryid = P.categoryid
WHERE S.country = N'Japan';

--Devuelve los null--
SELECT
 S.companyname AS supplier, S.country,
 P.productid, P.productname, P.unitprice,
 C.categoryname
FROM Production.Suppliers AS S
 LEFT OUTER JOIN 
 (Production.Products AS P
 INNER JOIN Production.Categories AS C
 ON C.categoryid = P.categoryid)
 ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--EJERCICIO 1--
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
 INNER JOIN Sales.Orders AS O
 ON C.custid = O.custid;

 --Combinacion externa izquierda--
 SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
 LEFT OUTER JOIN Sales.Orders AS O
 ON C.custid = O.custid;

 --Devolver solo clientes sin pedidos--
  SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
 LEFT OUTER JOIN Sales.Orders AS O
 ON C.custid = O.custid
 WHERE O.orderid IS NULL

 --Devolver todos los clientes que coincidad con los pedidos solo si se colocaron en febrero de 2008--
 SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
 LEFT OUTER JOIN Sales.Orders AS O
 ON C.custid = O.custid 
 AND O.orderdate >= '20080201'
 AND O.orderdate < '20080301';

 --Respuestas--
 --1)B,D 2)D 3)A

 --SUBQUERIES--
 --Utiliza una subconsulta autonoma para devolver los productos con el precio unitario minimo--
 SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice =
 (SELECT MIN(unitprice)
 FROM Production.Products);

 --IN Una subconsulta de varios valores para devolver productos suministrado por proveedores de Japon--
 SELECT productid, productname, unitprice
FROM Production.Products
WHERE supplierid IN
 (SELECT supplierid
 FROM Production.Suppliers
 WHERE country = N'Japan');

 --APPLY--
 /*
 Subconsultas
Las subconsultas pueden ser independientes, es decir, independientes de la consulta externa; o pueden ser
correlacionados, es decir, tener una referencia a una columna de la tabla en la consulta externa
En términos del resultado de la subconsulta, puede ser escalar, con valores múltiples o con valores de tabla.
*/

--La sigueinte subconsulta autonoma para devolver los productos con el precio unitario minimo--
SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice =
 (SELECT MIN(unitprice)
 FROM Production.Products);

 --Me quede en la pagina 118/150
