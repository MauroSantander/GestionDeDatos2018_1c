--PRACTICA TRIGGERS
--1)
CREATE TABLE stock_historia_precios (
 stock_historia_Id INT Identity PRIMARY KEY,
 stock_num INT,
 manu_code CHAR(3),
 fechaYhora DATETIME,
 usuario CHAR(20),
 unit_price_old DECIMAL,
 unit_price_new DECIMAL,
 estado char default 'A' check (estado IN ('A','I'))
)
GO

CREATE TRIGGER cambio_precios_stock ON products
AFTER UPDATE	
AS
BEGIN
DECLARE @unit_price_old
DECLARE @unit_price_new
DECLARE @stock_num
DECLARE @manu_code char(3)
DECLARE precios_stock CURSOR FOR --??
INSERT INTO products_historia_precios
(stock_num, manu_code, unit_price_new,  unit_price_old, fechaYHora, usuario)
SELECT i.stock.num
(stock_num, manu_code, unit_price_new, unit_price_old, fechaYHora, usuario)

VALUES

(@stock_num, @manu_code, @unit_price_new, @unit_price_old, GETDATE(),
CURRENT_USER)
FETCH NEXT FROM precios_stock
INTO @stock_num, @manu_code, @unit_price_new, @unit_price_old
END

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
