--UNIDAD 2--

/*
--Leccion 1 uso de las clausulas FROM y SELECT--
--FROM:■ Es la cláusula en la que indica las tablas que desea consultar.
■ Es la cláusula en la que puede aplicar operadores de tabla como 
combinaciones a tablas de entrada.

*/

USE TSQL2012;
/*
SELECT empid, firstname, lastname
FROM HR.Employees;
*/

--HR es el nombre del esquema y Employees es el nombre de la tabla--
--NOTA--
/*En algunos casos, T-SQL admite la omisión del nombre del esquema, como en FROM Empleados, en cuyo caso utiliza un
proceso de resolución de nombres de esquema. Se considera una buena práctica indicar siempre explícitamente
el nombre del esquema. Esta práctica puede evitar que termine con un nombre de esquema que
no pretendía ser utilizado, y también puede eliminar el costo involucrado en el proceso de resolución implícito, aunque este costo es menor.
*/

--En la clausula FROM se puede asignar un alias a las tablas--
--EJEMPLO--

SELECT E.empid, firstname, lastname
FROM HR.Employees AS E;
--NOTA--
--Por convencion se utiliza la primera letra de la tabla en el alias--
--Una vez que asignamos el alias es obligatorio usarlo, ya no podremos llamar a la tabla
--con HR.Employees, es obligatorio llamarla con su alias E.--

/*
--SELECT:■ Evalúa expresiones que definen los atributos en el resultado de la consulta, asignándolos
con alias si es necesario.
■ Con una cláusula DISTINCT, puede eliminar filas duplicadas en el resultado si es necesario.
*/

--EJEMPLO--
SELECT empid, firstname, lastname
FROM HR.Employees;

--NOTA--
--No es recomendable usar en el SELECT *, es mejor llamar solo las tablas que necesitamos--
--No es recomendable asignar alias sin usar AS ya que si olvidamos poner una coma, nos sera mas dificil detectar el error-
--EJEMPLO--
/*
SELECT empid, firstname lastname
FROM HR.Employees;
*/
--Aqui asigna a firstname el alias lastname, y en realidad queriamos mostrar esas 3 columnas.--

/*
Otro uso es asignar un nombre a un atributo que resulta de una expresión que
de lo contrario, no tendrá nombre. Por ejemplo, suponga que necesita generar un atributo de resultado a partir de un
expresión que concatena el atributo firstname, un espacio y el atributo lastname. Tú
utilice la siguiente consulta.
*/
SELECT empid, firstname + N' ' + lastname
FROM HR.Employees;
--Al hacer esto nuestra columna no tendra nombre--

SELECT empid, firstname +  N' ' + lastname AS fullname
FROM HR.Employees;
--Aqui al resultado de la expresion le asignamos el alias fullname, para que aparesca nombre en nuestra columna--

--DISTINCT--
SELECT DISTINCT country, region, city
FROM HR.Employees;

--NOTA--
/*

Existe una diferencia interesante entre SQL estándar y T-SQL en términos de requisitos mínimos de consulta SELECT. Según SQL estándar, una consulta SELECT debe tener en
cláusulas mínimas FROM y SELECT. Por el contrario, T-SQL admite una consulta SELECT con solo un
SELECT cláusula y sin una cláusula FROM. Tal consulta es como si se emitiera contra un imaginario
tabla que tiene una sola fila. Por ejemplo, la siguiente consulta no es válida según el estándar SQL pero es válida según T-SQL.
*/
SELECT 10 AS col1, 'ABC' AS col2;

--IDENTIFICADORES NO VALIDOS--
/*
Un identificador que no sigue las reglas para formatear identificadores; por
ejemplo, comienza con un dígito, tiene un espacio incrustado o es un T-SQL reservado
palabra clave
*/

