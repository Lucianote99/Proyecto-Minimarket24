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
```
---
### Explicación Detallada Línea por Línea

#### Bloque 1: Proyección de Columnas (`SELECT`)
`SELECT`: Define cuáles serán las columnas finales del reporte que devolverá la consulta.

`p.id_producto`: Selecciona la clave primaria de la tabla `producto` (utilizando el alias `p`). Garantiza que el informe identifique unívocamente a cada artículo sin ambigüedades.

`p.nombre AS nombre_producto`: Recupera la descripción comercial del producto y le asigna el alias descriptivo `nombre_producto` para mejorar la legibilidad de la cabecera del resultado.

`SUM(dv.cantidad) AS total_unidades_vendidas`: Aplica la función de agregación `SUM` sobre la columna `cantidad` de la tabla `detalle_venta` (`dv`). Suma todas las unidades comercializadas de cada producto individual en el histórico de ventas y asigna el alias `total_unidades_vendidas`.

#### Bloque 2: Origen de Datos y Combinación de Tablas (`FROM` / `JOIN`)
`FROM producto p`: Define la tabla principal del catálogo (`producto`) asignándole el alias de tabla p para simplificar la escritura del código.

`INNER JOIN detalle_venta dv ON p.id_producto = dv.id_producto`: Realiza una combinación interna entre `producto` (`p`) y `detalle_venta` (`dv`). La condición `ON` vincula la clave primaria `id_producto` del catálogo con la clave foránea `id_producto` de las líneas del comprobante, descartando productos que nunca hayan sido vendidos.

`INNER JOIN venta v ON dv.id_venta = v.id_venta`: Realiza una segunda combinación interna conectando el detalle (`dv`) con la cabecera de la venta (`venta v`) a través de la clave común `id_venta`. Esto permite vincular **3 tablas clave del modelo** y acceder a los atributos de estado y fecha de la transacción.

#### Bloque 3: Filtrado de Registros por Integridad (`WHERE`)
`WHERE v.estado = 'completada'`: Filtra las filas a nivel de registro antes de realizar cualquier agrupación de datos. Garantiza que solo se tomen en cuenta los renglones asociados a comprobantes con estado `'completada'`, evitando que ventas canceladas o devueltas distorsionen los totales.

#### Bloque 4: Agrupamiento de Métricas (`GROUP BY`)
`GROUP BY p.id_producto, p.nombre`: Colapsa y agrupa todas las filas individuales de los detalles de venta en un único registro por cada producto.

Justificación del estándar SQL ANSI: Toda columna presente en la cláusula `SELECT` que no esté contenida dentro de una función de agregación (en este caso, `p.id_producto` y `p.nombre`) **debe figurar de manera obligatoria** en el `GROUP BY`.

#### Bloque 5: Filtro Condicional sobre Agrupamientos y Subconsulta Dinámica (`HAVING`)
`HAVING SUM(dv.cantidad) >`: Aplica una condición de filtrado **posterior al agrupamiento**. Evalúa si la suma total de unidades vendidas de un producto es estrictamente mayor que el límite calculated por la subconsulta anidada. Se utiliza `HAVING` y no `WHERE` debido a que la condición opera sobre el resultado acumulado de la función `SUM()`.

### Análisis de la Subconsulta Interna (Tabla Derivada `sub`):
`SELECT SUM(dv2.cantidad) AS total_prod ... GROUP BY dv2.id_producto`: Esta consulta interna calcula de forma independiente la suma total de unidades vendidas para cada producto del sistema (usando los alias secundarios `dv2` y `v2` para no interferir con la consulta externa).

`) AS sub`: Encapsula el conjunto de sumas parciales asignándole el alias de tabla derivada `sub`.

`SELECT AVG(sub.total_prod) FROM (...)`: Aplica la función de agregación promedio (`AVG`) sobre el conjunto de totales generados por la tabla derivada. Retorna un único valor escalar que representa la media matemática de unidades vendidas por producto en el minimarket.

--- 

## Flujo de Ejecución Lógica del Motor SQL Server
Para comprender la eficiencia y el comportamiento interno del motor de la base de datos, las cláusulas de esta consulta se evalúan en el siguiente orden estricto:

`FROM` & `INNER JOIN`: Se construye el producto cartesiano filtrado entre `producto`, `detalle_venta` y `venta`.

`WHERE`: Se filtran únicamente los registros cuyo estado de venta sea `'completada'`.

`GROUP BY`: Se organizan los registros restantes en grupos formados por cada par `(id_producto, nombre)`.

`Subconsulta (HAVING)`: El motor ejecuta la consulta anidada para determinar dinámicamente la constante del promedio general.

`HAVING`: Se evalúa la condición `SUM(cantidad) > Promedio`, descartando los grupos de productos que no alcanzan dicha media.

`SELECT`: Se proyectan las columnas finales `id_producto`, `nombre_producto` y `total_unidades_vendidas`.
