IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SAMS.Data')
BEGIN
    CREATE DATABASE [SAMS.Data];
END
GO

USE [SAMS.Data];
GO

IF OBJECT_ID('Proveedor', 'U') IS NOT NULL DROP TABLE [Proveedor];
IF OBJECT_ID('Merma', 'U') IS NOT NULL DROP TABLE [Merma];
IF OBJECT_ID('Puesto', 'U') IS NOT NULL DROP TABLE [Puesto];
IF OBJECT_ID('Empleado', 'U') IS NOT NULL DROP TABLE [Empleado];
IF OBJECT_ID('Monedero', 'U') IS NOT NULL DROP TABLE [Monedero];
IF OBJECT_ID('Caja', 'U') IS NOT NULL DROP TABLE [Caja];
IF OBJECT_ID('UnidadDeMedida', 'U') IS NOT NULL DROP TABLE [UnidadDeMedida];
IF OBJECT_ID('Categoria', 'U') IS NOT NULL DROP TABLE [Categoria];
IF OBJECT_ID('Producto', 'U') IS NOT NULL DROP TABLE [Producto];
IF OBJECT_ID('EstadoPedido', 'U') IS NOT NULL DROP TABLE [EstadoPedido];
IF OBJECT_ID('Pedido', 'U') IS NOT NULL DROP TABLE [Pedido];
IF OBJECT_ID('Venta', 'U') IS NOT NULL DROP TABLE [Venta];
GO

CREATE TABLE [Proveedor] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RFC] VARCHAR(13) NOT NULL,
    [Nombre] VARCHAR(55) NOT NULL,
    [Correo] VARCHAR(55) NOT NULL,
    [Telefono] VARCHAR(10) NOT NULL
);
GO

CREATE TABLE [Merma] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Cantidad] INT NOT NULL,
    [Descripcion] VARCHAR(255) NULL,
    [FechaRegistro] DATE NOT NULL
);
GO

CREATE TABLE [Puesto] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Puesto] varchar(55) NOT NULL
);
GO

CREATE TABLE [Empleado] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RFC] VARCHAR(13) NOT NULL,
    [NoEmpleado] INT NOT NULL,
    [Nombre] VARCHAR(55) NOT NULL,
    [ApellidoPaterno] VARCHAR(55) NOT NULL,
    [ApellidoMaterno] VARCHAR(55) NULL,
    [Correo] VARCHAR(55) NOT NULL,
    [Password] VARCHAR(55) NOT NULL,
    [Telefono] VARCHAR(10) NOT NULL,
    [IdPuesto] INT NOT NULL,
    CONSTRAINT FK_Empleado_Puesto FOREIGN KEY ([IdPuesto]) REFERENCES [Puesto] ([Id])
);
GO

CREATE TABLE [Monedero] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CodigoDeBarras] INT NOT NULL,
    [Saldo] DOUBLE NOT NULL,
    [Nombre] VARCHAR(55) NOT NULL,
    [ApellidoPaterno] VARCHAR(55) NOT NULL,
    [ApellidoMaterno] VARCHAR(55) NOT NULL,
    [Telefono] VARCHAR(10) NOT NULL
);
GO

CREATE TABLE [Caja] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NoCaja] INT NOT NULL,
    [HoraDeCorte] DATETIME NOT NULL,
    [IdEmpleado] INT NULL,
    CONSTRAINT FK_Caja_Empleado FOREIGN KEY ([IdEmpleado]) REFERENCES [Caja] ([Id])
);
GO

CREATE TABLE [UnidadDeMedida] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UnidadDeMedida] VARCHAR(55) NOT NULL
);
GO

CREATE TABLE [Categoria] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Categoria] VARCHAR(55) NOT NULL
);
GO

CREATE TABLE [Categoria] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Categoria] VARCHAR(55) NOT NULL
);
GO

CREATE TABLE [Producto] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nombre] VARCHAR(55) NOT NULL,
    [Descripcion] VARCHAR(255) NULL,
    [Cantidad] INT NOT NULL,
    [Precio] DOUBLE NOT NULL,
    [FechaCaducidad] DATE NOT NULL,
    [EsPerecedero] BIT NOT NULL,
    [EsDevolvible] BIT NOT NULL,
    [Ubicacion] BIT NOT NULL,
    [IdUnidadDeMedida] INT NOT NULL,
    [IdCategoria] INT NOT NULL,
    CONSTRAINT FK_Producto_UnidadDeMedida FOREIGN KEY ([IdUnidadDeMedida]) REFERENCES [UnidadDeMedida] ([Id]),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY ([IdCategoria]) REFERENCES [Categoria] ([Id])
);
GO

CREATE TABLE [EstadoPedido] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Estado] VARCHAR(55) NOT NULL
);
GO

CREATE TABLE [Pedido] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NoPedido] INT NOT NULL,
    [FechaPedido] DATE NOT NULL,
    [FechaEntrega] DATE NOT NULL,
    [IdEstadoPedido] INT NOT NULL,
    CONSTRAINT FK_Pedido_EstadoPedido FOREIGN KEY ([IdEstadoPedido]) REFERENCES [EstadoPedido] ([Id])
);
GO

CREATE TABLE [Pedido_Producto] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdPedido] INT NOT NULL,
    [IdProducto] INT NOT NULL,
    CONSTRAINT FK_PedidoProducto_Pedido FOREIGN KEY ([IdPedido]) REFERENCES [Pedido] ([Id]),
    CONSTRAINT FK_PedidoProducto_Producto FOREIGN KEY ([IdProducto]) REFERENCES [Producto] ([Id])
);
GO

CREATE TABLE [Venta] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NoVenta] INT NOT NULL,
    [FechaRegistro] DATETIME NOT NULL,
    [IVA] DOUBLE NOT NULL,
    [Total] DOUBLE NOT NULL,
    CONSTRAINT FK_Pedido_EstadoPedido FOREIGN KEY ([IdEstadoPedido]) REFERENCES [EstadoPedido] ([Id])
);
GO

CREATE TABLE [Venta_Producto] (
    [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdVenta] INT NOT NULL,
    [IdProducto] INT NOT NULL,
    CONSTRAINT FK_VentaProducto_Venta FOREIGN KEY ([IdVenta]) REFERENCES [Venta] ([Id]),
    CONSTRAINT FK_VentaProducto_Producto FOREIGN KEY ([IdProducto]) REFERENCES [Producto] ([Id])
);
GO