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

 
 /*
 Subconsultas
Las subconsultas pueden ser independientes, es decir, independientes de la consulta externa; o pueden ser
correlacionados, es decir, tener una referencia a una columna de la tabla en la consulta externa
En términos del resultado de la subconsulta, puede ser escalar, con valores múltiples o con valores de tabla.


devolver productos con el precio unitario mínimo
por categoría. Puede utilizar una subconsulta correlacionada para devolver el precio unitario mínimo de
los productos donde el ID de categoría es igual al de la fila exterior (la correlación), como
sigue
*/
SELECT categoryid, productid, productname, unitprice
FROM Production.Products AS P1
WHERE unitprice =
 (SELECT MIN(unitprice)
 FROM Production.Products AS P2
 WHERE P2.categoryid = P1.categoryid);
 --Para que pueda distinguir debemos usar diferentes aalias en el from--

 --EXISTS--
 --La siguiente consulta devuelve pedidos que se hicieron en febrero 12 2007--
 SELECT custid, companyname
FROM Sales.Customers AS C
WHERE EXISTS
 (SELECT *
 FROM Sales.Orders AS O
 WHERE O.custid = C.custid
 AND O.orderdate = '20070212');

 --EXISTS NEGADO--
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE NOT EXISTS
 (SELECT *
 FROM Sales.Orders AS O
 WHERE O.custid = C.custid
 AND O.orderdate = '20070212');

 --TABLAS DERIVADAS, una tabla derivada es probablemente la forma de expresion de tabla que
 --mas se asemeja a una subconsulta
 SELECT categoryid, productid, productname, unitprice
FROM (SELECT
 ROW_NUMBER() OVER(PARTITION BY categoryid
 ORDER BY unitprice, productid) AS rownum,
 categoryid, productid, productname, unitprice
 FROM Production.Products) AS D
WHERE rownum <= 2;

/*
SINTAXIS DE ROW_NUMBER

ROW_NUMBER ( )   
    OVER ( [ PARTITION BY value_expression1 , ... [ n ] ] order_by_clause col1,col2..)
*/

/*
--SINTAXIS CTE--
WITH <CTE_name>
AS
(
 <inner_query>
)
<outer_query>;
*/

/*
Como puede ver, es un concepto similar a las tablas derivadas, excepto que la consulta interna no se define en el medio de la consulta externa; en su lugar, primero define la consulta interna, desde el principio hasta el
final, luego la consulta externa, de principio a fin. Este diseño conduce a un código mucho más claro que es
Más fácil de entender.
*/
WITH C AS
(
 SELECT
 ROW_NUMBER() OVER(PARTITION BY categoryid
 ORDER BY unitprice, productid) AS rownum,
 categoryid, productid, productname, unitprice
 FROM Production.Products
)
SELECT categoryid, productid, productname, unitprice
FROM C
WHERE rownum <= 2;

--CTE RECURSIVO--
WITH EmpsCTE AS
(
 SELECT empid, mgrid, firstname, lastname, 0 AS distance
 FROM HR.Employees
 WHERE empid = 9
 UNION ALL
 SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
 FROM EmpsCTE AS S
 JOIN HR.Employees AS M
 ON S.mgrid = M.empid
)
SELECT empid, mgrid, firstname, lastname, distance
FROM EmpsCTE;


--Vistas y funciones con valores de tabla--
--La principal diferencia entre las vistas y las funciones con valores de tabla en línea es que las primeras
--no acepta parámetros de entrada y este último sí.--
IF OBJECT_ID('Sales.RankedProducts', 'V') IS NOT NULL DROP VIEW Sales.RankedProducts;
GO
CREATE VIEW Sales.RankedProducts
AS
SELECT
 ROW_NUMBER() OVER(PARTITION BY categoryid
 ORDER BY unitprice, productid) AS rownum,
 categoryid, productid, productname, unitprice
FROM Production.Products;
GO

--Consultar la vista--
SELECT categoryid, productid, productname, unitprice
FROM Sales.RankedProducts
WHERE rownum <= 2;


