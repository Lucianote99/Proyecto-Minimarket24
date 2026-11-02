-- =========================================================================
-- DEMOSTRACIÓN DE TRANSACCIONES: Venta con control de stock
-- Proyecto Etapa V - minimarket_24
-- =========================================================================

-- 1. VARIABLES DE ENTRADA (Simulan los datos ingresados en el sistema)
DECLARE @id_venta_nueva INT = 1;
DECLARE @id_cliente INT = 1;
DECLARE @id_empleado INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @cantidad_venta INT = 5;

-- 2. VARIABLES DE TRABAJO (Almacenan la info actual de la base de datos)
DECLARE @stock_actual INT;
DECLARE @precio_unitario DECIMAL(10,2);

-- 3. OBTENER DATOS ACTUALES
-- Se busca el precio de venta actual del producto
SELECT @precio_unitario = precio_actual 
FROM producto 
WHERE id_producto = @id_producto;

-- Se busca el stock disponible en la góndola
SELECT @stock_actual = cantidad 
FROM stock 
WHERE id_producto = @id_producto;

-- =========================================================================
-- INICIO DE LA TRANSACCIÓN
-- =========================================================================
BEGIN TRANSACTION;

-- 4. VALIDACIÓN DE REGLA DE NEGOCIO
IF @stock_actual < @cantidad_venta
BEGIN
    -- Si no hay stock suficiente, aborta la operación completa
    PRINT 'ERROR: Stock insuficiente. Operación cancelada.';
    ROLLBACK TRANSACTION; 
END
ELSE
BEGIN
    -- Si hay stock, procede con las inserciones y actualizaciones
    
    -- A. Insertar cabecera de la venta
    INSERT INTO venta (id_venta, fecha_hora, estado, id_cliente, id_empleado)
    VALUES (@id_venta_nueva, GETDATE(), 'completada', @id_cliente, @id_empleado);

    -- B. Insertar detalle de la venta
    INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto)
    VALUES (@cantidad_venta, @precio_unitario, @id_venta_nueva, @id_producto);

    -- C. Descontar las unidades vendidas del stock
    UPDATE stock
    SET cantidad = cantidad - @cantidad_venta
    WHERE id_producto = @id_producto;

    PRINT 'ÉXITO: Venta registrada, detalle guardado y stock actualizado.';
    
    -- Confirmar y guardar permanentemente los cambios
    COMMIT TRANSACTION; 
END
