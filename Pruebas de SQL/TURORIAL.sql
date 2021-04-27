SELECT * FROM Departamentos
SELECT * FROM Empleados
--Cuando tenemos un inner join debos tener 2 tablas y estas tablas deben tener una columna en comun,
--que es el punto de comparacion, comparamos columnas y encontramos coincidencias, si no hay
--considencia esa fila no se muestra


--INNER JOIN--
--En este caso no aparece el departamento marketing ni el empleado williams porque no tienen una relacion--
SELECT *
FROM Empleados AS E
INNER JOIN Departamentos AS D
ON E.DepartamentoID = D.ID

--LEFT JOIN--
--Se muestran todos los elementos de la primera tabla, no aparecen los que no tengan match de la tabla B
--En este caso si parece williams ya que aparecen todos los elemetos de la tabla A, y no aparece marketing porque
--no deben aparecer los elementos de la tabla B que no tengan match
SELECT *
FROM Empleados AS E
LEFT JOIN Departamentos AS D
ON E.DepartamentoID = D.ID

--RIGHT JOIN--
--Es lo mismo que left join solo que ahora se mostraran todos los elementos de la tabla B, y solo
--los elementos que tengan match de la tabla A
--Ahora si aparecera marketing y no aparecera williams
SELECT *
FROM Empleados AS E
RIGHT JOIN Departamentos AS D
ON E.DepartamentoID = D.ID

--FULL JOIN--
--Nos muestran tanto los datos de la tabla A como los datos de la tabla B--
SELECT *
FROM Empleados AS E
FULL JOIN Departamentos AS D
ON E.DepartamentoID = D.ID

--LEFT EXCLUDING JOIN--
--Trae todos los elementos de la tabla a menos los que hacen match con la tabla B--
--Esto seria util para ver los empleados que no tienen un departamento asignado--
--Para esto agregamos la clausula where para identificar cuando el D.ID sea null--
SELECT *
FROM Empleados AS E
LEFT JOIN Departamentos AS D
ON E.DepartamentoID = D.ID
WHERE D.ID is NULL

--RIGHT EXCLUDING JOIN--
--Trae todos los elementos de la tabla B menos los que hacen match con la tabla A--
--Esto seria util para ver los departamentos que no tienen un empleado asignado--
--Para esto agregamos la clausula where para identificar cuando el D.ID sea null--
SELECT *
FROM Empleados AS E
RIGHT JOIN Departamentos AS D
ON E.DepartamentoID = D.ID
WHERE E.DepartamentoID is NULL

--Outer excluding JOIN--
--SE EXCLUYE LOS VALORES QUE TENGAN UN MATCH--
--el resultado de este seria williams y marketing--
--Para esto agregamos en el where que E.DepartamentoID sea null o que D.ID sea null--
SELECT *
FROM Empleados AS E
FULL OUTER JOIN Departamentos AS D
ON E.DepartamentoID = D.ID
WHERE E.DepartamentoID is NULL OR D.ID IS NULL