--EJERCICIO 1--
SELECT shipperid, companyname, phone
FROM Sales.Shippers;
--NOTA--
/*Si había más de una tabla involucrada en la consulta y otra tabla tenía un atributo llamado shipperid, necesitaría prefijar el atributo shipperid con la tabla
nombre, como en Shippers.shipperid. Para abreviar, puede alias de la tabla con un nombre más corto,
como S, y luego referirse al atributo como S.shipperid. A continuación, se muestra un ejemplo para asignar un alias al
tabla y prefijando el atributo con el nuevo nombre de la tabla.
*/

--Aqui asignamos el alias de phone number a la columna phone--
SELECT S.shipperid, companyname, phone AS [phone number]
FROM Sales.Shippers AS S;

--RESPUESTAS--
-- 1) B,D. 2) C. 3) C, D


--TIPOS DE DATOS--
--Al asignar un tipo de dato creamos una restrigcion para que solo sean admitidos solo de ese tipo de dato--

--NOTA--
/*
Un tipo de datos encapsula el comportamiento. Al usar un tipo inapropiado, se pierde todo el comportamiento que está encapsulado en el tipo en forma de operadores y funciones que lo soportan. Como
un ejemplo simple, para tipos que representan números, el operador más (+) representa la suma,
pero para las cadenas de caracteres, el mismo operador representa la concatenación. Si elige un tipo inadecuado para su valor, a veces tiene que convertir el tipo (explícita o implícitamente),
y, a veces, hacer malabares con el valor un poco, para tratarlo como lo que se supone que es.
Otro principio importante para elegir el tipo apropiado para sus datos es el tamaño. A menudo
Uno de los principales aspectos que afectan el rendimiento de las consultas es la cantidad de E / S involucrada. Una consulta
que lee menos simplemente tiende a correr más rápido. Cuanto más grande sea el tipo que use, más almacenamiento usará. Las tablas con muchos millones de filas, si no miles de millones, son comunes hoy en día.
Cuando comienza a multiplicar el tamaño de un tipo por el número de filas de la tabla, los números pueden volverse significativos rápidamente. Como ejemplo, suponga que tiene un atributo que representa los puntajes de las pruebas, que son números enteros en el rango de 0 a 100. Usando un tipo de datos INT para esto
el propósito es exagerado. Usaría 4 bytes por valor, mientras que un TINYINT usaría solo 1 byte,
y, por tanto, es el tipo más apropiado en este caso. Del mismo modo, para los datos que se supone
para representar fechas, la gente tiende a utilizar DATETIME, que utiliza 8 bytes de almacenamiento. Si se supone que el valor representa una fecha sin hora, debe usar DATE, que
utiliza solo 3 bytes de almacenamiento. Si se supone que el valor representa tanto la fecha como la hora,
debe considerar DATETIME2 o SMALLDATETIME. El primero requiere almacenamiento entre 6 y 8BYTES
*/

--SIEMPRE ES RECOMENDABLE UTILIZAR EL TIPO DE DATO MAS PEQUEÑO--
--Tipo de dato fijo CHAR(30) CUANDO EL RENDIMIENTO DE LA ACTUALIZACION ES UNA PRIORIDAD--
--Tipo variables usan el almacenamiento para lo que ingresa mas un par de bytes, se utiliza
--para tamaños de cadenas muy variados. asi se puede ahorrar mucho espacio de almacenamiento--
--Cuanto menos almacenamiento se use, menos hay que leer una consulta y mas rapido se puede realizar la consulta--(Prioridad rendimiento de lectura)


--Casteos--
--SELECT CAST('abc' AS INT);-- FALLA PORQUE ABC NO ES DEL TIPO INT.

--SELECT TRY_CAST('abc' AS INT);-- DEVUELVE NULL AL NO PODER CASTEAR ABC A INT.

--DATE--
SELECT 
 SWITCHOFFSET('20130212 14:00:00.0000000 -08:00', '-05:00') AS [SWITCHOFFSET],
 TODATETIMEOFFSET('20130212 14:00:00.0000000', '-08:00') AS [TODATETIMEOFFSET];

 --CONCATENACION--
 SELECT empid, country, region, city,
 country + N',' + region + N',' + city AS location
FROM HR.Employees;
--Concatenamos country, region, city y lo devolvemos en la columna con el nombre asociado location--

