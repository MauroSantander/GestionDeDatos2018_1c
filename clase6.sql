--1
SELECT i.manu_code, manu_name, lead_time, SUM(total_price) total
FROM items i RIGHT JOIN manufact m
ON (i.manu_code=m.manu_code)
GROUP BY i.manu_code, manu_name, lead_time
ORDER BY 1 
GO
--2)

/*SELECT t.stock_num, description, m1.manu_code, m2.manu_code FROM manufact m1 
JOIN products p ON (p.manu_code=m1.manu_code) 
JOIN product_types t ON (p.stock_num=t.stock_num)
LEFT JOIN manufact m2 ON ()
GO*/

SELECT s1.stock_num, pt.description, s1.manu_code, s2.manu_code
FROM (products s1 JOIN product_types pt
		On (s1.stock_num = pt.stock_num))
LEFT JOIN products s2
ON (s1.stock_num=s2.stock_num AND s1.manu_code != s2.manu_code) --con un < hacemos que no nos muestre la igualdad de manera bilateral (las inversas)
GO

--3)
SELECT c.customer_num, c.lname, c.fname, COUNT(o.order_num) cant_ordenes
FROM customer c JOIN orders o
	ON (c.customer_num = o.customer_num)
GROUP BY c.customer_num, lname, fname
	HAVING COUNT(o.order_num)>1
GO

--4) preguntar porque no entendemos
SELECT order_num, SUM(total_price) total FROM items i
	GROUP BY order_num
	HAVING (SUM(total_price) < SUM(SUM(total_price))/COUNT(order_num))
GO

--5)
SELECT m.manu_code, manu_name, p.stock_num, description, unit_price FROM 
	manufact m JOIN products p ON (m.manu_code=p.manu_code) 
	JOIN product_types t ON(p.stock_num=t.stock_num)
	JOIN
	(SELECT manu_code, AVG(unit_price) promedio FROM products 
	GROUP BY manu_code) a ON (a.manu_code=m.manu_code)
	WHERE unit_price > promedio
	GO
	
	Select manu_code, AVG(unit_price) promedio FROM products 
	GROUP BY manu_code
	GO

--6)
SELECT c.customer_num, company, o.order_num, order_date, FROM orders o
	JOIN customer c ON (c.customer_num=o.customer_num)
	JOIN items i ON (o.order_num=i.order_num)
	JOIN product_types t ON (i.stock_num=t.stock_num)
	WHERE NOT EXISTS (SELECT * FROM orders WHERE description='baseball gloves')
	GO

--7)
SELECT * FROM products
WHERE manu_code = 'HRO'
UNION
SELECT * FROM products
WHERE stock_num=1
GO

--8)
SELECT 'A' clave_de_ordenamiento, city, company FROM customer
WHERE city='Redwood City'
UNION
SELECT 'B' clave_de_ordenamiento, city, company FROM customer WHERE city!='Redwood City'
ORDER BY clave_de_ordenamiento, city
GO

--9)
CREATE VIEW ClientesConMultiplesOrdenes 
AS SELECT c.customer_num, c.lname, c.fname, COUNT(o.order_num) cant_ordenes
FROM customer c JOIN orders o
	ON (c.customer_num = o.customer_num)
GROUP BY c.customer_num, lname, fname
	HAVING COUNT(o.order_num)>1
GO

--10) completar
CREATE VIEW Productos_HRO
AS SELECT * FROM products
	WHERE manu_code = 'HRO'
WITH CHECK OPTION
GO

--11)
BEGIN TRANSACTION
INSERT INTO customer
(customer_num,fname,lname)
VALUES  (777,'Fred','Flintstone')
GO
SELECT * FROM customer WHERE fname='Fred'
GO
ROLLBACK TRANSACTION
GO

--12) preguntar
BEGIN TRANSACTION
INSERT INTO manufact
(manu_code,manu_name,lead_time,state)
VALUES ('AZZ', 'AZZIODivisionSA',5,'CA')
GO
INSERT INTO products 
(manu_code,stock_num,unit_code,unit_price)
VALUES ('AZZ',(SELECT p.stock_num,unit_code,unit_price FROM products p JOIN product_types t ON (p.stock_num=t.stock_num)
WHERE manu_code='ANZ' AND description LIKE '%tennis%'))
GO
ROLLBACK TRANSACTION