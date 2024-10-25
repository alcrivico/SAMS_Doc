-- 1. index
CREATE INDEX I_ProductoInventario_Nombre ON ProductoInventario(nombre);
GO
CREATE INDEX I_ProductoInventario_Codigo ON ProductoInventario(codigo);
GO

-- 2. vistas
CREATE VIEW V_ProductoInventario AS
SELECT
    id,
    nombre,
    cantidadBodega, 
    cantidadExhibicion,
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

CREATE VIEW V_Promocion AS
SELECT
    p.nombre,
    p.porcentajeDescuento,
    pv.fechaInicio,
    pv.fechaFin
FROM
    Promocion p
INNER JOIN
    PromocionVigencia pv
    ON
    p.id = pv.idPromocion
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
        (e.nombre + ' ' + e.apellidoPaterno + ' ' + e.apellidoMaterno) AS nombre
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

-- procedimiento transaccional
CREATE PROCEDURE [dbo].T_CrearPromocionConVigencia
(
    @nombre NVARCHAR(100),
    @porcentajeDescuento INT,  -- Ajustado a INT
    @cantMaxima INT,
    @cantMinima INT,
    @fechaInicio DATE,
    @fechaFin DATE,
    @idProductoInventario INT
)
AS
BEGIN
    -- Iniciar la transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Insertar en la tabla Promocion
        DECLARE @idPromocion INT;

        INSERT INTO Promocion (nombre, porcentajeDescuento, cantMaxima, cantMinima)
        VALUES (@nombre, @porcentajeDescuento, @cantMaxima, @cantMinima);

        -- Obtener el ID de la promoción insertada
        SET @idPromocion = SCOPE_IDENTITY();

        -- 2. Insertar en la tabla PromocionVigencia
        INSERT INTO PromocionVigencia (fechaInicio, fechaFin, idPromocion)
        VALUES (@fechaInicio, @fechaFin, @idPromocion);

        -- 3. Actualizar la tabla ProductoInventario con el idPromocion
        UPDATE ProductoInventario
        SET idPromocion = @idPromocion
        WHERE id = @idProductoInventario;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;
        
        -- Mostrar el error
        THROW;
    END CATCH;
END;
GO