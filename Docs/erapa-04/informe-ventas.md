

##Descripción del Caso
Este script genera un reporte agregado que permite evaluar el rendimiento comercial del personal, calculando la cantidad total de ventas concretadas y el 
monto recaudado por cada empleado durante un rango de fechas específico.

## Detalles del SQl (enntidades y funciones)
* **Tablas involucradas:** `empleado`, `venta`, `detalle_venta`.
* **Funciones de agregación utilizadas:** `COUNT()`, `SUM()`.
* **Filtros aplicados:** Rango de fechas (ej. mes de junio) y estado de venta (`'completada'`).

---

##Código SQL

```sql
-- ===============================================================
-- REPORTE AGREGADO: Ventas por Vendedor (Mes de Septiembre 2026)
-- ==============================================================
SELECT 
    e.id_empleado,
    e.nombre + ' ' + e.apellido AS [Vendedor],
    COUNT(v.id_venta) AS [Cantidad Total de Ventas],
    SUM(dv.cantidad * dv.precio_unitario) AS [Monto Total Recaudado]
FROM empleado e
JOIN venta v ON e.id_empleado = v.id_empleado
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
WHERE v.fecha_hora >= '2026-0*-01 00:00:00' 
  AND v.fecha_hora <= '2026-09-30 23:59:59'
  AND v.estado = 'completada'
GROUP BY e.id_empleado, e.nombre, e.apellido
ORDER BY [Monto Total Recaudado] DESC;
