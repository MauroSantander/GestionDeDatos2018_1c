--Clase 7

-- ** punto 1 **
SELECT c.customer_num, fname, lname,
SUM(total_price*quantity)'Total del Cliente',
COUNT(DISTINCT i.order_num)'OCs del Cliente',
(SELECT COUNT(o2.order_num) FROM orders o2) 'Cant Total OC'
FROM customer c JOIN orders o ON (c.customer_num = o.customer_num)
JOIN items i ON (o.order_num = i.order_num)
WHERE zipcode LIKE '94%'
GROUP by c.customer_num, fname, lname
HAVING (SUM(total_price*quantity)/COUNT(DISTINCT i.order_num))
> (SELECT (SUM(total_price*quantity)/COUNT(DISTINCT i3.order_num))
FROM items i3)
AND COUNT(DISTINCT i.order_num) >=2
GO

/*SELECT * FROM orders WHERE customer_num=101

SELECT customer_num, COUNT(order_num) FROM orders GROUP BY customer_num

SELECT customer_num, SUM(total_price*quantity), o.order_num FROM items i JOIN orders o ON (o.order_num=i.order_num) 
WHERE customer_num=104
GROUP BY customer_num, o.order_num
GO

SELECT COUNT(order_num) FROM orders
GO

SELECT customer_num, SUM(total_price * quantity)/COUNT(o.order_num) promedio_general FROM items i JOIN orders o ON (i.order_num=o.order_date)
GROUP BY customer_num
GO */



-- ** punto 2 **

SELECT s.stock_num, m.manu_code, description, manu_name, SUM(quantity*total_price) 'u$ por producto', SUM(quantity) 'Unidad por producto' 
INTO #ABC_Productos 

FROM items i JOIN manufact m ON (i.manu_code=m.manu_code)
JOIN product_types s ON (i.stock_num=s.stock_num)
WHERE m.manu_code IN (SELECT s2.manu_code
						FROM products s2
						GROUP BY s2.manu_code
						HAVING COUNT(*) >= 10)
GROUP BY s.stock_num, m.manu_code, description, manu_name
GO

/*
FROM (SELECT m.manu_code, COUNT(stock_num) cant, manu_name FROM manufact m JOIN products p ON (m.manu_code=p.manu_code) 
GROUP BY m.manu_code, manu_name
HAVING COUNT(stock_num) >= 10) m 
JOIN products p ON (m.manu_code=p.manu_code)
JOIN product_types t ON (p.stock_num=t.stock_num)
JOIN items i ON (p.stock_num=i.stock_num)
GROUP BY p.stock_num, description, manu_name, m.manu_code
ORDER BY 5
GO*/




-- ** punto 3 **
DROP TABLE #ABC_Productos

SELECT m.manu_code, COUNT(stock_num) cant, manu_name FROM manufact m JOIN products p ON (m.manu_code=p.manu_code) 
GROUP BY m.manu_code, manu_name
HAVING COUNT(stock_num) >= 10
GO

SELECT * FROM #ABC_Productos
GO
--3)

SELECT MONTH(), lanme + ', ' + fname nombre_completo, COUNT(DISTINCT order_num), 'Cant OC por mes' FROM #ABC_Productos
--hecho

-- ** punto 4 **

SELECT DISTINCT i1.stock_num, i1.manu_code, c1.customer_num, c1.lname + ', ' + c1.fname Nombre_Cliente1, c2.customer_num,
c2.lname + ', ' + c2.fname Nombre_Cliente1
FROM items i1 JOIN orders o1 ON (o1.order_num = i1.order_num)

JOIN customer c1 ON (o1.customer_num = c1.customer_num)
JOIN items i2 ON (i1.stock_num = i2.stock_num
AND i1.manu_code=i2.manu_code)
JOIN orders o2 ON (o2.order_num = i2.order_num)
JOIN customer c2 ON (o2.customer_num = c2.customer_num)
WHERE i1.stock_num IN (5,6,9)
AND i1.manu_code='ANZ'
AND (SELECT SUM(quantity) FROM items i11
JOIN orders o11 ON (i11.order_num=o11.order_num)
WHERE i11.stock_num=i1.stock_num
AND i11.manu_code=i1.manu_code
AND o11.customer_num = c1.customer_num)
>
(SELECT SUM(quantity) FROM items i12
JOIN orders o12 ON (i12.order_num=o12.order_num)
WHERE i12.stock_num=i2.stock_num
AND i12.manu_code=i2.manu_code
AND o12.customer_num = c2.customer_num)
GO

