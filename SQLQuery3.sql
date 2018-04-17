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

--14)
SELECT * INTO #forsam FROM customer WHERE state = 'CA'

SELECT * FROM #forsam ORDER BY company
GO

--15)

SELECT DISTINCT item_num FROM items

GO

--16)

SELECT manu_code, stock_num, COUNT(quantity) cant_productos, SUM(total_price) precio_final
 FROM items WHERE manu_code LIKE '_R%' 
 GROUP BY manu_code, stock_num 
 ORDER BY manu_code, stock_num

SELECT * FROM items
GO

--17)

SELECT customer_num, COUNT(order_num)CantidadCompras,
MIN(order_date)fechaPrimerCompra, MAX(order_date) fechaUltimaCompra
INTO #OrdenesTemp
FROM orders
GROUP BY customer_num
SELECT * FROM #ordenesTemp WHERE fechaPrimerCompra < '2015-05-23 00:00:00.000'
ORDER BY fechaUltimaCompra DESC
/*
SELECT customer_num, COUNT(order_num) cantidadXCliente INTO #OrdenesTemp FROM orders GROUP BY customer_num

ALTER TABLE #OrdenesTemp
ADD primer_compra datetime;

ALTER TABLE #OrdenesTemp
ADD ultima_compra datetime;

INSERT INTO #OrdenesTemp (primer_compra)
	VALUES ()

SELECT customer_num, order_date FROM orders ORDER BY customer_num

DROP TABLE #OrdenesTemp
*/
SELECT * FROM #OrdenesTemp

GO

--18)
SELECT COUNT(customer_num) cantidadCientes, CantidadCompras FROM #OrdenesTemp GROUP BY CantidadCompras ORDER BY CantidadCompras DESC

--19) hecho
GO


--20)
SELECT state, city, COUNT(customer_num) cant_clientes
  FROM customer WHERE company LIKE '%ts%' 
		AND zipcode BETWEEN 93000 AND 94100
		AND city != 'Mountain View'
		GROUP BY state, city
		ORDER BY city
GO

--21)
SELECT customer_num_referedBy, state, COUNT(customer_num) cantidad_clientes
FROM customer 
WHERE company LIKE '[A-L]%' 
AND customer_num_referedBy IS NOT NULL
GROUP BY customer_num_referedBy,state
GO

--22)
SELECT state, AVG(lead_time) promedio FROM manufact 
	WHERE lead_time BETWEEN 5 AND 20 
	AND manu_name LIKE '%e%'
	GROUP BY state
GO

--23)
SELECT unit, COUNT(unit_code)+1 cantidad_final FROM units
	WHERE unit_descr IS NOT NULL
	GROUP BY unit
	HAVING COUNT(unit_code) > 5
GO