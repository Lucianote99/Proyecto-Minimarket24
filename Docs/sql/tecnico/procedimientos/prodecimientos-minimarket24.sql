USE minimarket_24;
GO
-- =========================================================================
-- PARTE 2: IMPLEMENTACIÓN DEL PROCEDIMIENTO ALMACENADO
-- =========================================================================


CREATE PROCEDURE dbo.sp_RegistrarVentaCompleta
    @id_cliente INT,
    @id_empleado INT,
    @id_producto INT,
    @cantidad INT,
    @id_metodo_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validar que la cantidad solicitada sea positiva
    IF @cantidad <= 0
    BEGIN
        RAISERROR('Error: La cantidad a vender debe ser mayor a cero.', 16, 1);
        RETURN;
    END;

    -- 2. Validar existencia de stock utilizando nuestra función
    IF dbo.fn_StockDisponible(@id_producto) < @cantidad
    BEGIN
        RAISERROR('Stock insuficiente para realizar la venta solicitada.', 16, 1);
        RETURN;
    END;

    -- Variables para cálculos internos
    DECLARE @nuevo_id_venta INT;
    DECLARE @nuevo_id_pago INT;
    DECLARE @precio_actual DECIMAL(10,2);
    DECLARE @descuento_porc DECIMAL(5,2);
    DECLARE @importe_final DECIMAL(10,2);

    -- 3. Obtener el precio actual del producto desde la tabla producto
    SELECT @precio_actual = precio_actual
    FROM dbo.producto
    WHERE id_producto = @id_producto;

    IF @precio_actual IS NULL
    BEGIN
        RAISERROR('Error: El producto indicado no existe.', 16, 1);
        RETURN;
    END;

    -- 4. Calcular IDs correlativos (ya que las tablas no usan IDENTITY)
    SELECT @nuevo_id_venta = ISNULL(MAX(id_venta), 0) + 1 FROM dbo.venta;
    SELECT @nuevo_id_pago  = ISNULL(MAX(id_pago), 0) + 1 FROM dbo.pago;

    -- 5. Calcular el importe final aplicando el descuento del cliente
    SET @descuento_porc = dbo.fn_CalcularDescuentoCliente(@id_cliente);
    SET @importe_final  = (@cantidad * @precio_actual) * (1.00 - (@descuento_porc / 100.00));

    -- 6. Insertar encabezado de la venta (fecha_hora toma DEFAULT GETDATE())
    INSERT INTO dbo.venta (id_venta, estado, id_cliente, id_empleado)
    VALUES (@nuevo_id_venta, 'completada', @id_cliente, @id_empleado);

    -- 7. Insertar detalle de la venta
    INSERT INTO dbo.detalle_venta (cantidad, precio_unitario, id_venta, id_producto)
    VALUES (@cantidad, @precio_actual, @nuevo_id_venta, @id_producto);

    -- 8. Descontar las unidades en la tabla stock
    UPDATE dbo.stock
    SET cantidad = cantidad - @cantidad
    WHERE id_producto = @id_producto;

    -- 9. Registrar el pago correspondiente
    INSERT INTO dbo.pago (id_pago, importe, id_venta, id_metodo_pago)
    VALUES (@nuevo_id_pago, @importe_final, @nuevo_id_venta, @id_metodo_pago);

    -- 10. Devolver resumen de la operación para evidencia
    SELECT 
        @nuevo_id_venta AS IdVentaGenerada,
        @id_cliente AS IdCliente,
        @id_producto AS IdProducto,
        @cantidad AS CantidadVendida,
        @precio_actual AS PrecioUnitario,
        @descuento_porc AS DescuentoAplicadoPorc,
        @importe_final AS ImporteFinalCobrado,
        dbo.fn_StockDisponible(@id_producto) AS StockRestante;
END;
GO
