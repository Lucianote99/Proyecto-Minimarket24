USE minimarket_24;
GO

-- =========================================================================
-- PARTE 1: IMPLEMENTACIÓN DE FUNCIONES ALMACENADAS
-- =========================================================================



-- 1.1 Función Escalar: Consultar stock disponible de un producto
CREATE FUNCTION dbo.fn_StockDisponible (@id_producto INT)
RETURNS INT
AS
BEGIN
    DECLARE @stock_actual INT;

    SELECT @stock_actual = cantidad
    FROM dbo.stock
    WHERE id_producto = @id_producto;

    -- Si el producto no tiene registro en stock, devuelve 0
    RETURN ISNULL(@stock_actual, 0);
END;
GO



-- 1.2 Función Escalar: Calcular porcentaje de descuento según compras acumuladas
CREATE FUNCTION dbo.fn_CalcularDescuentoCliente (@id_cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_acumulado DECIMAL(10,2);
    DECLARE @porcentaje_descuento DECIMAL(5,2);

    -- Sumamos cantidad * precio_unitario de todas las ventas 'completada' del cliente
    SELECT @total_acumulado = ISNULL(SUM(dv.cantidad * dv.precio_unitario), 0)
    FROM dbo.venta v
    INNER JOIN dbo.detalle_venta dv ON v.id_venta = dv.id_venta
    WHERE v.id_cliente = @id_cliente
      AND v.estado = 'completada';

    -- Regla de negocio escalada al volumen de tickets del Minimarket 24hs
    IF @total_acumulado >= 5000.00
        SET @porcentaje_descuento = 10.00; -- 10% de descuento
    ELSE IF @total_acumulado >= 2000.00
        SET @porcentaje_descuento = 5.00;  -- 5% de descuento
    ELSE
        SET @porcentaje_descuento = 0.00;  -- Sin descuento

    RETURN @porcentaje_descuento;
END;
GO

