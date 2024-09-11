IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SAMS.Data')
BEGIN
    CREATE DATABASE [SAMS.Data];
END
GO

USE [SAMS.Data];
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UnidadDeMedida]') AND type in (N'U'))
BEGIN
    CREATE TABLE [UnidadDeMedida] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [UnidadDeMedida] VARCHAR(55) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Categoria]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Categoria] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Categoria] VARCHAR(55) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Producto]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Producto] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Nombre] VARCHAR(55) NOT NULL,
        [Descripcion] VARCHAR(255) NULL,
        [Cantidad] INT NOT NULL,
        [Precio] FLOAT NOT NULL,
        [FechaCaducidad] DATE NOT NULL,
        [EsPerecedero] BIT NOT NULL,
        [EsDevolvible] BIT NOT NULL,
        [Ubicacion] BIT NOT NULL,
        [IdUnidadDeMedida] INT NOT NULL,
        [IdCategoria] INT NOT NULL,
        CONSTRAINT FK_Producto_UnidadDeMedida FOREIGN KEY ([IdUnidadDeMedida]) REFERENCES [UnidadDeMedida] ([Id]),
        CONSTRAINT FK_Producto_Categoria FOREIGN KEY ([IdCategoria]) REFERENCES [Categoria] ([Id])
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EstadoPedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [EstadoPedido] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Estado] VARCHAR(55) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Proveedor]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Proveedor] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RFC] VARCHAR(13) NOT NULL,
        [Nombre] VARCHAR(55) NOT NULL,
        [Correo] VARCHAR(55) NOT NULL,
        [Telefono] VARCHAR(10) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Pedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Pedido] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [NoPedido] INT NOT NULL,
        [FechaPedido] DATE NOT NULL,
        [FechaEntrega] DATE NOT NULL,
        [IdEstadoPedido] INT NOT NULL,
        [IdProveedor] INT NOT NULL, 
        CONSTRAINT FK_Pedido_EstadoPedido FOREIGN KEY ([IdEstadoPedido]) REFERENCES [EstadoPedido] ([Id]),
        CONSTRAINT FK_Pedido_Proveedor FOREIGN KEY ([IdProveedor]) REFERENCES [Proveedor] ([Id])
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Pedido_Producto]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Pedido_Producto] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [IdPedido] INT NOT NULL,
        [IdProducto] INT NOT NULL,
        CONSTRAINT FK_PedidoProducto_Pedido FOREIGN KEY ([IdPedido]) REFERENCES [Pedido] ([Id]),
        CONSTRAINT FK_PedidoProducto_Producto FOREIGN KEY ([IdProducto]) REFERENCES [Producto] ([Id])
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Venta]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Venta] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [NoVenta] INT NOT NULL,
        [FechaRegistro] DATETIME NOT NULL,
        [IVA] FLOAT NOT NULL,
        [Total] FLOAT NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Venta_Producto]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Venta_Producto] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [IdVenta] INT NOT NULL,
        [IdProducto] INT NOT NULL,
        CONSTRAINT FK_VentaProducto_Venta FOREIGN KEY ([IdVenta]) REFERENCES [Venta] ([Id]),
        CONSTRAINT FK_VentaProducto_Producto FOREIGN KEY ([IdProducto]) REFERENCES [Producto] ([Id])
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Merma]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Merma] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Cantidad] INT NOT NULL,
        [Descripcion] VARCHAR(255) NULL,
        [FechaRegistro] DATE NOT NULL,
        [IdProducto] INT NOT NULL,
        CONSTRAINT FK_Merma_Producto FOREIGN KEY ([IdProducto]) REFERENCES [Producto] ([Id])
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Puesto]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Puesto] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Puesto] varchar(55) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Empleado]') AND type in (N'U'))
BEGIN
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
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Caja]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Caja] (
        [Id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [NoCaja] INT NOT NULL,
        [HoraDeCorte] DATETIME NOT NULL,
        [IdEmpleado] INT NULL,
        CONSTRAINT FK_Caja_Empleado FOREIGN KEY ([IdEmpleado]) REFERENCES [Empleado] ([Id])
    );
END
GO