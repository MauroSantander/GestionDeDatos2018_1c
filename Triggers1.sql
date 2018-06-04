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
DECLARE precios_stock CURSOR FOR --??
SELECT i.stock_num, i.manu_code, i.unit_price, d.unit_price
FROM inserted i JOIN deleted d ON (i.stock_num=d.stock_num)
WHERE (i.unit_price != d.unit_price)
OPEN precios_stock
FETCH NEXT FROM precios_stock
INTO @stock_num, @manu_code, @unit_price_new, @unit_price_old
WHILE @@FETCH_STATUS = 0

Begin

INSERT INTO stock_historia_precios
(stock_num, manu_code, unit_price_new,  unit_price_old, fechaYHora, usuario)

VALUES

(@stock_num, @manu_code, @unit_price_new, @unit_price_old, GETDATE(),
CURRENT_USER)
FETCH NEXT FROM precios_stock
INTO @stock_num, @manu_code, @unit_price_new, @unit_price_old
END
CLOSE precios_stock
DEALLOCATE precios_stock
END;
GO


--para obtener el usuario pordemos hacer el CURRENT_USER
--2)
CREATE TRIGGER cambio_estado
ON stock_historia_precios
INSTEAD OF DELETE
AS
BEGIN
	UPDATE stock_historia_precios
	SET estado='I'
	WHERE stock_historia_Id = @
END


--3)
CREATE TRIGGER validar_horario
ON products--stock_historia_precios
AFTER INSERT
AS
	BEGIN 
	IF(DATEPART(HOUR,GETDATE()) BETWEEN 8 AND 20)
		BEGIN
		INSERT INTO products
			select * from inserted
			end
			else
			begin

	
	END
GO
