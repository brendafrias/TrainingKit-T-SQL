--PRACTICA DE LO APRENDIDO HASTA AHORA--
CREATE DATABASE TestJoin
GO

USE TestJoin
GO
CREATE TABLE Departamentos
(
	ID int,
	Nombre varchar(20)
);

CREATE TABLE Empleados
(
	Nombre varchar(20),
	DepartamentoID int
);

--EMPLEADOS Y DEPARTAMENTOS HARDCODEADOS--
INSERT INTO Departamentos VALUES(31, 'Sales');
INSERT INTO Departamentos VALUES(33, 'Engineering');
INSERT INTO Departamentos VALUES(34, 'Clerical');
INSERT INTO Departamentos VALUES(35, 'Marketing');

INSERT INTO Empleados VALUES('Rafferty', 31);
INSERT INTO Empleados VALUES('Jones', 33);
INSERT INTO Empleados VALUES('Heisenberg', 33);
INSERT INTO Empleados VALUES('Robinson', 34);
INSERT INTO Empleados VALUES('Smith', 34);
INSERT INTO Empleados VALUES('Williams', NULL);

--Hacemos un select de ambas tablas para confirmar que los datos se insertaron correctamente--
--En otro Query--