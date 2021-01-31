--Use pruebas
--go

--Create table Direccion (
--dir_id int primary key identity(1,1),
--dir_calle varchar(30),
--dir_numero int,
--dir_localidad varchar(30),
--dir_piso smallint,
--dir_depto smallint,
--)

--Create Table Usuario (
--usua_id int primary key identity(1,1),
--usua_nombre varchar(30),
--usua_apellido varchar(30),
--usua_direccion int references Direccion
--)

--insert into Direccion values ('Erstwild Court', 213, 'Sunnyvale',1,2)
--insert into Direccion values ('Geary St', 785,'San Francisco',1,2)
--insert into Direccion values ('Poplar', 654,'Palo Alto',1,1)
--insert into Usuario values ('Ludwig','Pauli',1)
--insert into Usuario values ('Carole','Sadler',2)
--insert into Usuario values ('Philip','Currie',3)

--insert into Usuario values ('Elba','Sura',NULL) --usuario sin direccion


--select * from Direccion
--select * from Usuario

-----------------Resolución propuesta-----------------

--Paso 1) crear tabla intermedia porque la relación es de muchos a muchos
create table usuario_direccion (
id_usuario int references Usuario,
id_direccion int references Direccion
primary key(id_usuario, id_direccion)
)

--Paso 2) migrar los datos (asumo que todas las direcciones son correspondidas por al menos un usuario)
insert into usuario_direccion select usua_id, usua_direccion from Usuario

--sin asumir eso, podemos tener usuarios sin direccion y direcciones no referenciadas por ningun usuario:
--insert into Direccion values ('Sarmiento', 1026,'Lanús',1,1) --direccion sin usuario que la corresponda
--	LA POLEMICA
--insert into usuario_direccion 
--(
--((select usua_id, d.dir_id from Usuario u join Direccion d on (u.usua_direccion=d.dir_id))
--union
--(select usua_id, d.dir_id from Usuario u left join Direccion d on (u.usua_direccion=d.dir_id)))
--union
--(select usua_id, d.dir_id from Usuario u right join Direccion d on (u.usua_direccion=d.dir_id))
--)

--select * from usuario_direccion

--Paso 3) quitar la relación directa entre las tablas Usuario y Direccion
begin tran
alter table Usuario drop constraint [FK__Usuario__usua_di__267ABA7A]; --elimina la constraint
alter table Usuario drop column usua_direccion --elimina la columna y sus datos
rollback commit

--Paso 4) agregar la descripcion de no mas de 100 caracteres y opcional
ALTER TABLE dbo.Direccion ADD dir_descripcion VARCHAR(100)

-------------------FIN RESOLUCION---------------------

--drop table usuario_direccion
--drop table Usuario
--drop table Direccion

--select * from usuario_direccion
--select * from Usuario
--select * from Direccion
