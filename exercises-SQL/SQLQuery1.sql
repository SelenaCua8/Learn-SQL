--31. Muestre los clientes: listar nombre de la empresa de todos los clientes que viven en las ciudades de London, Bracke y
--Cowes

SELECT CompanyName, City
FROM Customers
WHERE City IN ('London', 'Bracke', 'Cowes')
--32. Muestre los paises con su cantidad de clientes.
SELECT Country, 
COUNT(CustomerID) AS [Cant. Clientes] 
FROM Customers GROUP BY Country


--33. Muestre los clientes que tienen la región en blanco (NULL)
SELECT  * FROM Customers
WHERE Region IS NULL


--35. Muestre los 5 productos con mayor precio unitario.
SELECT TOP 5 
		ProductID,
		ProductName,
		UnitPrice
FROM Products
ORDER BY 3 DESC;

--36. Muestre los 5 productos con menor precio unitario
SELECT TOP 5 
		ProductID,
		ProductName,
		UnitPrice
FROM Products
ORDER BY 3 ASC;


--37. Muestre el conteo de empleados agrupados por el cargo.
SELECT
	Title,
	COUNT(1) AS [Cant. Empleados]
	FROM Employees
	GROUP BY Title;

--38. Muestre los clientes, cantidad de órdenes y el total de compras efectuadas
SELECT 
		C.CustomerID,
		C.CompanyName,
		COUNT(O.OrderID) AS [Cant. Ordenes],
		SUM(OD.Quantity * OD.UnitPrice) AS [Total]
FROM Customers C
INNER JOIN Orders O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.CompanyName



--39. Respecto a la pregunta 38, muestre los 5 clientes que más compraron
SELECT TOP 5 * FROM 
(
SELECT 
		C.CustomerID,
		C.CompanyName,
		COUNT(O.OrderID) AS [Cant. Ordenes],
		SUM(OD.Quantity * OD.UnitPrice) AS [Total]
FROM Customers C
INNER JOIN Orders O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.CompanyName

)AS T
ORDER BY 4 DESC

--40. Muestre los proveedores y su cantidad de productos que han vendido.
SELECT 
	S.SupplierID,
	S.CompanyName,
	COUNT(P.ProductID) AS [Cant. Productors]
FROM Suppliers S
INNER JOIN Products P ON P.SupplierID = S.SupplierID
GROUP BY S.SupplierID, S.CompanyName


--41. Muestre la cantidad de pedidos y su valorizado (precio por cantidad)
--agrupados por año. Ordénelo por año.

SELECT 
	YEAR(O.OrderDate) AS [Anio],
	COUNT(O.OrderID) AS [Cant. Ordenes],
	SUM(OD.Quantity * OD.UnitPrice) AS [Total]
FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY YEAR(O.OrderDate)
ORDER BY 1;


--42. Muestre el total de pedidos y el importe total por cada uno de ellos.
SELECT 
	O.OrderID,
	SUM(OD.Quantity * OD.UnitPrice) AS [Importe Total]
	FROM Orders O
	INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
	GROUP BY O.OrderID