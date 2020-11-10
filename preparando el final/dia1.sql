--Se requiere crear una tabla temporal #ABC_Productos un ABC de Productos ordenado por cantidad
--de venta en u$, los datos solicitados son:
--Nro. de Stock, Código de fabricante, descripción del producto, Nombre de Fabricante, Total del producto
--pedido 'u$ por Producto', Cant. de producto pedido 'Unid. por Producto', para los productos que
--pertenezcan a fabricantes que fabriquen al menos 10 productos diferentes
use stores7new

--select manu_code from products 
--group by manu_code
--having COUNT(stock_num) >=10

--ok
SELECT p.stock_num, p.manu_code, description, manu_name, SUM(i.unit_price) as 'u$ por Producto', SUM(quantity) as 'Unid. por Producto'
FROM products p 
Join items i on (i.stock_num=p.stock_num)
JOin manufact m on (p.manu_code=m.manu_code)
Join product_types pt on (p.stock_num=pt.stock_num)
where p.manu_code in (select manu_code from products 
					group by manu_code
					having COUNT(stock_num) >=10)
group by p.stock_num, p.manu_code, description, manu_name
order by 6


SELECT i.stock_num, i.manu_code, description, manu_name,
 SUM(unit_price*quantity) 'u$ por Producto',
 SUM(quantity) 'Unid. por Producto'
INTO #ABC_Productos
FROM items i JOIN manufact m ON (i.manu_code = m.manu_code)
 JOIN product_types s ON (i.stock_num = s.stock_num)
WHERE i.manu_code IN (SELECT s2.manu_code
 FROM products s2
GROUP BY s2.manu_code
 HAVING COUNT(*) >= 10)
GROUP BY i.stock_num, i.manu_code, description, manu_name 

select * from #ABC_Productos order by 6


--Liste el código y nombre del fabricante, la cantidad de órdenes de compra que contengan
--sus productos y la monto total de los productos vendidos.
--Mostrar sólo los fabricantes cuyo código comience con A ó con N y posea 3 letras, y los
--productos cuya descripción posean el string “tennis” ó el string “ball” en cualquier parte del
--nombre y cuyo monto total vendido sea mayor que el total de ventas promedio de todos
--los fabricantes (Cantidad * precio unitario / Cantidad de fabricantes que vendieron sus
--productos).
--Mostrar los registros ordenados por monto total vendido de mayor a menor.

--ok
Select m.manu_code, m.manu_name, COUNT(DISTINCT order_num), SUM(quantity*i.unit_price) from manufact m
join items i on (i.manu_code=m.manu_code)
join product_types pt on (i.stock_num=pt.stock_num)
Where (m.manu_code like 'A__' or m.manu_code like 'N__')
and (description like '%tennis%' or description like '%ball%')
group by m.manu_code, m.manu_name
having SUM(quantity*i.unit_price) > (select 
(select SUM(quantity*unit_price) from items) / (select COUNT(DISTINCT(manu_code)) from items))
order by 4 DESC

SELECT m.manu_code, m.manu_name,
COUNT(DISTINCT i.order_num) cantidadOrdenes,
SUM(unit_price*quantity) totalVendido
FROM manufact m JOIN items i ON (m.manu_code=i.manu_code)
 JOIN product_types p ON (i.stock_num=p.stock_num)
WHERE (description LIKE '%tennis%' OR description LIKE '%ball%')
 AND m.manu_code LIKE '[AN]__'
GROUP BY m.manu_code, m.manu_name
HAVING SUM(unit_price*quantity) >
 (select SUM(unit_price*quantity)
 /count(DISTINCT i.manu_code) from items i)
 ORDER BY 4 DESC;


-- Listar los customers que no posean órdenes de compra y aquellos cuyas últimas
--órdenes de compra superen el promedio de todas las anteriores.
--Mostrar customer_num, fname, lname, paid_date y el monto total de la orden que
--supere el promedio de las anteriores. Ordenar el resultado por monto total en forma
--descendiente.--no da bienSELECT c.customer_num, fname, lname, paid_date, SUM(quantity*unit_price) as total from customer cLEFT JOIN orders o on (c.customer_num=o.customer_num)JOIN items i on (o.order_num=i.order_num)group by c.customer_num, fname, lname, paid_datehaving SUM(quantity*unit_price) >= (SELECT AVG(quantity*unit_price) from items i2join orders o2 on (i2.order_num=o2.order_num) where o2.customer_num=c.customer_num)order by 5 DESC--version 1 SELECT c.customer_num, c.fname, c.lname, o.paid_date,
 SUM(i.unit_price * i.quantity) Total
 FROM customer c JOIN orders o ON c.customer_num = o.customer_num
 JOIN items i ON o.order_num = i.order_num
WHERE o.order_num = (SELECT MAX(order_num)
 FROM orders o1
 WHERE o1.customer_num = c.customer_num)
GROUP BY c.customer_num, c.fname, c.lname, o.paid_date, o.order_num
HAVING SUM(i.unit_price * i.quantity) >=
 (SELECT SUM(i1.unit_price * i1.quantity)/count(distinct o1.order_num)
 FROM customer c1 JOIN orders o1
 ON (c1.customer_num = o1.customer_num)
 JOIN items i1 ON (o1.order_num = i1.order_num)
 WHERE o.order_num > o1.order_num AND c1.customer_num = c.customer_num)
UNION
SELECT c.customer_num, c.fname, c.lname, null, null
 FROM customer c LEFT JOIN orders o ON (c.customer_num = o.customer_num)
 LEFT JOIN items i ON (o.order_num = i.order_num)
WHERE c.customer_num NOT IN (SELECT customer_num FROM orders)
GROUP BY c.customer_num, c.fname, c.lname, o.paid_date
ORDER BY 5 DESC--version 2SELECT c.customer_num, c.fname, c.lname, o.paid_date,
 SUM(i.unit_price*i.quantity) total
 FROM customer c LEFT JOIN orders o ON c.customer_num = o.customer_num
 LEFT JOIN items i ON o.order_num = i.order_num
WHERE o.order_num = (SELECT MAX(order_num) FROM orders
 WHERE customer_num = c.customer_num)
OR c.customer_num NOT IN (SELECT customer_num FROM orders)
GROUP BY c.customer_num, c.fname, c.lname, o.order_num, o.paid_date
HAVING SUM(i.unit_price * i.quantity) >=
 (SELECT sum(i1.unit_price * i1.quantity) /
 count(distinct o1.order_num)
 FROM orders o1 JOIN items i1 ON o1.order_num = i1.order_num
 WHERE o.order_num > o1.order_num
 AND o1.customer_num = c.customer_num)
OR SUM(i.unit_price * i.quantity) IS NULL
ORDER BY SUM(i.unit_price * i.quantity) desc