
--EJERCICIO 1 --
--La instruccion USE garantiza que esta conectado a la base de datos de destino--
USE TSQL2012;

--La clausula SELECT proyecta los atributos de Sales--
SELECT shipperid, companyname, phone
FROM Sales.Shippers;
--FROM indica la tabla Sales.Shippers es la tabla consultada

--Esto podria dar un error si tenemos algun otro shipperid--
--Por lo tanto le asignaremos un alias para que no haya confucion--

SELECT S.shipperid, companyname, phone
FROM Sales.Shippers AS S;

--EJERCICIO 2--
--Asignar un alias a phone--
--Nota cuando usamos espacio en un alias debemos escribirlo entre corchetes o entre comillas dobles--
SELECT S.shipperid, companyname, phone AS [phone number]
FROM Sales.Shippers AS S;

--RESPUESTAS--
--1) B Y D, 2) D, 3)B--

--Tipos de datos--
--Enteros, caracteres, monetarios, fecha y hora, cadenas binarias,etc.--
--Tambien podemos crear nuestros propios tipos de datos,Los tipos definidos por el 
--usuario obtienen sus características de los métodos y operadores de una clase que se crea 
--mediante uno de los lenguajes de programación compatibles con .NET Framework.--

--Pruebas con FROM--
--Seleccionamos de la tabla Employees las siguientes columnas: empid, hiredate, country--
SELECT H.empid, H.hiredate, H.country
FROM HR.Employees AS H;

--Pruebas con WHERE--
--Filtramos los empleados que fueron contratados despues de la fecha January 1, 2003--
/*
SELECT country, YEAR(hiredate) AS yearhired
FROM HR.Employees
WHERE yearhired >= '20030101'
*/
--Esto da error porque el where se ejecuta antes que el select--

--Pruebas con Having--
--Al filtrar por grupos con having ya podemos--
SELECT country, YEAR(hiredate) AS yearhired, COUNT(*) AS numemployees
FROM HR.Employees
WHERE hiredate >= '20030101'
GROUP BY country, YEAR(hiredate)
HAVING COUNT(*) >1
ORDER BY country, yearhired DESC;

/*Además, recuerde que esta fase asigna alias de columna, como año contratado y numemployees.
Esto significa que los alias de columna recién creados no son visibles para las cláusulas procesadas en
fases, como FROM, WHERE, GROUP BY y HAVING.*/

--EJERCICIO 2--
--Para solucionar el error usamos una funcion agregada MAX--
SELECT custid, MAX(orderid) AS maxorderid
FROM Sales.Orders
GROUP BY custid;

--EJERCICIO 3--
--Solucionar un problema con el alias--
/*
SELECT shipperid, SUM(freight) AS totalfreight
FROM Sales.Orders
GROUP BY shipperid
HAVING totalfreight > 20000.00;
*/
--El error con este codigo es que la clausula HAVING se ejecuta antes que el select--
--Para solucionarlo realizaremos el SUM dentro de HAVING--
SELECT shipperid, SUM(freight) AS totalfreight
FROM Sales.Orders
GROUP BY shipperid
HAVING SUM(freight) > 20000.00;
--NOTA: Siempre hay que respetar el orden de procesamiento de las consultas T-SQL--
--Orden: FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY.--

--RESPUESTAS--
--1)b, 2)C Y D, 3) A.. Para que el resultado sea relacional, la consulta debe satisfacer una serie de requisitos, incluidos los siguientes: la consulta no debe tener una cláusula ORDER BY, todos los atributos
--deben tener nombres, todos los nombres de atributos deben ser únicos y los duplicados no deben
--aparecen en el resultado.--

--CONSEJOS--
/*■ No debe confiar en el orden de las columnas o filas.
■ Siempre debe nombrar las columnas de resultados.
■ Debe eliminar los duplicados si son posibles en el resultado de su consulta.
*Siempre es recomendable usar codigo estandar
*Eliminar duplicados: sql intentara eliminar los duplicados incluso cuando no los haya
esto supondra un coste adicional, por lo tanto solo se debe agregar la clausula DISTINCT
solo cuando haya duplicados posibles en el resultado y no se supone que tenga que devolver
duplicados.
*/





