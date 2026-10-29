# Investigación: Triggers de Auditoría en SQL Server

## Definición y Objetivo
Un **trigger** (o disparador) es un objeto almacenado en la base de datos que se ejecuta de forma **automática** cuando ocurre una sentencia de manipulación de datos (`INSERT`, `UPDATE` o `DELETE`) sobre una tabla específica. 
Su objetivo principal en la **auditoría** es garantizar la trazabilidad registrando quién, cuándo y cómo se modificaron los datos críticos del sistema.

## Ventajas y Aplicaciones
* **Trazabilidad y Seguridad:** Permite responder con exactitud a preguntas críticas como: *¿Quién modificó el precio de un artículo?* o *¿Qué stock tenía antes de la corrección?*
* **Transparencia operativa:** Funciona a nivel de motor de base de datos, por lo que es independiente de la aplicación; cualquier cambio directo en la tabla queda registrado obligatoriamente.
* **Control de cumplimiento:** Es fundamental para auditorías financieras y de inventario en entornos comerciales como el **Minimarket-24**.

## Implementación en SQL Server Express
En SQL Server, los triggers de auditoría utilizan tablas virtuales temporales llamadas **`inserted`** (para almacenar los nuevos valores) y **`deleted`** (para almacenar los valores anteriores antes de la modificación). Mediante un trigger de tipo `AFTER UPDATE`, se capturan ambos estados y se persisten en una tabla de auditoría histórica.

## Caso Concreto Aplicado al Minimarket-24
* **Problema de negocio:** En el **Minimarket-24**, el administrador necesita controlar estrictamente cualquier modificación de precios o stock en el catálogo de productos para evitar errores humanos o fraudes internos.
* **Solución implementada:** Se crea una tabla auxiliar `auditoria_producto` y un trigger `trg_producto_auditoria` que se dispara automáticamente cada vez que se actualiza la tabla `producto`, guardando el precio anterior, el precio nuevo, la fecha/hora exacta y el usuario responsable.
