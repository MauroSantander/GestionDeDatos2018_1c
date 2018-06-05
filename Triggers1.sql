--PRACTICA TRIGGERS
--1)
CREATE TABLE stock_historia_precios (
 stock_historia_Id INT Identity PRIMARY KEY,
 stock_num SMALLINT,
 manu_code CHAR(3),
 fechaYhora DATETIME,
 usuario VARCHAR(20),
 unit_price_old DECIMAL,
 unit_price_new DECIMAL,
 estado CHAR DEFAULT 'A' CHECK (estado IN ('A','I'))
)
GO

CREATE TRIGGER cambio_precios_stock ON products
AFTER UPDATE	
AS
BEGIN
DECLARE @unit_price_old DECIMAL
DECLARE @unit_price_new DECIMAL
DECLARE @stock_num SMALLINT
DECLARE @manu_code CHAR(3)
DECLARE precios_stock CURSOR FOR 
SELECT i.stock_num, i.manu_code, i.unit_price, d.unit_price
FROM inserted i JOIN deleted d ON (i.stock_num=d.stock_num)
WHERE (i.unit_price != d.unit_price)
OPEN precios_stock
FETCH NEXT FROM precios_stock
INTO @stock_num, @manu_code, @unit_price_new, @unit_price_old
WHILE @@FETCH_STATUS = 0

BEGIN

INSERT INTO stock_historia_precios
(stock_num, manu_code, unit_price_new,  unit_price_old, fechaYHora, usuario)

VALUES

(@stock_num, @manu_code, @unit_price_new, @unit_price_old, GETDATE(),
CURRENT_USER)

FETCH NEXT FROM precios_stock
INTO @stock_num, @manu_code, @unit_price_new, @unit_price_old
END --DEL WHILE
CLOSE precios_stock
DEALLOCATE precios_stock
END; --DEL TRIGGER
GO
--CONSULTAS DE PRUEBA
SELECT * FROM stock_historia_precios
GO

BEGIN TRANSACTION
UPDATE Products
SET unit_price=249
WHERE stock_num=1 AND manu_code='HRO'
ROLLBACK TRANSACTION

SELECT * FROM products
GO
--para obtener el usuario pordemos hacer el CURRENT_USER
--2)
DROP TRIGGER cambio_estado

CREATE TRIGGER cambio_estado
ON stock_historia_precios
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_historia_precios INT
	DECLARE cursor_cambio_estado CURSOR FOR
	SELECT stock_historia_Id FROM deleted
	OPEN cursor_cambio_estado
	FETCH NEXT FROM cursor_cambio_estado INTO @id_historia_precios
	WHILE
	@@FETCH_STATUS = 0 
	BEGIN
	UPDATE stock_historia_precios SET estado = 'I'
	WHERE stock_historia_Id = @id_historia_precios
	FETCH NEXT FROM cursor_cambio_estado INTO @id_historia_precios
		END
CLOSE cursor_cambio_estado
DEALLOCATE cursor_cambio_estado
END;
GO

--CONSULTAS DE PRUEBA
BEGIN TRANSACTION
DELETE FROM stock_historia_precios WHERE stock_historia_Id=2

ROLLBACK TRANSACTION

--3)
CREATE TRIGGER validar_horario
ON products--stock_historia_precios
INSTEAD OF INSERT
AS
	BEGIN 
	
	IF(DATEPART(HOUR,GETDATE()) BETWEEN 8 AND 20)
		BEGIN
		INSERT INTO products (stock_num, manu_code, unit_price, unit_code)
			SELECT stock_num, manu_code, unit_price, unit_code FROM inserted
		END
	ELSE
	BEGIN
	--SI NO PUEDE
	--RAISERROR('A te haces el chistoso?', 12, 1)
	PRINT 'NO ES POSIBLE COMPLETAR LA ACCION'
	END
END
GO
--CONSULTAS PRUEBA
BEGIN TRANSACTION
INSERT INTO products (stock_num, manu_code, unit_price, unit_code)
	VALUES (1, 'HRO', 5555, 1)
ROLLBACK TRANSACTION	
	GO


--4)
CREATE TRIGGER borra_en_cascada 
	ON orders 
	INSTEAD OF DELETE 
	AS
	BEGIN
	DECLARE @customer_num SMALLINT
	DECLARE @order_num SMALLINT
	IF(COUNT(*) < 2)
		BEGIN
		SELECT @order_num = order_num, @customer_num = customer_num FROM deleted
		DELETE FROM items WHERE order_num = @order_num
		DELETE FROM orders WHERE order_num = @order_num AND customer_num = @customer_num
		END
		ELSE
			BEGIN
			RAISERROR('no se puede completar la operacion',51,46)
			END

	END
GO