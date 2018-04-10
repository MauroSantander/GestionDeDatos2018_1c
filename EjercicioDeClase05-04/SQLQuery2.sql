-- 1)listado de todos los clientes y sus direcciones

SELECT fname ,lname, address1, address2, city FROM customer;
GO

-- 2) listado anterior pero solo los que viven en California

SELECT fname, lname, address1, address2, city, state FROM customer WHERE state='CA';
GO

-- 3) 

SELECT DISTINCT city FROM customer WHERE state = 'CA'
GO

-- 4)

SELECT DISTINCT city FROM customer WHERE state = 'CA' ORDER BY city
GO

-- 5)

SELECT address1, address2 FROM customer WHERE customer_num = 103
GO

-- 6) 
SELECT stock_num, manu_code,unit_code FROM products WHERE manu_code = 'ANZ' ORDER BY unit_code
GO

-- 7)
SELECT DISTINCT manu_code FROM items ORDER BY manu_code
GO

-- 8)
SELECT order_num, order_date, customer_num, ship_date FROM orders
WHERE paid_date IS NULL AND year(ship_date) = 2015 AND MONTH(ship_date) BETWEEN 1 AND 9
GO

-- 9) una solucion agregando town a todas las compañias
SELECT customer_num, company + ' town' FROM customer
GO

--9) otra solucion buscando town en el nombre de la compañia
SELECT customer_num, company FROM customer WHERE company LIKE '%town%'
GO

-- 10)
--SELECT TOP 1 ship_charge FROM orders ORDER BY ship_charge
--SELECT TOP 1 ship_charge FROM orders ORDER BY ship_charge DESC   >> preguntar
SELECT MAX(ship_charge) precio_max, MIN(ship_charge) precio_min, AVG(ship_charge) promedio FROM orders
GO

-- 11)
SELECT order_num, order_date, ship_date FROM orders WHERE MONTH(order_date) = MONTH(ship_date)
GO

-- 12) preguntar bien que pide el ejercicio
SELECT customer_num, ship_date, ship_charge FROM orders ORDER BY ship_charge DESC
GO

-- 13) 
SELECT ship_date, SUM(ship_weight) total_peso FROM orders 
GROUP BY ship_date HAVING SUM(ship_weight) > 30 ORDER BY total_peso DESC
GO

