CREATE DATABASE ejercicio1
GO
USE ejercicio1
GO

CREATE TABLE provincias(
codProvincia INT PRIMARY KEY,
nomProvincia VARCHAR(50) NOT NULL);
GO

CREATE TABLE clientes(
codCliente INT PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(40) NOT NULL,
nroCuit INT NOT NULL,
telefono1 INT,
telefono2 INT,
direccion VARCHAR(30),
ciudad VARCHAR(40),
codProvincia INT NOT NULL REFERENCES provincias,
codigoPostal INT NOT NULL);
GO

CREATE TABLE tipoLlamados(
tipoLlamado INT PRIMARY KEY,
descTipoLlamado VARCHAR(100) NOT NULL);
GO

CREATE TABLE llamados(
idLlamado INT PRIMARY KEY,
fechaLlamado DATE NOT NULL,
telefonoLlamado INT NOT NULL,
tipoLlamado INT NOT NULL REFERENCES tipoLlamados,
duracion INT NOT NULL,
codCliente INT REFERENCES clientes);
GO

CREATE TABLE facturas(
nroFactura BIGINT PRIMARY KEY,
fechaFactura DATE NOT NULL,
codCliente INT NOT NULL REFERENCES clientes,
fechaVencimiento DATE NOT NULL);
GO

CREATE TABLE fabricantes(
codFabricante INT PRIMARY KEY,
nomFabricante VARCHAR(50) NOT NULL);
GO

CREATE TABLE productos(
codProducto INT PRIMARY KEY,
nomProducto VARCHAR(40) NOT NULL,
codFabricante INT NOT NULL REFERENCES fabricantes,
tiempoEntrega INT NOT NULL);
GO

CREATE TABLE items(
nroFactura BIGINT,
nroItem BIGINT,
codProducto INT NOT NULL REFERENCES productos,
precio DECIMAL(10,2) NOT NULL,
cantidad INT NOT NULL,
PRIMARY KEY(nroFactura, nroItem));
GO

INSERT INTO tipoLlamados VALUES (1, 'Llamado local');
GO
INSERT INTO llamados VALUES (1, GETDATE(), 1532765439, 1, 2, 1);
GO
INSERT INTO provincias VALUES (1, 'Buenos Aires');
GO
INSERT INTO clientes VALUES (1, 'Mauro', 'Santander', 1234, 46856932, 1134567890, 'noce123', 'Ciudad Bs As', 1, 1111);
GO

SELECT * FROM clientes