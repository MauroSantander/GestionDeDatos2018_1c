-- Practica Stores Procedures
-- ** Punto a) **
-- 1)

DROP TABLE customerStatistics

CREATE TABLE customerStatistics(
	customer_num INT PRIMARY KEY,
	ordersqty INT,
	maxdate DATE,
	uniqueProducts INT)

SELECT * FROM customerStatistics

-- 2)
DROP PROCEDURE customerStatisticsUpdate
CREATE PROCEDURE customerStatisticsUpdate
	@fecha_DES DATE
AS
BEGIN
	DECLARE @customer_num INT
	DECLARE @ordersqty INT
	DECLARE @maxdate DATETIME
	DECLARE @uniqueProducts INT
	DECLARE estadisticaPorCliente
		CURSOR FOR SELECT customer_num FROM customer
	OPEN estadisticaPorCliente
	FETCH NEXT FROM estadisticaPorCliente INTO @customer_num
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @ordersqty=count(*) , @maxDate=max(order_date) FROM orders WHERE customer_num = @customer_num AND order_date >= @fecha_DES;
		SELECT @uniqueProducts=count(distinct manu_code) FROM items i, orders o WHERE o.customer_num = @customer_num AND o.order_num = i.order_num;
		IF @customer_num IN (SELECT customer_num FROM customerStatistics)
		BEGIN
			UPDATE customerStatistics
				SET ordersqty = @ordersqty,
				maxdate = @maxdate,
				uniqueProducts = @uniqueProducts
			WHERE customer_num = @customer_num
		END
		ELSE
		BEGIN
			INSERT INTO customerStatistics VALUES (@customer_num, @ordersqty, @maxdate, @uniqueProducts)
		END
	FETCH NEXT FROM estadisticaPorCliente INTO @customer_num
	END
	CLOSE estadisticaPorCliente
	DEALLOCATE estadisticaPorCliente
	
END
GO

EXEC customerStatisticsUpdate '26-06-1997'
EXEC customerStatisticsUpdate '2015-05-16'
/* SELECT o.customer_num, (SELECT COUNT(order_num) FROM orders WHERE order_date >= @fecha_DES AND customer_num = o.customer_num),
	MAX(order_date), SUM(quantity) FROM orders o JOIN items i ON (o.order_num = i.order_num) GROUP BY o.customer_num */

SELECT * FROM customerStatistics
GO
--** Punto b) **

/*
Crear la siguiente tabla informeStock con los siguientes campos
fechaInforme (date), stock_num (entero), manu_code (char(3) ), cantOrdenes
(entero), UltCompra (date), cantClientes (entero), totalVentas (decimal). PK
(fechaInforme, stock_num, manu_code)
*/

CREATE TABLE informeStock (
fechaInforme DATE, 
stock_num INTEGER, 
manu_code CHAR(3),
cantOrdenes INTEGER, 
UltCompra DATE, 
cantClientes INTEGER,
totalVentas DECIMAL,
PRIMARY KEY(fechaInforme,
stock_num,
manu_code) 
)
go

CREATE PROCEDURE generarInformeGerencial 
@fechaInforme DATE
AS
BEGIN


	DECLARE @stock_num SMALLINT
	DECLARE @manu_code CHAR(3)
	DECLARE @cant_ordenes SMALLINT
	DECLARE @ult_compra DATE
	DECLARE @cant_clientes SMALLINT
	DECLARE @total_ventas DECIMAL

	DECLARE cursorStock CURSOR FOR 
		SELECT * FROM products
	
	OPEN cursorStock
	FETCH NEXT FROM cursorStock INTO @stock_num, @manu_code
	WHILE @@FETCH_STATUS = 0
		BEGIN
		SELECT @stock_num=stock_num, @manu_code=manu_code FROM products
		SELECT @cant_ordenes=COUNT(DISTINCT o.order_num), @cant_clientes=COUNT(DISTINCT o.customer_num),@total_ventas=SUM(i.total_price), @ult_compra=MAX(o.order_date) FROM orders o, items i WHERE @fechaInforme=o.order_date AND @stock_num=i.stock_num AND @manu_code=i.manu_code
		IF @fechaInforme IN (SELECT fechaInforme FROM informeStock)
			BEGIN
			PRINT 'Ya existe una entrada con esa fecha en la tabla informeStock, no inserto nada'
			END
		ELSE
			BEGIN
			INSERT INTO informeStock VALUES (@fechaInforme, @stock_num, @manu_code, @cant_ordenes, @ult_compra, @cant_clientes, @total_ventas)
			END
		

		FETCH NEXT FROM cursorStock INTO @stock_num, @manu_code
		END
		CLOSE cursorStock
		DEALLOCATE cursorStock
END

