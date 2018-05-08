--Clase 7

--1)
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

SELECT * FROM orders WHERE customer_num=101

SELECT customer_num, COUNT(order_num) FROM orders GROUP BY customer_num

SELECT customer_num, SUM(total_price*quantity), o.order_num FROM items i JOIN orders o ON (o.order_num=i.order_num) 
WHERE customer_num=104
GROUP BY customer_num, o.order_num
GO

SELECT COUNT(order_num) FROM orders
GO

SELECT customer_num, SUM(total_price * quantity)/COUNT(o.order_num) promedio_general FROM items i JOIN orders o ON (i.order_num=o.order_date)
GROUP BY customer_num
GO

--2)
SELECT s.stock_num, m.manu_code, description, manu_name, SUM(quantity*total_price) 'u$ por producto', SUM(quantity) 'Unidad por producto' 
INTO #ABC_Productos 

FROM items i JOIN manufact m ON (i.manu_code=m.manu_code)
JOIN product_types s ON (i.stock_num=s.stock_num)
WHERE m.manu_code IN (SELECT s2.manu_code
						FROM products s2
						GROUP BY s2.manu_code
						HAVING COUNT(*) >= 10)
GROUP BY s.stock_num, m.manu_code, description, manu_name

/*
FROM (SELECT m.manu_code, COUNT(stock_num) cant, manu_name FROM manufact m JOIN products p ON (m.manu_code=p.manu_code) 
GROUP BY m.manu_code, manu_name
HAVING COUNT(stock_num) >= 10) m 
JOIN products p ON (m.manu_code=p.manu_code)
JOIN product_types t ON (p.stock_num=t.stock_num)
JOIN items i ON (p.stock_num=i.stock_num)
GROUP BY p.stock_num, description, manu_name, m.manu_code
ORDER BY 5*/
GO




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

--4)

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

--5)
SELECT TOP 1 COUNT(order_num) cant_ordenes_x_cliente 
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