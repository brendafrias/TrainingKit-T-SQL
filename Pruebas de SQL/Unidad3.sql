--CODIGO MAGICO CUANDO NO TE DEJA CREAR DIAGRAMAS DE TU POBRE BASE DE DATOS--
--USE [Y ACA VA EL NOMBRE DE LA BASE PA] EXEC sp_changedbowner 'SA';--

--UNIDAD 3--
--Filtering and Sorting Data--


--FILTRADO DE DATOS CON PREDICADOS--
--ON, WHERE, HAVING--
--ON: convinacion de conjuntos, HAVING: agrupacion de datos, WHERE:filtrar datos basados en predicados--

USE TSQL2012;

--Seleccionamos solo los empleados que viven en USA--
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE country = N'USA';


--Seleccionamos solo los empleados que viven en WA--
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region = N'WA';
--NOTA--
/*cuando son posibles NULL en los datos, un predicado puede evaluar
a verdadero, falso y desconocido. Este tipo de lógica se conoce como
lógica de tres valores. 
*/

--considere una solicitud para regresar solo a los empleados que no sean 
--del estado de Washington. Emite la siguiente consulta.--
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA';

--No trae los empleados de de reino unido porque estos no tienen region y es = NULL--
--Los selecionaremos con el siguiente codigo--
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA'
	OR region IS NULL;


--Tambien podemos realizar busquedas por argumento EJ col1=10 y col1>10 son argumentos de busqueda--
--Un ejemplo de manipulacion filtrada es aplicar una funcion a ella F(col1) = 10--
DECLARE @dt date
SELECT orderid, orderdate, empid
FROM Sales.Orders
WHERE shippeddate = @dt
 OR (shippeddate IS NULL AND @dt IS NULL);

--NOTA--
/*
Las funciones SQL Coalesce e IsNull se usan para manejar valores nulos. 
La función SQL Coalesce evalúa todos los argumentos en orden y siempre devuelve 
el primer valor no nulo de la lista de argumentos definidos.
*/

--COMBINANDO PREDICADOS CON AND Y OR TAMBIEN PODEMOS NEGARLOS CON NOT--
--REGLAS: las reglas determinan el orden lógico de evaluación de los diferentes predicados. El operador NOT
--precede a AND y OR, y AND precede a OR.--
--WHERE col1 = 'w' AND col2 = 'x' OR col3 = 'y' AND col4 = 'z'--
--WHERE (col1 = 'w' AND col2 = 'x') OR (col3 = 'y' AND col4 = 'z')--
--WHERE col1 = 'w' AND (col2 = 'x' OR col3 = 'y') AND col4 = 'z'--
--LOS PARENTESIS SIEMPRE TIENEN MAYOR PRECEDENCIA, USARLOS PARA CONTROLAR EL ORDEN DE EVALUACION--
--WHERE propertytype = 'INT' AND CAST(propertyval AS INT) > 10--
-- la consulta nunca debe fallar al intentar convertir algo que no es convertible-- 
--PARA SOLUCIONAR ESTO USAMOS TRY_CAST--
--WHERE propertytype = 'INT' AND TRY_CAST(propertyval AS INT) > 10--

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname = 'Davis';

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname = N'Davis';

--<column> LIKE <pattern>--

--Retornar todos los empleados que su apellido comience con la letra D.
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

--NOTA--
/*
Si desea buscar un carácter que se considere comodín, puede indicarlo después
un carácter que designe como carácter de escape utilizando la palabra clave ESCAPE. Por ejemplo, la expresión col1 LIKE '! _%' ESCAPE '!' busca cadenas que comiencen con un guión bajo
(_) utilizando un signo de exclamación (!) como carácter de escape
*/

--Consultar la tabla Sales.Orders y devolver solo pedidos realizados el 12 de febrero del 2007--
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderdate = '02/12/07';
--Recordar que primero va MES, DIA, AÑO--
/*
depende del idioma del inicio de sesión que ejecuta el código. Cada inicio de 
sesión tiene un idioma predeterminado asociado con él
*/
--POR CONVENCION SE ESCRIBEN LAS FECHAS DE MAYOR A MENOS AÑO/MES/DIA--
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderdate = '20070212';
--NOTA--
/* orderdate es de tipo DATETIME  y al usar en el where sin espicificar el horario lo convierte por default en la media noche*/

--IMPORTANTE!!!--
/*Otro aspecto importante del filtrado de datos de fecha y hora es intentar, siempre que sea posible,
utilizar argumentos de búsqueda. Por ejemplo, suponga que necesita filtrar solo los pedidos realizados en
Febrero de 2007. Puede utilizar las funciones AÑO y MES, como se muestra a continuación.
*/
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 2;

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderdate >= '20070201' AND orderdate < '20070301';

