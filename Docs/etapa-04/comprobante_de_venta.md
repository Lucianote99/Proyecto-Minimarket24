Caso de Uso 1: Factura / Comprobante de Venta
Descripción
Este caso de uso permite generar la estructura de una factura o comprobante comercial para una venta en particular dentro del minimarket. Consolida los datos del encabezado (cliente, empleado, fecha, número de venta) con el detalle de los productos adquiridos, calculando automáticamente el subtotal por cada línea y el total general de la operación.

Tablas Involucradas
venta: Datos generales de la transacción (ID, fecha, estado).
cliente: Datos de identificación y contacto del comprador.
empleado: Datos del cajero o vendedor que registró la operación.
detalle_venta: Renglones asociados a la venta con cantidades y precios unitarios.
producto: Nombre y descripción de los artículos vendidos.
Script SQL
-- Consulta para generar el comprobante de la venta número 1
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