/*
En cuanto a las funciones con valores de tabla en línea, son muy similares a las vistas en concepto; sin emabargo,
como se mencionó, admiten parámetros de entrada. Entonces, si quieres definir algo como un
vista con parámetros, lo más cercano que tiene es una función en línea con valores de tabla. Como ejemplo,
considerar el CTE recursivo de la sección sobre CTE que volvió a sintonizar la cadena de gestión
que lleva al empleado 9. Suponga que desea encapsular la lógica en una expresión de tabla para su reutilización, pero también desea parametrizar el empleado de entrada en lugar de usar el
constante 9. Puede lograr esto mediante el uso de una función en línea con valores de tabla con lo siguiente
definición.
*/
IF OBJECT_ID('HR.GetManagers', 'IF') IS NOT NULL DROP FUNCTION HR.GetManagers;
GO
CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE
AS
RETURN
 WITH EmpsCTE AS
 (
 SELECT empid, mgrid, firstname, lastname, 0 AS distance
 FROM HR.Employees
 WHERE empid = @empid
 UNION ALL
 SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
 FROM EmpsCTE AS S
 JOIN HR.Employees AS M
 ON S.mgrid = M.empid
 )
 SELECT empid, mgrid, firstname, lastname, distance
 FROM EmpsCTE;
GO

SELECT *
FROM HR.GetManagers(9) AS M;

--APLY--
--CROSS APLY--
/*
suponga que escribe una consulta que devuelve los dos productos
con los precios unitarios más bajos para un proveedor específico, por ejemplo, proveedor 1
*/
SELECT productid, productname, unitprice
FROM Production.Products
WHERE supplierid = 1
ORDER BY unitprice, productid
OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY;
/*

A continuación, suponga que necesita aplicar esta lógica a cada uno de los proveedores de Japón que
que tiene en la tabla Production.Suppliers.
*/
SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
 CROSS APPLY (SELECT productid, productname, unitprice
 FROM Production.Products AS P
 WHERE P.supplierid = S.supplierid
 ORDER BY unitprice, productid
 OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY) AS A
WHERE S.country = N'Japan';

--OUTER APPLY--
/*
El operador OUTER APPLY hace lo que hace el operador CROSS APPLY, pero también incluye
las filas de resultados del lado izquierdo que obtienen un conjunto vacío del lado derecho. Los NULL 
*/
SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
 OUTER APPLY (SELECT productid, productname, unitprice
 FROM Production.Products AS P
 WHERE P.supplierid = S.supplierid
 ORDER BY unitprice, productid
 OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY) AS A
WHERE S.country = N'Japan';
--Aqui vemos como retorna los NULL--

--EJERCICIO 1--
WITH CatMin AS
(
 SELECT categoryid, MIN(unitprice) AS mn
 FROM Production.Products
 GROUP BY categoryid
)
SELECT P.categoryid, P.productid, P.productname, P.unitprice
FROM Production.Products AS P
 INNER JOIN CatMin AS M
 ON P.categoryid = M.categoryid
 AND P.unitprice = M.mn;

 --EJERCICIO 2--
 IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL DROP FUNCTION 
Production.GetTopProducts;
GO
CREATE FUNCTION Production.GetTopProducts(@supplierid AS INT, @n AS BIGINT) 
RETURNS TABLE
AS
RETURN
 SELECT productid, productname, unitprice
 FROM Production.Products
 WHERE supplierid = @supplierid
 ORDER BY unitprice, productid
 OFFSET 0 ROWS FETCH FIRST @n ROWS ONLY;
GO

--Probando la funcion--
SELECT * FROM Production.GetTopProducts(1, 2) AS P;

SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
 OUTER APPLY Production.GetTopProducts(S.supplierid, 2) AS A
WHERE S.country = N'Japan';

IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL DROP FUNCTION 
Production.GetTopProducts;

--REVISION DE LO APRENDIDO--
--Respuestas: 1)A, 2)B,C 3)D

--SET OPERATORS--
/*
T-SQL admite tres operadores de conjuntos: UNION,
INTERSECT, y EXCEPTO; también admite un operador de varios conjuntos: UNION ALL.
*/

