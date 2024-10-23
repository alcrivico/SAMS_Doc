-- 1. index
CREATE INDEX I_ProductoInventario_Nombre ON ProductoInventario(nombre);
GO
CREATE INDEX I_ProductoInventario_Codigo ON ProductoInventario(codigo);
GO

-- 2. vistas
CREATE VIEW V_ProductoInventario AS
SELECT 
    nombre,
    cantidad,
    precioActual,
    ubicacion
FROM 
    ProductoInventario
GO
CREATE VIEW V_Pedido AS
SELECT 
    pr.nombre,
    p.NoPedido,
    p.FechaPedido,
    p.FechaEntrega
FROM
    Pedido p
INNER JOIN
    DetallePedido dp 
    ON
    p.id = dp.idPedido
INNER JOIN
    Producto pr
    ON
    dp.idProductoProveedor = pr.id
GO

-- 3. procedimientos almacenados
-- funciones listas
CREATE FUNCTION [dbo].FL_TotalDetallesVenta (
    @idVenta INT
)
RETURNS decimal(8,2)
AS
BEGIN
    DECLARE @total decimal(8,2);

    SELECT 
        @total = SUM(cantidad * precioVenta)
    FROM
        DetalleVenta db
    WHERE
        idVenta = @idVenta;

    RETURN ISNULL(@total, 0);
END;
GO

-- funciones escalares

-- procedimientos almacenados
CREATE PROCEDURE [dbo].SP_ReporteVenta
AS
BEGIN
    --Tabla temporal
    CREATE TABLE #TempVentas (
        noVenta INTEGER,
        fechaRegistro DATETIME,
        total DECIMAL(8, 2),
        noCaja VARCHAR(255),
        nombre NVARCHAR(100)
    );

    INSERT INTO #TempVentas (noVenta, fechaRegistro, total, noCaja, nombre)
    SELECT
        v.noVenta,
        v.fechaRegistro,
        dbo.FL_TotalDetallesVenta(v.id) AS total,
        c.noCaja,
        (e.nombre + ' ' + e.apellidoPaterno) AS nombre
    FROM 
        Venta v
    INNER JOIN 
        Empleado e ON e.id = v.idEmpleado
    INNER JOIN 
        Caja c ON c.id = v.idCaja;

    --resultado
    SELECT 
        noVenta,
        fechaRegistro,
        total,
        noCaja,
        nombre
    FROM 
        #TempVentas
    WHERE 
        total > 0
    ORDER BY
        noCaja;

    DROP TABLE #TempVentas;
END;
GO