--Cuando nos devuelva algun NULL podemos usar la funcion CONCAT_NULL_YIELDS_NULL_INPUT--
--Si deseo sustituir un NULL por una cadena vacia podemos usar COALESCE--
--en este caso solo country puede retornar null--
SELECT empid, country, region, city,
 country + COALESCE( N',' + region, N'') + N',' + city AS location
FROM HR.Employees;

--Otra opcion es utilizar la funcion CONCAT que a diferencia del operador + sustitulle a null por una cadena vacia--
SELECT empid, country, region, city,
	CONCAT( country,N',' + region, N',' + city) AS location
FROM HR.Employees;

--EXTRACCION Y POSICION DE SUBCADENAS--
--LEFT('abcde',3) returns 'abc' and
--RIGHT('abcde',3) returns 'cde'.--

--CHARINDEX--
--LEFT(fullname, CHARINDEX(' ', fullname) -1)--

--STRING ALTERATION--
--REPLACE, REPLICATE, STUFF--

--REPLACE('.1.2.3.', '.', '/')-- SUSTITUYE TODAS LAS OCACIONES DE UN PUNTO (.) CON UNA BARRA (/)--

--REPLICATE('0',10)-- REPLICA LA CADENA '0' DIEZ VECES, DEVOLVIENDO '0000000000'.

--STUFF(',x,y,z',1,1,")--ELIMINA EL PRIMER CARACTER DE LA CADENA DE ENTRADA DEVOLVIENDO 'x,y,z'


--FORMATO DE CADENA--
--UPPER, LOWER, LTRIM, RTRIM, FORMAT--

--CASE--
SELECT productid, productname, unitprice, discontinued,
 CASE discontinued
 WHEN 0 THEN 'No'
 WHEN 1 THEN 'Yes'
 ELSE 'Unknown'
 END AS discontinued_desc
FROM Production.Products;

--generalmente está dentro de una lista de selección para alterar la salida. Lo que realiza es evaluar una lista de condiciones y devuelve una de las múltiples expresiones de resultado posibles--
--Utilizamos ELSE por si los valores no son ni 1 o 0, asi no devolvera null--

SELECT productid, productname, unitprice,
 CASE
 WHEN unitprice < 20.00 THEN 'Low'
 WHEN unitprice < 40.00 THEN 'Medium'
 WHEN unitprice >= 40.00 THEN 'High'
 ELSE 'Unknown'
 END AS pricerange

FROM Production.Products;


--NOTA--
/*
T-SQL admite una serie de funciones que pueden considerarse abreviaturas de CASE
expresión. Esas son las funciones estándar COALESCE y NULLIF, y las no estándar
ISNULL, IIF y CHOOSE.

COALESCE(<exp1>, <exp2>, …, <expn>)
is similar to the following.
CASE
 WHEN <exp1> IS NOT NULL THEN <exp1>
 WHEN <exp2> IS NOT NULL THEN <exp2>
 …
 WHEN <expn> IS NOT NULL THEN <expn>
 ELSE NULL
END

*/

--EJERCICIO 1--
SELECT empid,
 firstname + N' ' + lastname AS fullname, 
 YEAR(birthdate) AS birthyear
FROM HR.Employees;


--EJERCICIO 2--
SELECT EOMONTH(SYSDATETIME()) AS end_of_current_month;--Muestra el dia final del mes--
SELECT DATEFROMPARTS(YEAR(SYSDATETIME()), 12, 31) AS end_of_current_year;--Muestra el dia final del año--

--EJERCICIO 3--

SELECT productid,
	RIGHT(REPLICATE('0',10) + CAST(productid AS VARCHAR(10)), 10) AS str_productid
FROM Production.Products;

SELECT productid, 
 FORMAT(productid, 'd10') AS str_productid
FROM Production.Products;

--RESPUESTAS--
--1)B) B), 2)A),B) 3)B)

/*
--FUNCIONES DE FECHAS https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2012/ms186724(v=sql.110)?redirectedfrom=MSDN--
*/