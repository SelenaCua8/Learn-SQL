/*CREAR DIAGRAMA DE BASE DE DATOS ANTES DE HACER QUERIES*/
/*IMPORTANTE EL DIAGRAMA DE BASE DE DATOS PORQUE VES COMO ESTAN RELACIONADAS TUS TABLAS ENTRE SÍ*/

/*EJERCICIOS SQL SERVER*/

--1. Obtener todas las columnas de la tabla Región.
SELECT * FROM region;

--2. Obtener los FirstName y LastName de la tabla Employees.
Select FirstName, LastName from Employees
--3. Obtener las columnas FirstName y LastName de la tabla empoyees. Ordenados por la columna LastName
Select FirstName, LastName from Employees order by LastName

--4. Genere una lista de selección de la tabla Employees, donde obtenga las siguientes columnas:
--EmployeeID
--LastName y FirstName (Concatenadas)
--Country, Region y City (Concatenada)

SELECT 
EmployeeID,
LastName + ' ' + FirstName as [Full Name],
Country + ' ' + Region + ' ' + City as [Country-Region-City]
FROM Employees

--5. Obtener las filas de la tabla orders ordenadas por la columna Freight de mayor a menor;
--las columnas que presentara son: OrderID, OrderDate, ShippedDate, CustomerID and Freight.
SELECT 
orderID, 
OrderDate,
ShippedDate,
CustomerID,
Freight 
FROM orders order by Freight DESC

--6. Obtener los empleados tengan el valor null en la columna region.

SELECT * FROM Employees WHERE Region is NULL

--7. Encontrar todos los apellidos (lastname) en la tabla Empoyees que comiencen con la letra T
SELECT * FROM  Employees
WHERE LastName LIKE 'T%'

--8. Para recuperar el apellido de los empleados cuya primera letra A y contenga M
SELECT * FROM Employees WHERE LastName Like 'A%M%'


--9. Liste la información de los pedidos sin embarcar(ShippedDate)

SELECT * FROM Orders WHERE ShippedDate is null;

--10. Liste todos los campos de la tabla Suppliers cuya columna Región sea NULL.
SELECT * from Suppliers WHERE region is null

--11. Obtener los empleados ordenados alfabéticamente por FirstName y LastName

SELECT * FROM Employees 
ORDER BY
FirstName, LastName 

--12. Obtener los empleados cuando la columna title tenga el valor de Sales. Representatives y el campo city
--tenga los valores de Seattle o Redmond
SELECT * FROM Employees
WHERE Title = 'Sales Representative' AND City = 'Seattle' OR City = 'Redmon'

--13. Obtener las columnas company name, contact title, city y country de los clientes que están en la Ciudad de 
--México o alguna ciudad de España excepto Madrid.

SELECT CompanyName, ContactTitle, City, Country 
FROM Customers
WHERE Country = 'Mexico' OR Country = 'Spain' 
AND NOT City = 'Madrid'

--14. Obtener la lista de órdenes, y mostrar una columna en donde se calcule el impuesto del 10% cuando el valor
--de la columna Freight >= 480.

SELECT OrderID, Freight, 0.10 * Freight AS [Impuestos 10%]
FROM Orders
WHERE Freight >= 480


--15. Obtener el número de empleados para cada ciudad.
SELECT City,
COUNT(EmployeeID) AS [Numeros de empleados]
FROM Employees
GROUP BY City

--16. Muestre los empleados que hayan colocado más de 15 pedidos.
SELECT EmployeeID, COUNT(OrderID) AS 'Nro. Pedidos'
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(OrderID) > 15
ORDER BY 'Nro. Pedidos' ASC

SELECT
	T2.EmployeeID,
	T1.FirstName + ' ' + T1.LastName AS [Empleado],
	COUNT(T2.OrderID) AS [Nro.Pedidos]
FROM Employees T1
INNER JOIN Orders T2 ON T2.EmployeeID = T1.EmployeeID
GROUP BY T2.EmployeeID, T1.FirstName, T1.LastName
HAVING COUNT(T2.OrderID) > 15
ORDER BY COUNT(T2.OrderID) ASC
 


--17. Muestre los clientes que hayan solicitado más de 20 pedidos.
SELECT CustomerID, COUNT(OrderID) AS 'Nro.Pedidos'
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 20
ORDER BY COUNT(OrderID) ASC




--18. Muestre los empleados que más hayan colocado pedidos para los países Germany y Brazil.
SELECT EmployeeID, COUNT(OrderID) AS 'Nro.Pedidos'
FROM Orders
WHERE
ShipCountry IN('Germany','Brazil')
GROUP BY EmployeeID




--19. Obtener un reporte en donde se muestre la cantidad de ordenes por cada vendedor.
SELECT EmployeeID, COUNT(OrderID) AS 'Nro.Ordenes'
FROM Orders
Group by EmployeeID
ORDER BY 2 DESC



--20. Obtener un reporte por Vendedor que muestre el número de órdenes y el importe vendido para cada año de 
--operaciones.
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
-- ==