-- ** punto 5 **
SELECT (SELECT TOP 1 COUNT(order_num) cant_ordenes_x_cliente 
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
GROUP BY c.customer_num
ORDER BY 1 DESC) mayor_oc_por_un_cliente,
(SELECT TOP 1 SUM(total_price*quantity) lalala
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
JOIN items i ON (i.order_num=o.order_num)
GROUP BY c.customer_num
ORDER BY 1 DESC) mayor_total_u$_por_un_cliente,
(SELECT TOP 1 COUNT(item_num) FROM orders o JOIN customer c ON (o.customer_num = c.customer_num) 
JOIN items i ON (o.order_num = i.order_num)
GROUP BY c.customer_num, o.order_num
ORDER BY 1 DESC) mayor_cant_items_en_una_oc,
(SELECT TOP 1 COUNT(order_num) cant_ordenes_x_cliente 
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
GROUP BY c.customer_num
ORDER BY 1) menor_oc_por_un_cliente,
(SELECT TOP 1 SUM(total_price*quantity) lalala
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
JOIN items i ON (i.order_num=o.order_num)
GROUP BY c.customer_num
ORDER BY 1) menor_total_u$_por_un_cliente,
(SELECT TOP 1 COUNT(item_num) FROM orders o JOIN customer c ON (o.customer_num = c.customer_num) 
JOIN items i ON (o.order_num = i.order_num)
GROUP BY c.customer_num, o.order_num
ORDER BY 1) menor_cant_items_en_una_oc
GO

/*SELECT TOP 1 COUNT(order_num) cant_ordenes_x_cliente 
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
GROUP BY c.customer_num
ORDER BY 1 DESC
GO

SELECT TOP 1 SUM(total_price*quantity) lalala
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
JOIN items i ON (i.order_num=o.order_num)
GROUP BY c.customer_num
ORDER BY 1 DESC
GO

SELECT TOP 1 COUNT(item_num) FROM orders o JOIN customer c ON (o.customer_num = c.customer_num) 
JOIN items i ON (o.order_num = i.order_num)
GROUP BY c.customer_num, o.order_num
ORDER BY 1 DESC
GO

SELECT TOP 1 COUNT(order_num) cant_ordenes_x_cliente 
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
GROUP BY c.customer_num
ORDER BY 1
GO

SELECT TOP 1 SUM(total_price*quantity) lalala
FROM orders o JOIN customer c ON (c.customer_num=o.customer_num)
JOIN items i ON (i.order_num=o.order_num)
GROUP BY c.customer_num
ORDER BY 1
GO

SELECT TOP 1 COUNT(item_num) FROM orders o JOIN customer c ON (o.customer_num = c.customer_num) 
JOIN items i ON (o.order_num = i.order_num)
GROUP BY c.customer_num, o.order_num
ORDER BY 1
GO
*/


-- ** punto 6 **
--clientes de california con mas de 4 OC cobradas en 1998

SELECT * INTO #ClientesCalifornia FROM customer WHERE state = 'CA'

SELECT c.customer_num, 
COUNT(o.order_num) cant_ordenes, 
(SELECT i2.order_num, SUM(total_price*quantity) total_cobrado 
	FROM items i2 JOIN
	orders o2 ON (i2.order_num=o2.order_num)
	GROUP BY i2.order_num) total_cobrado 
FROM #ClientesCalifornia c
JOIN orders o ON (c.customer_num=o.customer_num)
JOIN items i1 ON (i1.order_num=o.order_num)
WHERE YEAR(paid_date)=1998--2015
GROUP BY (c.customer_num), paid_date
HAVING COUNT(o.order_num) > 4 AND 
SUM(i1.quantity)
> (SELECT 1 FROM (SELECT TOP 1 SUM(quantity) cant_maxima_items_en_una_orden FROM (SELECT * FROM customer WHERE state='AK') al 
JOIN (SELECT * FROM orders WHERE YEAR(paid_date)=1998) o
ON (o.customer_num=al.customer_num)
JOIN items i2
ON (i2.order_num=o.order_num)
GROUP BY i2.order_num) lala ) --aca es donde marca el error
GO
--total cobrado de cada orden
SELECT i2.order_num, SUM(total_price*quantity) total_cobrado FROM items i2 JOIN
orders o2 ON (i2.order_num=o2.order_num)
GROUP BY i2.order_num

--cantidad total de items por orden
SELECT i2.order_num, SUM(quantity) total_cobrado FROM items i2 JOIN
orders o2 ON (i2.order_num=o2.order_num)
GROUP BY i2.order_num

