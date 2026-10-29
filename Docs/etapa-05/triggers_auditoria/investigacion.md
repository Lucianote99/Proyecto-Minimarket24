# Investigación y Justificación Técnica: Triggers de Auditoría en SQL Server

## Definición y Objetivo
Un **trigger** (disparador) es un objeto de base de datos que se ejecuta automáticamente ante eventos de manipulación de datos (`INSERT`, `UPDATE` o `DELETE`) sobre una tabla específica. Su objetivo principal en el sistema **Minimarket-24** es garantizar la **trazabilidad y seguridad**, registrando que datos cambiaron, cuándo ocurrieron los cambios y que usuario de base de datos ejecutó la acción.

## Ventajas y Aplicaciones
* **Trazabilidad y Seguridad:** Permite auditar alteraciones en datos críticos como precios de lista o stock físico.
* **Transparencia Operativa:** Funciona a nivel de motor SQL Server Express; no depende de la aplicación ni de la interfaz del usuario. Cualquier cambio directo queda registrado.
* **Control de Cumplimiento:** Permite prevenir o detectar errores administrativos y posibles fraudes.

## Implementación en SQL Server Express
SQL Server utiliza tablas virtuales temporales en memoria llamadas **`inserted`** (nuevos valores) y **`deleted`** (valores anteriores a la modificación). Mediante triggers `AFTER UPDATE`, se capturan ambos estados de la fila afectada y se guardan en tablas históricas de auditoría.

## Caso Concreto Aplicado al Minimarket-24 y Decisiones de Arquitectura

### A. Contexto del Dominio y Modelo Relacional
En el diseño relacional del **Minimarket-24**, la estructura de inventario se encuentra **normalizada**:
* La tabla `dbo.producto` almacena los datos descriptivos del catálogo y el `precio_actual`.
* La tabla `dbo.stock` almacena la `cantidad` física en depósito en una entidad independiente relacionada por `id_producto`.

### B. Análisis del Problema Técnico
Inicialmente se planteó incluir el stock dentro de la auditoría de productos mediante un `INNER JOIN` con la tabla `dbo.stock`. Sin embargo, durante las pruebas de integración surgieron dos limitaciones técnicas fundamentales:
1. **Ámbito de las tablas virtuales (`inserted` / `deleted`):** Las tablas `inserted` y `deleted` creadas por SQL Server durante la ejecución del trigger existen **única y exclusivamente para la tabla sobre la cual está declarado el trigger** (`dbo.producto`). No contienen los valores anteriores ni nuevos de la tabla `dbo.stock`.
2. **Independencia Transaccional:** Si se modifica el precio de un producto, la tabla `stock` no sufre ninguna actualización DML. Intentar capturar el stock desde `dbo.stock` en un trigger de `producto` provoca que los campos `stock_anterior` y `stock_nuevo` registren la misma foto actual, perdiendo el sentido histórico de la auditoría.

### C. Solución Adoptada (Desacoplamiento de Auditorías)
Se optó por una **arquitectura de auditoría desacoplada e independiente**, alineada a las buenas prácticas de bases de datos relacionales:
* **`auditoria_producto` / `trg_producto_auditoria`:** Registra exclusivamente las modificaciones sobre `dbo.producto` (audita el historial de cambios en `precio_actual`).
* **`auditoria_stock` / `trg_stock_auditoria`:** Registra exclusivamente las modificaciones sobre `dbo.stock` (audita los movimientos de `cantidad` por reabastecimientos o ventas).

Esta decisión garantiza independencia de entidades, integridad en la trazabilidad histórica de cada variable y optimización en el rendimiento de los triggers.
* **Solución implementada:** Se crea una tabla auxiliar `auditoria_producto` y un trigger `trg_producto_auditoria` que se dispara automáticamente cada vez que se actualiza la tabla `producto`, guardando el precio anterior, el precio nuevo, la fecha/hora exacta y el usuario responsable.