SELECT *
FROM Employees T1
INNER JOIN Orders T2 ON T2.EmployeeID = T1.EmployeeID
INNER JOIN [Order Details] T3 ON t3.OrderID = T2.OrderID

SELECT  T1.FirstName + ' ' + T1.LastName AS [Vendedor],
		DATEPART(YEAR, T2.OrderDate) AS [Anio],
		COUNT(T2.OrderID) AS [Nro. Ordenes],
		SUM(T3.Quantity * T3.UnitPrice) AS [Importe Vendido]
FROM Employees T1
INNER JOIN Orders T2 ON T2.EmployeeID = T1.EmployeeID
INNER JOIN [Order Details] T3 ON t3.OrderID = T2.OrderID
GROUP BY T1.FirstName, T1.LastName, T2.OrderDate

SELECT OrderDate, DATEPART(YEAR, OrderDate)
FROM Orders

--21. Del reporte obtenido en la respuesta 20, muestre los 5 primeros vendedores para cada año.

SELECT  
		TOP 5
		T1.FirstName + ' ' + T1.LastName AS [Vendedor],
		DATEPART(YEAR, T2.OrderDate) AS [Anio],
		COUNT(T2.OrderID) AS [Nro. Ordenes],
		SUM(T3.Quantity * T3.UnitPrice) AS [Importe Vendido]
FROM Employees T1
INNER JOIN Orders T2 ON T2.EmployeeID = T1.EmployeeID
INNER JOIN [Order Details] T3 ON t3.OrderID = T2.OrderID
GROUP BY T1.FirstName, T1.LastName, T2.OrderDate

--INTERMEDIO AVANZADO: RANK y OVERPARTITION
SELECT * FROM
(
SELECT  
		RANK() OVER(PARTITION BY DATEPART(YEAR, T2.OrderDate) ORDER BY SUM(T3.Quantity * T3.UnitPrice) DESC) AS Ranking,
		T1.FirstName + ' ' + T1.LastName AS [Vendedor],
		DATEPART(YEAR, T2.OrderDate) AS [Anio],
		COUNT(T2.OrderID) AS [Nro. Ordenes],
		SUM(T3.Quantity * T3.UnitPrice) AS [Importe Vendido]
FROM Employees T1
INNER JOIN Orders T2 ON T2.EmployeeID = T1.EmployeeID
INNER JOIN [Order Details] T3 ON t3.OrderID = T2.OrderID
GROUP BY T1.FirstName, T1.LastName, T2.OrderDate

) AS T
WHERE Ranking < 6



--22. Muestre el total de ventas agrupando por categoría de productos

SELECT 
T3.CategoryName,
SUM(T1.Quantity * T1.UnitPrice) AS [Importe Vendido]
FROM [Order Details] T1
INNER JOIN Products T2 ON T2.ProductID = T1.ProductID
INNER JOIN Categories T3 ON T3.CategoryID = T2.CategoryID
GROUP BY T3.CategoryName



--23. Del reporte obtenido en la respuesta 21, muestre la evolución de las ventas por categoría de productos agrupados para
--cada año de las operaciones.
SELECT T3.CategoryName,
       DATEPART(YEAR, T4.OrderDate) AS [Anio],
       SUM(T1.Quantity * T1.UnitPrice) AS [Importe Vendido]
FROM [Order Details] T1
INNER JOIN Products T2 ON T2.ProductID = T1.ProductID
INNER JOIN Categories T3 ON T3.CategoryID = T2.CategoryID
INNER JOIN Orders T4 ON T4.OrderID = T1.OrderID
GROUP BY T3.CategoryName, DATEPART(YEAR, T4.OrderDate)
ORDER BY T3.CategoryName, [Anio];



--24. Muestre el reporte de ventas por Region.
SELECT T1.ShipRegion, SUM(T2.Quantity * T2.UnitPrice) AS [Importe Vendido]
FROM Orders T1
INNER JOIN [Order Details] T2 ON T2.OrderID = T1.OrderID
GROUP BY T1.ShipRegion;


--25. Del reporte obtenido en la respuesta 24, muestre la evolución de ventas por región agrupadas para cada año de las
--operaciones.
SELECT 
	T1.ShipRegion, 
	SUM(T2.Quantity * T2.UnitPrice) AS [Importe Vendido],
	YEAR(T1.OrderDate) AS [Anio]
FROM Orders T1
INNER JOIN [Order Details] T2 ON T2.OrderID = T1.OrderID
GROUP BY T1.ShipRegion, T1.OrderDate

--26. Muestre los registros de la tabla de empleados

SELECT * FROM Employees

--27. Muestre los nombres y apellidos de los empleados

SELECT 
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS [Nombre y apellido]
FROM Employees;

--28. Muestre los nombres de las ciudades que aparecen en la tabla de empleados. (No mostrar 2 veces un mismo nombre
--de la ciudad)

SELECT 
	DISTINCT City
	FROM Employees



--29. Muestre los nombres de productos y precios unitarios de la tabla productos
SELECT 
	ProductName, UnitPrice
FROM Products

--30. Muestre de la tabla de empleados que viven en USA

SELECT * FROM Employees WHERE Country = 'USA'

