
CREATE DATABASE kioskoapp
GO
USE kioskoapp
GO
CREATE TABLE familias(
codFamilia INT PRIMARY KEY,
descFamilia VARCHAR(100) NOT NULL);
GO

CREATE TABLE subfamilias(
codSubFamilia INT PRIMARY KEY,
descSubFamilia VARCHAR(100) NOT NULL,
codFamilia INT NOT NULL REFERENCES familias);
GO

CREATE TABLE productos(
codProducto INT PRIMARY KEY,
descProducto VARCHAR(100) NOT NULL,
codFamilia INT NOT NULL REFERENCES familias,
codSubFamilia INT NOT NULL REFERENCES subFamilias,
precio DECIMAL(10,2) NOT NULL CHECK(precio > 0));
GO

CREATE TABLE clientes(
codCliente INT PRIMARY KEY,
razonSocial VARCHAR(100) NOT NULL);
GO

CREATE TABLE facturas(
nroFactura BIGINT PRIMARY KEY,
fechaEmision DATE NOT NULL,
fechaVencimiento DATE NOT NULL,
codCliente INT REFERENCES clientes);
GO

CREATE TABLE items(
nroFactura BIGINT,
codProducto INT NOT NULL REFERENCES productos,
cantidad DECIMAL(10,3) NOT NULL CHECK(cantidad > 0),
precio DECIMAL(10,2) NOT NULL CHECK(precio > 0),
PRIMARY KEY(nroFactura, codProducto));
GO

INSERT INTO familias VALUES (1, 'Familia 1');
GO
INSERT INTO subfamilias VALUES (1, 'SubFamilia 1', 1);
GO
INSERT INTO subfamilias VALUES (2,'SubFamilia 2', 1);
GO
INSERT INTO clientes VALUES (1, 'Fulano');
GO
INSERT INTO productos VALUES (1, 'Chicles Adams x 12', 1, 1, 20);
GO
INSERT INTO productos VALUES (2, 'Alfajor Capitan del Espacio', 1, 2, 25);
GO
INSERT INTO facturas VALUES (1, GETDATE(), GETDATE()+1, 1);
GO
INSERT INTO items VALUES (1, 1, 10, 20);
GO
INSERT INTO items VALUES (1, 2, 2, 25);
GO

SELECT * FROM productos;

