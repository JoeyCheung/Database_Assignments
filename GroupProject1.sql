﻿use TSQLV4

-- Simple Queries --

-- Write a query that generates 5 copies out of each employee row --
-- Tables involved: TSQLV4 database, Employees and Nums tables --
SELECT 
	E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E
	CROSS JOIN dbo.Nums AS N
WHERE N.n <= 5
ORDER BY n, empid;

-- Write a query that returns a row for each employee and day in the range June 12, 2016  June 16 2016 --
-- Tables involved: TSQLV4 database, Employees and Nums tables --
SELECT E.empid,
	DATEADD(day, D.n - 1, CAST('20160612' AS DATE)) AS dt
FROM HR.Employees AS E
	CROSS JOIN dbo.Nums AS D
WHERE D.n <= DATEDIFF(day, '20160612', '20160616') + 1
ORDER BY empid, dt;

-- Return US customers, and for each customer the total number of orders and total quantities --
-- Tables involved: TSQLV4 database, Customers, Orders and OrderDetails tables --
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
ON C.custid = O.custid;

-- Return customers who placed no orders --
-- Tables involved: TSQLV4 database, Customers and Orders tables --
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
ON C.custid = O.custid;

-- Return customers with orders placed on Feb 12, 2016 along with their orders --
-- Tables involved: TSQLV4 database, Customers and Orders tables --
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
		ON O.custid = C.custid
WHERE O.orderid IS NULL;

-- Medium Queries -- 

-- 4
-- Return customers and their orders including customers who placed no orders --
-- Tables involved: TSQLV4 database, Customers and Orders tables --
SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	WHERE C.country = N'USA'
GROUP BY C.custid;

-- Return customers and their orders -- 
-- Tables involved: Customers and Order tables --

SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
GROUP BY C.custid;

-- Write a query that is similar to the above query but where country is from japan -- 
-- Tables involved: Customers and Order tables --

SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
		WHERE C.country = N'JPN'
GROUP BY C.custid;

-- Write a query that produces a sequence of integers in the range 1 through 1000 --
-- Tables involved: dbo.Digits --
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM dbo.Digits AS D1
	CROSS JOIN dbo.Digits AS D2
	CROSS JOIN dbo.Digits AS D3
ORDER BY n;

-- Write a query that matches customers with their orders --
-- Tables involved: Sales.Customers --

SELECT C.custid, C.companyname, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid;

-- Write a query that has Sales.Customers and matches with Sales.Orders after that matches with Sales.OrderDetails
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid;

-- Write a query that's similar to the previous query but also includes customers wth no orders --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	LEFT OUTER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid;

-- Write a query that's similar to the previous query but also includes customers wth no orders by orderid in ascending order --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	LEFT OUTER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
ORDER BY O.orderid ASC;

-- Write a query that's similar to the previous query but also includes customers wth no orders in ascending order of custid --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	LEFT OUTER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
ORDER BY C.custid;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by custid --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid
ORDER BY C.custid;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by orderid in descending order --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid
ORDER BY O.orderid DESC;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by productid in ascending order --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid
ORDER BY OD.productid ASC;

-- Write a query that's similar to the above query but preserves Orders and OrderDetails as an independent unit --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
				ON O.orderid = OD.orderid)
		ON C.custid = O.custid;

-- Write a query that's similar to the above query but preserves Orders and OrderDetails as an independent unit in descending order by productid --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
				ON O.orderid = OD.orderid)
		ON C.custid = O.custid
ORDER BY OD.productid DESC;

-- Complicated Queries --

-- Write a query that matches customers with their orders including their order details audit --
-- Tables involved: Sales.Customers, Sales.Orders, Sales.OrderDetails, and Sales.OrderDetailsAudit -- 

SELECT C.custid, C.companyname, O.orderid, OD.productid, OD.qty, ODA.orderid
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit as ODA
		ON OD.orderid = ODA.orderid;

-- Return customers and their orders including customers who placed no orders and with their order detail audit -- 
-- Tables involved: Customers and Order tables --

SELECT C.custid, COUNT( DISTINCT ODA.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON O.orderid = ODA.orderid
GROUP BY C.custid;

-- Write a query that matches customers with their orders including their order details audit in ascending order of orderid --
-- Tables involved: Sales.Customers, Sales.Orders, Sales.OrderDetails, and Sales.OrderDetailsAudit -- 

SELECT C.custid, C.companyname, O.orderid, OD.productid, OD.qty, ODA.orderid
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit as ODA
		ON OD.orderid = ODA.orderid
ORDER BY ODA.orderid ASC;

-- Write a query that matches customers with their orders including their order details audit in descending order of orderid --
-- Tables involved: Sales.Customers, Sales.Orders, Sales.OrderDetails, and Sales.OrderDetailsAudit -- 

SELECT C.custid, C.companyname, O.orderid, OD.productid, OD.qty, ODA.orderid
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit as ODA
		ON OD.orderid = ODA.orderid
ORDER BY ODA.orderid DESC;

-- Write a query that's similar to the above query but preserves Orders, OrderDetails, and OrderDetailsAudit as an independent unit --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
				ON O.orderid = OD.orderid
			LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
				ON OD.orderid = ODA.orderid)
		ON C.custid = O.custid;

-- Write a query that's similar to the above query but preserves Orders, OrderDetails, and OrderDetailsAudit as an independent unit in Ascending order by orderid--
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
				ON O.orderid = OD.orderid
			LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
				ON OD.orderid = ODA.orderid)
		ON C.custid = O.custid
ORDER BY O.orderid ASC;

-- Write a query that's similar to the above query but preserves Orders, OrderDetails, and OrderDetailsAudit as an independent unit in Descending order by orderid--
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
				ON O.orderid = OD.orderid
			LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
				ON OD.orderid = ODA.orderid)
		ON C.custid = O.custid
ORDER BY O.orderid DESC;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by custid --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON OD.orderid = ODA.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by custid in ascending order --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON OD.orderid = ODA.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid
ORDER BY C.custid ASC;

-- Write a query that keeps Sales.Customers and joins with Sales.Order and Sales.OrderDetails ordered by custid in descending order --
-- Tables involved: Sales.Orders, Sales.Customers, and Sales.OrderDetails --

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON OD.orderid = ODA.orderid
	RIGHT OUTER JOIN Sales.Customers AS C
		ON O.custid = C.custid
ORDER BY C.custid DESC;