--UNION--
/*
El operador de conjuntos UNION unifica los resultados de las dos consultas de entrada. Como operador establecido, UNION
tiene una propiedad DISTINCT implícita, lo que significa que no devuelve filas duplicadas.
*/

--EJEMPLO DE UNION--
/*
Como ejemplo del uso del operador UNION, la siguiente consulta devuelve ubicaciones que
son ubicaciones de empleados o ubicaciones de clientes o ambas.
*/
SELECT country, region, city
FROM HR.Employees
UNION
SELECT country, region, city
FROM Sales.Customers;

--UNION ALL--
/*
La tabla HR.Employees tiene 9 filas y la tabla Sales.Customers tiene 91 filas, pero no
hay 71 ubicaciones distintas en los resultados unificados; por tanto, el operador UNION devuelve 71 filas.
Si desea conservar los duplicados, por ejemplo, para luego agrupar las filas y contar las ocurrencias, debe usar el operador de conjuntos múltiples UNION ALL
*/
SELECT country, region, city
FROM HR.Employees
UNION ALL
SELECT country, region, city
FROM Sales.Customers;
--Se tendra que analizar, si no hay duplicados es siempre recomendable usar UNION ALL ya que
--SQL no gastara recursos incesarios tratando de eliminar duplicados--

--INTERSECT--
--INTERSECT devuelve solo filas distintas que son comunes a ambos conjuntos.--
SELECT country, region, city
FROM HR.Employees
INTERSECT
SELECT country, region, city
FROM Sales.Customers;

--EXCEPT--
--Devuelve filas que aparecen en la primera consulta pero que no aparecen en la segunda--
SELECT country, region, city
FROM HR.Employees
EXCEPT
SELECT country, region, city
FROM Sales.Customers;

--Orden de ejecucion--
--INTERSECT, UNION = EXCEPT
/*
Con UNION e INTERSECT, el orden de las consultas de entrada no importa. Sin embargo, con
EXCEPTO, hay un significado diferente para <consulta 1> EXCEPTO <consulta 2> y <consulta 2> EXCEPTO
<consulta 1>.
Finalmente, los operadores de conjuntos tienen prioridad: INTERSECT precede a UNION y EXCEPT, y
UNION y EXCEPT se consideran iguales. Considere los siguientes operadores de conjuntos.
<consulta 1> UNION <consulta 2> INTERSECT <consulta 3>;
Primero, se produce la intersección entre la consulta 2 y la consulta 3, y luego se produce una unión entre
el resultado de la intersección y la consulta 1. Siempre puede forzar la precedencia utilizando tesis de par. Entonces, si desea que la unión se lleve a cabo primero, use el siguiente formulario.
(<consulta 1> UNION <consulta 2>) INTERSECT <consulta 3>;
*/

--CLEANUP--
DELETE FROM Production.Suppliers WHERE supplierid > 29;
IF OBJECT_ID('Sales.RankedProducts', 'V') IS NOT NULL DROP VIEW Sales.RankedProducts;
IF OBJECT_ID('HR.GetManagers', 'IF') IS NOT NULL DROP FUNCTION HR.GetManagers;

--Ejercicio 1--
SELECT empid
FROM Sales.Orders
WHERE custid = 1
EXCEPT
SELECT empid
FROM Sales.Orders
WHERE custid = 2;

--EJERCICIO 2--
SELECT empid
FROM Sales.Orders
WHERE custid = 1
INTERSECT
SELECT empid
FROM Sales.Orders
WHERE custid = 2;

--RESUMEN--
/*
■ El operador UNION unifica los conjuntos de entrada y devuelve filas distintas.
■ El operador UNION ALL unifica las entradas sin eliminar duplicados.
■ El operador INTERSECT devuelve solo las filas que aparecen en ambos conjuntos de entrada, devolviendo
filas distintas.
■ El operador EXCEPT devuelve las filas que aparecen en el primer conjunto pero no en el segundo,
devolviendo filas distintas
*/

--Revision--
--1)A,C,D 2)D 3)B