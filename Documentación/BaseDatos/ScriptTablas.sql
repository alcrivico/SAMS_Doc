CREATE DATABASE[SAMS.Data];
GO
USE [SAMS.Data];
GO
CREATE TABLE [Proveedor] (
	[id] int IDENTITY(1,1) NOT NULL,
	[rfc] varchar(13) NOT NULL ,
	[nombre] varchar(max) NOT NULL,
	[correo] varchar(max) NOT NULL,
	[telefono] varchar(10) NOT NULL,
	[estadoProveedor] bit NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Monedero] (
	[id] int IDENTITY(1,1) NOT NULL,
	[codigoDeBarras] varchar(20) NOT NULL ,
	[saldo] decimal(8,2) NOT NULL,
	[telefono] varchar(10) NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [EstadoProducto] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL ,
	PRIMARY KEY ([id])
);

CREATE TABLE [ProductoInventario] (
	[id] int IDENTITY(1,1) NOT NULL,
	[codigo] varchar(20) NOT NULL ,
	[nombre] varchar(max) NOT NULL,
	[descripcion] varchar(max) NOT NULL,
	[cantidadBodega] int NOT NULL,
	[cantidadExhibicion] int NOT NULL,
	[precioActual] decimal(8,2) NOT NULL,
	[esPerecedero] bit NOT NULL,
	[esDevolvible] bit NOT NULL,
	[ubicacion] bit NOT NULL,
	[idUnidadMedida] int NOT NULL,
	[idCategoria] int NOT NULL,
	[idEstado] int NOT NULL,
	[idPromocion] int,
	PRIMARY KEY ([id])
);

CREATE TABLE [DetallePedido] (
	[id] int IDENTITY(1,1) NOT NULL,
	[cantidad] int NOT NULL,
	[precioCompra] decimal(8,2) NOT NULL,
	[idPedido] int NOT NULL,
	[idProductoProveedor] int NOT NULL,
	[fechaCaducidad] date NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Caja] (
	[id] int IDENTITY(1,1) NOT NULL,
	[noCaja] varchar(2) NOT NULL,
	[horaDeCorte] datetime NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Puesto] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL ,
	PRIMARY KEY ([id])
);

CREATE TABLE [Categoria] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL ,
    [estado] bit NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Pedido] (
	[id] int IDENTITY(1,1) NOT NULL,
	[noPedido] varchar(max) NOT NULL ,
	[fechaPedido] date NOT NULL,
	[fechaEntrega] date NOT NULL,
	[idEstadoPedido] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Promocion] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL,
	[porcentajeDescuento] int NOT NULL,
	[cantMaxima] int NOT NULL,
	[cantMinima] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Empleado] (
	[id] int NOT NULL,
	[rfc] varchar(13) NOT NULL ,
	[noempleado] varchar(255) NOT NULL,
	[nombre] varchar(255) NOT NULL,
	[apellidoPaterno] varchar(255) NOT NULL,
	[apellidoMaterno] varchar(255),
	[correo] varchar(255) NOT NULL,
	[password] varchar(255) NOT NULL,
	[telefono] varchar(10) NOT NULL,
	[idPuesto] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Merma] (
	[id] int IDENTITY(1,1) NOT NULL,
	[cantidad] int NOT NULL,
	[descripcion] varchar(max) NOT NULL,
	[fechaRegistro] date NOT NULL,
	[idProductoInventario] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [UnidadDeMedida] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL ,
	PRIMARY KEY ([id])
);

CREATE TABLE [EstadoPedido] (
	[id] int IDENTITY(1,1) NOT NULL,
	[nombre] varchar(max) NOT NULL ,
	PRIMARY KEY ([id])
);