--orden con mayor cantidad de items en Alaska (AK)
SELECT * FROM orders o JOIN (SELECT * FROM customer WHERE state='AK') a
ON (o.customer_num=a.customer_num)

SELECT TOP 1 SUM(quantity) cant_maxima_items_en_una_orden FROM (SELECT * FROM customer WHERE state='AK') a 
JOIN orders o
ON (o.customer_num=a.customer_num)
JOIN items i2
ON (i2.order_num=o.order_num)
GROUP BY i2.order_num
GO

SELECT TOP 1 SUM(quantity) cant_maxima_items_en_una_orden FROM (SELECT * FROM customer WHERE state='AK') a 
JOIN (SELECT * FROM orders WHERE YEAR(paid_date)=1998) o
ON (o.customer_num=a.customer_num)
JOIN items i2
ON (i2.order_num=o.order_num)
GROUP BY i2.order_num
GO

-- ** punto 7 **

SELECT m.manu_code, manu_name, i.stock_num, description, SUM(quantity) comprasDeOtrosFabricantes
	FROM 
		manufact m JOIN items i ON (m.manu_code = i.manu_code)
		JOIN product_types pt ON (i.stock_num = pt.stock_num)
	WHERE 
		description LIKE '%shoes%' AND
		i.stock_num IN (SELECT stock_num FROM products GROUP BY stock_num HAVING COUNT(DISTINCT manu_code) > 2)
		AND i.item_num IN (SELECT item_num FROM items WHERE manu_code != m.manu_code)
	GROUP BY m.manu_code, manu_name, i.stock_num, description
	HAVING SUM(quantity) < 10
GO

-- ** punto 8 **
SELECT c1.state, sname, (c1.lname + ', ' + c1.fname) apellido_nombre_cliente1, (c2.lname + ', ' + c2.fname) apellido_nombre_cliente2, (ct1.total_dolares + ct2.total_dolares) total
	FROM (SELECT TOP 2 clientes_con_total.state,clientes_con_total.customer_num, clientes_con_total.total_dolares FROM (SELECT c.state, o.customer_num,COUNT(DISTINCT o.order_num)cantidad_de_ordenes, SUM(total_price * quantity) total_dolares
	FROM orders o JOIN items i ON
		(o.order_num = i.order_num)
		JOIN customer c ON (c.customer_num = o.customer_num)
		WHERE state = 'CA'
		GROUP BY c.state, o.customer_num) clientes_con_total
		ORDER BY total_dolares DESC) ct1 JOIN customer c1 ON (ct1.customer_num = c1.customer_num)
		JOIN ((SELECT TOP 2 clientes_con_total.state, clientes_con_total.customer_num, clientes_con_total.total_dolares FROM (SELECT c.state, o.customer_num,COUNT(DISTINCT o.order_num)cantidad_de_ordenes, SUM(total_price * quantity) total_dolares
		FROM orders o JOIN items i ON
		(o.order_num = i.order_num)
		JOIN customer c ON (c.customer_num = o.customer_num)
		WHERE state = 'CA'
		GROUP BY c.state, o.customer_num) clientes_con_total
		ORDER BY total_dolares DESC)) ct2 ON (ct1.state = ct2.state)
		JOIN customer c2 ON (ct2.customer_num = c2.customer_num)
		JOIN state s ON (s.code = c1.state)
		WHERE c1.customer_num < c2.customer_num
		GROUP BY c1.state, sname, c1.lname, c1.fname, c2.lname, c2.fname, ct1.total_dolares, ct2.total_dolares
GO

-- ** punto 9 **
SELECT order_num, customer_num, order_date,
(CASE customer_num
	WHEN (SELECT TOP 1 mejor_cliente.customer_num FROM (SELECT customer_num, SUM(quantity) total_productos FROM orders o JOIN items i ON (o.order_num = i.order_num)
		JOIN manufact m ON (i.manu_code = m.manu_code)
		WHERE m.manu_code = 'ANZ'
		GROUP BY customer_num) mejor_cliente
		ORDER BY total_productos DESC) THEN NULL
	ELSE (order_date + lead_time + 1) END) fecha_modificada
FROM (SELECT TOP 5 * FROM (SELECT customer_num, o.order_num, order_date, m.manu_code FROM orders o
JOIN items i ON (o.order_num = i.order_num)
JOIN manufact m ON (i.manu_code = m.manu_code)
WHERE m.manu_code = 'ANZ'
GROUP BY customer_num, order_date, o.order_num, m.manu_code) clientes_anz
ORDER BY order_date DESC) ca
JOIN manufact m ON (ca.manu_code = m.manu_code)
GO