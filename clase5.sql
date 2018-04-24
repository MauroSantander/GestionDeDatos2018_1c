--PRIMER EJEMPLO
/* 
customer_num es el campo que pertenece a ambas tablas, y por ende, el campo por el cual haremos el join.
o y c son alias para las tablas, es necesario indicar luego del ON a que tabla pertenece el campo.
A los campos que pertenecen a una sola tabla no es necesario poner el alias de su tabla.
En general vamos a comparar Foreign Keys contra Primary Keys, pero se puede hacer join por los campos que queramos.
*/
SELECT order_num, order_date, o.customer_num, lname, fname 
	FROM orders o JOIN customer c ON (o.customer_num = c.customer_num)
	WHERE c.customer_num BETWEEN 101 AND 115
GO
--segundo ejemplo
/*
En este caso no hace falta poner el alias luego del ON porque el campo a comparar tiene distinto nombre en ambas tablas.
*/
SELECT c.customer_num, lname, fname 
	FROM customer c JOIN state ON (code = state)
	WHERE c.customer_num BETWEEN 101 AND 115
GO

/*PRÁCTICA*/

--1)
SELECT c.customer_num, company, order_num
	FROM customer c JOIN orders o ON (c.customer_num = o.customer_num)
	ORDER BY c.customer_num
GO

--2)
SELECT o.order_num, item_num, description, i.manu_code, quantity, total_price
FROM orders o JOIN items i ON (o.order_num=i.order_num)
JOIN products p ON (p.manu_code=i.manu_code AND i.stock_num=p.stock_num)
JOIN product_types t ON (t.stock_num=p.stock_num)
WHERE o.order_num = 1004
GO

--3)
SELECT o.order_num, item_num, description, i.manu_code, quantity, total_price, manu_name
FROM orders o JOIN items i ON (o.order_num=i.order_num)
JOIN products p ON (p.manu_code=i.manu_code AND i.stock_num=p.stock_num)
JOIN product_types t ON (t.stock_num=p.stock_num)
JOIN manufact m ON (m.manu_code=i.manu_code)
WHERE o.order_num = 1004
GO

--4)
SELECT order_num, c.customer_num,fname, lname, company
	FROM customer c JOIN orders o ON (c.customer_num=o.customer_num)
GO

--5)
SELECT DISTINCT c.customer_num,fname, lname, company
	FROM customer c JOIN orders o ON (c.customer_num=o.customer_num)
GO

--6)
SELECT m.manu_name, p.stock_num, description, unit, unit_price, (unit_price*1.2) precio_junio
	FROM manufact m JOIN products p ON (m.manu_code=p.manu_code)
	JOIN product_types t ON (t.stock_num=p.stock_num)
	JOIN units u ON (u.unit_code=p.unit_code)
GO

--7)
SELECT o.order_num, item_num, description, i.quantity, (i.total_price*i.quantity)
FROM orders o JOIN items i ON (o.order_num=i.order_num)
JOIN product_types p ON (i.stock_num=p.stock_num)
-- JOIN product_types t ON (t.stock_num=p.stock_num)
WHERE o.order_num = 1004
GO

SELECT * FROM items	WHERE order_num=1004
GO

--8)
SELECT manu_name, lead_time FROM orders o JOIN items i ON (o.order_num=i.order_num)
	JOIN manufact m ON (i.manu_code=m.manu_code) WHERE o.customer_num=104
GO

--9)
SELECT o.order_num, order_date, item_num, description, quantity, total_price FROM orders o
JOIN items i ON (o.order_num=i.order_num)
JOIN product_types t ON (i.stock_num=t.stock_num)
GO

--10) falta ver el formato de phone
SELECT lname + ', ' + fname nombre_completo, phone, COUNT(order_num) cantidad_ordenes 
	FROM customer c
	JOIN orders o ON (c.customer_num=o.customer_num) 
	GROUP BY lname, fname, phone
GO

--11)
SELECT ship_date, lname + ', ' + fname nombre_completo, COUNT(order_num) cantidad_ordenes
	FROM customer c
	JOIN orders o ON (c.customer_num=o.customer_num)
	WHERE state='CA' AND zipcode BETWEEN 94000 AND 94100
	GROUP BY ship_date, lname, fname
	ORDER BY ship_date, nombre_completo
GO	