--BENEFICIOS DE USAR WHERE--
/*Reduce el tráfico de red filtrando en el servidor de la base de datos en lugar de en
el cliente, y potencialmente puede usar índices para evitar escaneos completos de las tablas
involucrado.*/

--SARG--
/*Los operadores SARG son de gran importancia para desarrollar consultas 
con un buen performance para sistemas críticos que necesitan un tiempo de respuesta óptimo
Su principal objetivo es evitar que se lleven acabo escaneos de tablas (Table Scan) 
haciendo match las consultas con alguno de los índices de la tabla.
operadores validos del tipo SARG que son =, >, <, >=, <=, BETWEEN y algunas veces LIKE.
odos estos operadores pueden ser combinados con la cláusula AND y de esta manera 
un solo índice puede hacer match ya sea con un operador SARG o todos.*/

--EJERCICIO 1--
--Utilice la clausula WHERE para filtrar filas con NULL--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE shippeddate IS NULL;

--EJERCICIO 2--
--Utilice la clausula WHERE para filtrar un rango de fechas--
--Del 11 de febrero de 2008 al 12 de febrero de 2008--
--Ponemos un dia mas porq usamos menor que--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20080211' AND orderdate < '20080213';

--RESPUESTAS--
--1)B) 2)A, B,C 3)B,E
--Los 3 posibles valores de resultado logico de un predicado son verdadero, falso, desconocido--

--SORTING DATA--
SELECT empid, firstname, lastname, city, region, MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA';
--Al parecer la salida esta ordenada por el primer elemento de la consulta select empid, pero
--esto no esta garantizado, sql al no haber una instruccion explicita podria ser que eliga sierto orden
--pero hay una gran diferencia entre lo que es probable que suceda debido a la optimizacion y lo que realmente este garantizado--
--LA UNICA FORMA DE GARANTIZAR EL ORDEN ES MEDIANTE ORDER BY--
--Siempre es recomendable garantizar el orden por si en una version posterior este podria cambiar--

--USING THE ORDER BY CLAUSE TO SORT DATA--
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY city;--Si no especificamos el orden lo ordenara de manera ascendente--
--Para ordenarlos de manera descendente usamos DESC--

--NOTA--
/*La columna de la ciudad no es única dentro del país y la región filtrados y, por lo tanto, la
El orden de filas con la misma ciudad (consulte Seattle, por ejemplo) no está garantizado. En cuyo caso,
se dice que el orden no es determinista. Al igual que una consulta sin una cláusula ORDER BY
no garantiza el orden entre las filas de resultados en general, una consulta con ORDER BY city, cuando city
no es único, no garantiza el orden entre filas con la misma ciudad. Afortunadamente puedes
especifique varias expresiones en la lista ORDER BY, separadas por comas. Un caso de uso de esto
La capacidad es aplicar un desempate para realizar pedidos. Por ejemplo, puede definir empid como el
columna de clasificación secundaria, de la siguiente manera
*/

--AQUI UTILIZAMOS COMO SEGUNDO CRITERIO DE ORDENAMIENDO empid PARA DESEMPATAR CUANDO TENGAN LA MISMA CIUDAD--
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY city, empid;

--T-SQL tambien permite ordenar segun posicion de las columnas de SELECT pero esto es considerado una mala practica--
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY 4, 1;
--SI REALIZAMOS ALGUN CAMBIO EN EL ORDEN DE SELECT Y NO RECORDAMOS CAMBIARLOS EN EL ORDER BY REALIZARA OTRO ORDENAMIENTO--

--Tambien podemos odenar las filas de resultados por elementos que no forman parte del SELECT si esto es requerido--
SELECT empid, city
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY birthdate;
--Esta regla cambia cuando se usa la clausula DISTINC--
--CUANDO USAMOS DISTINC ESTAMOS OBLIGADOS A USAR LOS ELEMENTOS DEL SELECT--
--NOTA-- ORDER BY PUEDE UTILIZAR LOS ALIAS ASIGNADOS EN SELECT YA QUE ORDER BY SE EJECUTA DESPUES--
--EJEMPLO--
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY birthmonth;


--ORDENAMIENTO DE LOS NULLS--
SELECT orderid, shippeddate
FROM Sales.Orders
WHERE custid = 20
ORDER BY shippeddate;

--EJERCICIO 1-
SELECT orderid, empid, shipperid, shippeddate, custid
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid;
--Conclucion es no determinista ya que no podemos saber cual es el orden entre las filas con el mismo id de shipperid--

