# Etapa IV: Consultas y Casos de Uso - Minimarket-24

Este documento detalla la implementación y el funcionamiento de la consulta de negocio avanzada desarrollada para la cuarta etapa del proyecto.

## Consulta de Negocio Avanzada

### Objetivo
Obtener un listado de aquellos productos cuyas unidades totales vendidas superen el promedio general de ventas de todos los productos registrados en el sistema, considerando exclusivamente las transacciones completadas.

### Código SQL
```sql
    SELECT 
    p.id_producto,
    p.nombre AS nombre_producto,
    SUM(dv.cantidad) AS total_unidades_vendidas
FROM 
    producto p
INNER JOIN -- 1ra tabla con 2da tabla
    detalle_venta dv ON p.id_producto = dv.id_producto
INNER JOIN -- 2da tabla con 3ra tabla 
    venta v ON dv.id_venta = v.id_venta
WHERE 
    v.estado = 'completada' -- Solo ventas reales
GROUP BY -- Requerido para agrupar las sumas
    p.id_producto, 
    p.nombre
HAVING -- Filtro condicional sobre el grupo
    SUM(dv.cantidad) > (
        -- Subconsulta que calcula el promedio general de ventas por producto
        SELECT AVG(sub.total_prod)
        FROM (
            SELECT SUM(dv2.cantidad) AS total_prod
            FROM detalle_venta dv2
            INNER JOIN venta v2 ON dv2.id_venta = v2.id_venta
            WHERE v2.estado = 'completada'
            GROUP BY dv2.id_producto
        ) AS sub
    );