CREATE TABLE [Venta] (
	[id] int IDENTITY(1,1) NOT NULL,
	[noVenta] int NOT NULL ,
	[fechaRegistro] datetime NOT NULL,
	[iva] decimal(8,2) NOT NULL,
	[idCaja] int NOT NULL,
	[idMonedero] int NOT NULL,
	[idEmpleado] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [DetalleVenta] (
	[id] int IDENTITY(1,1) NOT NULL,
	[cantidad] int NOT NULL,
	[precioVenta] decimal(8,2) NOT NULL,
	[idVenta] int NOT NULL,
	[idProductoInventario] int NOT NULL,
	[ganancia] decimal(8,2) NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Producto] (
	[id] int IDENTITY(1,1) NOT NULL,
	[codigo] varchar(20) NOT NULL ,
	[descripcion] varchar(max) NOT NULL,
	[esDevolvible] bit NOT NULL,
	[esPerecedero] bit NOT NULL,
	[nombre] varchar(max) NOT NULL,
	[idProveedor] int NOT NULL,
	[idUnidadMedida] int NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [PromocionVigencia] (
	[id] int IDENTITY(1,1) NOT NULL ,
	[fechaFin] date NOT NULL,
	[fechaInicio] date NOT NULL,
	[idPromocion] int NOT NULL,
	PRIMARY KEY ([id])
);


ALTER TABLE [ProductoInventario] ADD CONSTRAINT [FK_ProductoInventario_UnidadMedida] FOREIGN KEY ([idUnidadMedida]) REFERENCES [UnidadDeMedida]([id]);
ALTER TABLE [ProductoInventario] ADD CONSTRAINT [FK_ProductoInventario_Categoria] FOREIGN KEY ([idCategoria]) REFERENCES [Categoria]([id]);
ALTER TABLE [ProductoInventario] ADD CONSTRAINT [FK_ProductoInventario_EstadoProducto] FOREIGN KEY ([idEstado]) REFERENCES [EstadoProducto]([id]);
ALTER TABLE [ProductoInventario] ADD CONSTRAINT [FK_ProductoInventario_Promocion] FOREIGN KEY ([idPromocion]) REFERENCES [Promocion]([id]);
ALTER TABLE [DetallePedido] ADD CONSTRAINT [FK_DetallePedido_Pedido] FOREIGN KEY ([idPedido]) REFERENCES [Pedido]([id]);
ALTER TABLE [DetallePedido] ADD CONSTRAINT [FK_DetallePedido_Producto] FOREIGN KEY ([idProductoProveedor]) REFERENCES [Producto]([id]);
ALTER TABLE [Pedido] ADD CONSTRAINT [FK_Pedido_EstadoPedido] FOREIGN KEY ([idEstadoPedido]) REFERENCES [EstadoPedido]([id]);
ALTER TABLE [Empleado] ADD CONSTRAINT [FK_Empleado_ProductoInventario] FOREIGN KEY ([idPuesto]) REFERENCES [Puesto]([id]);
ALTER TABLE [Merma] ADD CONSTRAINT [FK_Merma_ProductoInventario] FOREIGN KEY ([idProductoInventario]) REFERENCES [ProductoInventario]([id]);
ALTER TABLE [Venta] ADD CONSTRAINT [FK_Venta_Caja] FOREIGN KEY ([idCaja]) REFERENCES [Caja]([id]);
ALTER TABLE [Venta] ADD CONSTRAINT [FK_Venta_Monedero] FOREIGN KEY ([idMonedero]) REFERENCES [Monedero]([id]);
ALTER TABLE [Venta] ADD CONSTRAINT [FK_Venta_Empleado] FOREIGN KEY ([idEmpleado]) REFERENCES [Empleado]([id]);
ALTER TABLE [DetalleVenta] ADD CONSTRAINT [FK_DetalleVenta_Venta] FOREIGN KEY ([idVenta]) REFERENCES [Venta]([id]);
ALTER TABLE [DetalleVenta] ADD CONSTRAINT [FK_DetalleVenta_ProductoInventario] FOREIGN KEY ([idProductoInventario]) REFERENCES [ProductoInventario]([id]);
ALTER TABLE [Producto] ADD CONSTRAINT [FK_Producto_Proveedor] FOREIGN KEY ([idProveedor]) REFERENCES [Proveedor]([id]);
ALTER TABLE [Producto] ADD CONSTRAINT [FK_Producto_UnidadMedida] FOREIGN KEY ([idUnidadMedida]) REFERENCES [UnidadDeMedida]([id]);
ALTER TABLE [PromocionVigencia] ADD CONSTRAINT [FK_PromocionVigencia_Promocion] FOREIGN KEY ([idPromocion]) REFERENCES [Promocion]([id]);


-- 1. Crear el inicio de sesión para el usuario en el nivel del servidor
USE [master];
GO
CREATE LOGIN [SAMS.Data.Admin] 
WITH PASSWORD = 'nZrYF&jArpj%f6aBAtE#';
GO
-- 2. Crear el usuario en la base de datos SAMS.Data
USE [SAMS.Data];
GO
CREATE USER [SAMS.Data.Admin] 
FOR LOGIN [SAMS.Data.Admin];
GO
-- 3. Otorgar permisos de owner solo para la base de datos SAMS.Data
ALTER ROLE db_owner ADD MEMBER [SAMS.Data.Admin];
GO
-- 4. Cambiar al contexto de la base de datos msdb
USE [msdb];
GO
-- 5. Crear el usuario en la base de datos msdb
CREATE USER [SAMS.Data.Admin] 
FOR LOGIN [SAMS.Data.Admin];
GO
-- 6. Agregar el usuario al rol SQLAgentUserRole en msdb
EXEC sp_addrolemember 
    @rolename = N'SQLAgentUserRole', 
    @membername = N'SAMS.Data.Admin';  
GO

USE [SAMS.Data];
GO