--EJERCICIO 2--
--Agregar ordenamiento determinista, agregando como segundo parametro del ORDER BY  shippeddate de forma descendiente--
SELECT orderid, empid, shipperid, shippeddate, custid
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid, shippeddate DESC, orderid DESC;
--Sigue siendo no determinista, POR ESO AGREGAMOS ORDERID, para que sea determinista--

--RESPUESTAS--
--1)B) 2)C 3)B,C,D

--Filtering Data with TOP and OFFSET-FETCH--
--Esta leccion mezcla conceptos de filtrado y clasificacion, EJS: devolver los 3 pedidos mas recientes, devolver los 5 productos mas caros--
--Para esto tenemos TOP y OFFSET-FETCH--
SELECT TOP (3) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--Tambien podemos usar porcentajes usando despues de top un numero del 1 al 100 y la palabra reservada PERCENT--
SELECT TOP (1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;
--------------------------------------
--Tambien podemos asignarle a top una variable--
DECLARE @n AS BIGINT = 5;
SELECT TOP (@n) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--Orden no determinista--
SELECT TOP (3) orderid, orderdate, custid, empid
FROM Sales.Orders;


--Esto podria devolver mas filas de las solicitadas--
SELECT TOP (3) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;
--Para que sea determinista rompemos el empate agregando al ORDER BY un orderid DESC, para que muestre el pedido de mayor cantidad--
SELECT TOP (3) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC;

--OFFSET-FETCH--
--Este a diferencia de top es standard y tiene una capacidad de omision, estas aparecen despues
--de la clausula ORDER BY y en T-SQL se requiere que este presente una clausula ORDER BY--
--Primero se especifica la clausula OFFSET para indicar cuantas filas se desea omitir (0) si no
--se desea omitir ninguna, luego opcionalmente se especifica la clausula FETCH que indica
--cuantas filas desea filtrar--
/*Por ejemplo,
la siguiente consulta define el orden en función de la fecha del pedido descendente, seguida de la identificación del pedido
descendente luego salta 50 filas y recupera las siguientes 25 filas.
*/
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;
/*
La cláusula ORDER BY ahora juega dos roles: uno es decirle a la opción OFFSET-FETCH
qué filas necesita filtrar. Otro rol es determinar el orden de presentación en la consulta.
Como se mencionó, en T-SQL, la opción OFFSET-FETCH requiere una cláusula ORDER BY para ser
regalo. Además, en T-SQL, a diferencia del SQL estándar, una cláusula FETCH requiere una cláusula OFFSET
Ser presente. Entonces, si desea filtrar algunas filas pero omitir ninguna, aún debe especificar
la cláusula OFFSET con 0 FILAS.
*/
--En caso de que en el OFFSET no queramos saltar ninguna fila le indicamos 0 y en el FETCH en ves deNEXT usamos FIRST--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 0 ROWS FETCH FIRST 25 ROWS ONLY;

--La opcion OFFSET-FETCH requiere una clausula ORDER BY, pero si necesitamos filtrar un cierto numero
--de filas con un ordern arbitrario podemos usar la exprecion SELECT NULL en la clausula ORDER BY--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY (SELECT NULL)
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--Saltear 50 filas--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS;

--OFFSET-FETCH requiere un ORDER BY, pero si queremos hacerlo en un orden arbitrario indicamos SELECT NULL--
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY (SELECT NULL)
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;


--Paginacion, regresa al usuario una pagina de filas a la vez, el usuario pasa como parametros de
--entrada a su procedimiento o una funcion el numero de pagina y tamaño de pagina filas--
DECLARE @pagesize AS BIGINT = 25, @pagenum AS BIGINT = 3;
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET (@pagesize - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

--NOTA OFFSET ESPECIFICA CUANTOS REGISTROS TIENE QUE SALTARSE DENTRO DEL RESULTADO Y FETCH ESPECIFICA CUANTOS REGISTROS DESDE ESE PUNTO EN ADELANTE TIENE QUE DEVOLVER--

--EJERCICIO 1--
--Escribir una consulta en la tabla Production.Products devolviendo los cinco producto mas caros de la categoria--
SELECT TOP (5) productid, unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC, productid DESC;

--CODIGO PROPIO--
SELECT productid, productname, supplierid, categoryid, unitprice
FROM Production.Products
ORDER BY unitprice DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

--EJERCICIO 2--
--Se le solicita que escriba un conjunto de consultas que recorran los productos cinco a la vez
--en el pedido de precio unitario, utilizando el id del producto como elemento de desempate-

SELECT productid, categoryid, unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

--EJERCICIO 3--
--A continuacion escriba una consulta que devuelva las siguientes 5 filas (6 a 10)
SELECT productid, categoryid, unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;
--RECORDAR USAR NEXT EN VEZ DE FIRST SI OFFSET NO ES = 0--
--1)B 2)F 3)C,A
