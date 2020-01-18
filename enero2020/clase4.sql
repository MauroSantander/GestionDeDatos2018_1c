--14. Escribir una consulta que liste todos los clientes que vivan en California ordenados por compañía. (En
--una tabla temporaria llamada forsam) Escribir otra sentencia SELECT que liste los datos de esa tabla para
--verificar si son correctos.
create table #forsam (
	customer_num smallint,
	fname varchar(15),
	lname varchar(15),
	company varchar(20),
	address1 varchar(20),
	address2 varchar(20),
	city varchar(15),
	state char(2),
	zipcode char(5),
	phone varchar(18),
	customer_num_referedBy smallint
)
insert into #forsam select * from customer where state='CA' order by company

select * from customer where state='CA' order by company
select * from #forsam order by company
--15. Obtener un listado con la cantidad de productos únicos vendidos de cada fabricante (de todos los
--productos que el fabricante tiene en la tabla productos cuantos fueron comprados), en donde el total
--comprado a cada fabricante sea mayor a 1500$. El listado deberá estar ordenado por cantidad de
--productos comprados de mayor a menor.
select * from items

select manu_code, Count(distinct stock_num) from items
group by manu_code
having sum(quantity * total_price)>1500
order by 2 desc

--16. Obtener un listado con el código de fabricante, nro de producto, la cantidad vendida (quantity), y el
--total vendido (total_price), para los fabricantes cuyo código tiene una “R” como segunda letra. Ordenados
--por código de fabricante y nro de producto.
--lo primero que entendi
select manu_code, stock_num, quantity, total_price from items  
where manu_code like '_R%' 
order by manu_code, stock_num
--la respuesta del git
select manu_code, stock_num, SUM(quantity) as cant_productos, Sum(total_price) as precio_total from items 
where manu_code like '_R%' 
group by manu_code, stock_num
order by manu_code,stock_num
--17. Crear una tabla temporal OrdenesTemp con la cantidad de ordenes por cada cliente, la fecha primera
--(order_date) y la fecha última de compra. Realizar una consulta de la tabla temp OrdenesTemp en donde
--la primer fecha de compra sea anterior a '2015-05-23 00:00:00.000'. Ordenar la consulta por
--fechaUltimaCompra en forma descendente.
select  customer_num, count(order_num) as cantidad, Min(order_date) primeraCompra, Max(order_date) ultimaCompra
into #OrdenesTemp
from orders
group by customer_num

select * from #ordenestemp
--18. Consultar la tabla temporal del punto anterior y obtener la cantidad de clientes con igual cantidad de
--compras. Ordenar el listado por cantidad de compras en orden descendente
select count(o.customer_num) from #OrdenesTemp o
group by customer

SELECT COUNT(customer_num) cantidadCientes, CantidadCompras FROM #OrdenesTemp GROUP BY CantidadCompras ORDER BY CantidadCompras DESC
--19. Desconectarse de la sesión. Volver a conectarse.
--20. Se desean obtener la cantidad de clientes por cada state y city, donde los clientes contengan el string
--‘ts’ en el nombre de compañía, el código postal este entre 93000 y 94100 y la ciudad no sea 'Mountain
--View'. Se desea el listado ordenado por ciudad
--21. Se desean obtener la cantidad de hijos que posea cada cliente por cada estado y que a su vez estos
--tengan algún padre, además solo se mostraran aquellos cuya compañía empiece con una letra que este
--en el rango de ‘A’ a ‘L’.
--22. Se desea obtener el promedio de lead_time por cada estado, donde los customeres deben tener una
--‘e’ en manu_name y el lead_time este entre 5 y 20.
--23. Se tiene la tabla units, de la cual se quiere saber la cantidad de unidades que hay por cada tipo (unit)
--que no tengan en nulo el descr_unit, y además se deben mostrar solamente los que cumplan que la
--cantidad mostrada se superior a 5. Al resultado final se le debe sumar 1