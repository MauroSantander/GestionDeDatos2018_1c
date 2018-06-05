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

/* SELECT o.customer_num, (SELECT COUNT(order_num) FROM orders WHERE order_date >= @fecha_DES AND customer_num = o.customer_num),
	MAX(order_date), SUM(quantity) FROM orders o JOIN items i ON (o.order_num = i.order_num) GROUP BY o.customer_num */

SELECT * FROM customerStatistics
