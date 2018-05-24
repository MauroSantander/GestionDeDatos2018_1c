-- ########## Clase 9 ##########

-- ** Punto 1 a) **

CREATE VIEW vFabricantes
AS
SELECT m.manu_code, m.manu_name, COUNT(stock_num) cantidad_productos,
(SELECT MAX(order_date) FROM orders o JOIN items i
	ON o.order_num = i.order_num AND i.manu_code = m.manu_code) ult_compra
FROM manufact m LEFT JOIN products s ON (s.manu_code = m.manu_code)
GROUP BY m.manu_code, m.manu_name
HAVING COUNT(stock_num) = 0 OR COUNT(stock_num) > 1
GO

SELECT * FROM vFabricantes
GO

-- ** Punto 1 b) **
SELECT manu_code, manu_name, cantidad_productos,
	(CASE 
		WHEN ult_compra IS NULL THEN 'No posee Compras'
		WHEN ult_compra IS NOT NULL THEN CAST(ult_compra AS char)
	END) ultima_compra
FROM vFabricantes
GO

-- ** Punto 2 **
SELECT m.manu_code, m.manu_name, COUNT(DISTINCT o.order_num) cantidadOrdenes,
	SUM(total_price) totalComprado
FROM manufact m JOIN items i ON (m.manu_code = i.manu_code)
	JOIN orders o ON (o.order_num = i.order_num)
	JOIN products p ON (i.manu_code = p.manu_code AND i.stock_num = p.stock_num)
	JOIN product_types pt ON (p.stock_num = pt.stock_num)
WHERE description LIKE '%tennis%' OR description LIKE '%ball%'
	AND m.manu_code LIKE 'H__'
GROUP BY m.manu_code, m.manu_name
HAVING SUM(total_price) > (SELECT SUM(total_price) / COUNT(DISTINCT i.manu_code) FROM items i)
ORDER BY 4 DESC
GO

-- ** Punto 3 **
CREATE VIEW vClientes
AS
SELECT c.customer_num, c.lname, c.company, sname, 0 cantidad_ordenes,
		NULL ultima_compra, 0 total_ordenes, (SELECT SUM(total_price) FROM items) total_general
FROM customer c JOIN state s ON (c.state = s.code)
WHERE customer_num NOT IN (SELECT DISTINCT customer_num FROM orders)
UNION
SELECT c.customer_num, c.lname, c.company, sname, MAX(order_date),
		COUNT(DISTINCT o.order_num), SUM(i.total_price), (SELECT SUM(total_price) FROM items)
FROM customer c JOIN orders o ON (c.customer_num = o.customer_num)
	JOIN items i ON (o.order_num = i.order_num)
	JOIN state s ON (c.state = s.code)
WHERE c.customer_num IN (SELECT DISTINCT o2.customer_num FROM orders o2
	JOIN items i2 ON (o2.order_num = i2.order_num)
	WHERE i2.stock_num IN (SELECT stock_num FROM products GROUP BY stock_num HAVING COUNT(*) <= 2))
GROUP BY c.customer_num, c.lname, c.company, sname
HAVING COUNT(DISTINCT o.order_num) < 5
GO

SELECT * FROM vClientes ORDER BY 5 DESC, 1
GO

-- ** Punto 4 **
CREATE VIEW vProductosMasComprados
AS
SELECT TOP 5 pt.description, c.state, SUM(i.quantity) cantidadVendida, SUM(i.total_price) totalVendido
FROM product_types pt JOIN items i ON (pt.stock_num = i.stock_num)
	JOIN orders o ON (i.order_num = o.order_num)
	JOIN customer c ON (o.customer_num = c.customer_num)
GROUP BY pt.description, c.state
HAVING SUM(i.quantity) > (SELECT TOP 1 SUM(i1.quantity) FROM product_types pt1
							JOIN items i1 ON (pt1.stock_num = i1.stock_num)
							JOIN orders o1 ON (i1.order_num = o1.order_num)
							JOIN customer c1 ON (o1.customer_num = c1.customer_num)
							WHERE c1.state = c.state AND pt1.description != pt.description
							GROUP BY c1.state, pt1.description
							ORDER BY SUM(i1.quantity) DESC)
GO

SELECT * FROM vProductosMasComprados
ORDER BY cantidadVendida DESC
GO