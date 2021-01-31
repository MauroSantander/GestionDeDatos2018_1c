CREATE TABLE Caballos(
idCaballo int PRIMARY KEY ,
nombre varchar(100) NOT NULL)
GO
CREATE TABLE Carreras(
idCarrera int,
posicion int,
idCaballo int NOT NULL,
totalApostado int NOT NULL,
CONSTRAINT pk_carreras PRIMARY KEY (idCarrera, posicion))
GO

--insert into Caballos values (1,'Wakabayashi')
--insert into Caballos values (4,'Ishizaki')
--insert into Caballos values (5,'Jito')
--insert into Caballos values (6,'Misugi')
--insert into Caballos values (7,'Soda')
--insert into Caballos values (12,'Matsuyama')
--insert into Caballos values (20,'Shingo')
--insert into Caballos values (10,'Tsubasa')
--insert into Caballos values (11,'Misaki')
--insert into Caballos values (9,'Hyuga')
--insert into Caballos values (18,'Nitta')

--insert into Carreras values (1,1,1,100)
--insert into Carreras values (2,1,6,600)
--insert into Carreras values (3,1,12,1200)
--insert into Carreras values (4,1,9,900)
--insert into Carreras values (4,2,9,100)
--insert into Carreras values (4,3,9,100)
--insert into Carreras values (4,4,9,100)
use pruebas


SELECT * FROM Carreras

SELECT R2.idCarrera, COUNT(*) AS Cantidad, SUM(R1.totalApostado) AS Total1,
SUM(R2.totalApostado) AS Total2
FROM Carreras R1
INNER JOIN Carreras R2 ON R1.idCarrera = R2.idCarrera
INNER JOIN Caballos H ON R1.idCaballo = H.idCaballo
WHERE R1.posicion = 1
GROUP BY R2.idCarrera