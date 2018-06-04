--1)

CREATE FUNCTION dia_x_idioma (@idioma VARCHAR(3), @fecha DATE)
	RETURNS VARCHAR(15)
	BEGIN
	DECLARE @diaNombre VARCHAR(15);
	DECLARE @diaNumero INTEGER
	SET @diaNumero = datepart(WEEKDAY,@fecha);
	
	IF @idioma = 'esp' 
	BEGIN
		SET @diaNombre = 	CASE @diaNumero
			WHEN 1 THEN 'Domingo'
			WHEN 2 THEN 'Lunes'
			WHEN 3 THEN 'Martes'
			WHEN 4 THEN 'Miercoles'
			WHEN 5 THEN 'Jueves'
			WHEN 6 THEN 'Viernes'
			WHEN 7 THEN 'Sabado' 
			END
	END
	
	ELSE 
	
	BEGIN
		SET @diaNombre = CASE @diaNumero
			WHEN 1 THEN 'Sunday'
			WHEN 2 THEN 'Monday'
			WHEN 3 THEN 'Tuesday'
			WHEN 4 THEN 'Wednesday'
			WHEN 5 THEN 'Thursday'
			WHEN 6 THEN 'Friday'
			WHEN 7 THEN 'Saturday' END
	END
 RETURN @diaNombre;
 END
 GO


 --3)
 CREATE FUNCTION fabricantes_x_stock_num (@stock_num SMALLINT)
	RETURNS @retorno VARCHAR(40)




