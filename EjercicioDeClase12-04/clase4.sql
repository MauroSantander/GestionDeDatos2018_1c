use stores7new
--Clase 4
CREATE table #clientes (
	customer_num SMALLINT PRIMARY KEY,
	fname VARCHAR(15),
	lname VARCHAR(15),
	company VARCHAR(20),
	state CHAR(2),
	city VARCHAR(15)
)

DROP table #clientes

--INSERT INTO #clientes SELECT * FROM customer


--1)
SELECT * INTO #clientes FROM customer --forma implicita

SELECT * FROM #clientes
GO
--2)
INSERT INTO #clientes
(customer_num, fname, lname, company, state, city)
VALUES (144,'Agustin','Creevy','Jaguares','CA','Los Angeles')

SELECT fname FROM #clientes WHERE customer_num=144

UPDATE #clientes 
SET fname = 'Agustin'
WHERE customer_num=144
GO

--3)
SELECT * INTO #clientesCalifornia FROM customer WHERE state='CA' --forma implicita

SELECT * FROM #clientesCalifornia
GO

--4)
INSERT INTO #clientes 
(customer_num, fname, lname, company, address1, address2, city,state, zipcode, phone)
SELECT
155,fname,lname,company, address1, address2, city,state, zipcode, phone FROM customer 
WHERE customer_num=103
GO

--5)
SELECT * FROM #clientes WHERE city LIKE 'M%' AND zipcode BETWEEN 94000 AND 94050
						
DELETE FROM #clientes WHERE city LIKE 'M%' AND zipcode BETWEEN 94000 AND 94050
GO

--7)
SELECT * FROM #clientes WHERE state='CO'

SELECT COUNT(customer_num) FROM #clientes WHERE state='CO' --para la validacion

UPDATE #clientes 
	SET state = 'AK',
		address2 = 'Barrio Las Heras'
	WHERE state='CO'
GO

--8)
SELECT phone FROM #clientes

UPDATE #clientes 
	SET phone = '1' + phone
GO

--9)
BEGIN TRANSACTION 

INSERT INTO #clientes
	(customer_num, lname, state, company)
	VALUES (166,'apellido','CA','nombre Empresa');

DELETE FROM #clientesCalifornia;

SELECT * FROM #clientes WHERE customer_num=166

SELECT * FROM #clientesCalifornia

ROLLBACK TRANSACTION