-- ==============================================================================
-- Etapa IV - Caso de Uso 1: Factura / Comprobante de Venta
-- ==============================================================================
-- Consulta para generar el comprobante detallado de la venta número 1

SELECT 
    v.id_venta AS [Nro Factura],
    v.fecha_hora AS [Fecha y Hora],
    c.nombre + ' ' + c.apellido AS [Cliente],
    c.dni AS [DNI Cliente],
    e.nombre + ' ' + e.apellido AS [Empleado Atendió],
    p.nombre AS [Producto],
    dv.cantidad AS [Cantidad],
    dv.precio_unitario AS [Precio Unitario],
    (dv.cantidad * dv.precio_unitario) AS [Subtotal por Renglón],
    SUM(dv.cantidad * dv.precio_unitario) OVER(PARTITION BY v.id_venta) AS [Total Acumulado Venta]
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN empleado e ON v.id_empleado = e.id_empleado
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN producto p ON dv.id_producto = p.id_producto
WHERE v.id_venta = 1;
GO
