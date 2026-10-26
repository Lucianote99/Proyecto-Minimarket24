# 1. Procedimientos y Funciones Almacenadas

## Definición y Objetivo
* **Procedimientos Almacenados (`Stored Procedures`):** Son bloques precompilados de instrucciones T-SQL almacenados en el motor 
de base de datos que permiten ejecutar secuencias complejas de operaciones (inserciones, actualizaciones, validaciones y
control de flujo) invocándolos mediante un nombre y parámetros.
* **Funciones Definidas por el Usuario (`User-Defined Functions`):** Son rutinas que encapsulan lógica de cálculo o consulta, reciben parámetros de entrada y
* retornan obligatoriamente un valor escalar o una tabla, sin modificar el estado de la base de datos.

**Objetivo:** Centralizar la lógica de negocio dentro del motor SQL Server para garantizar que todas las operaciones del sistema respeten las mismas validaciones, mejorando
el rendimiento, la seguridad y la mantenibilidad.

## Ventajas y Aplicaciones en el Minimarket 24hs
1. **Modularidad y Reutilización:** Cálculos frecuentes como verificar existencias en góndola (`fn_StockDisponible`) o determinar beneficios por
2. fidelidad (`fn_CalcularDescuentoCliente`) se programan una única vez y se reutilizan en consultas, reportes y procedimientos.
3. **Integridad Operativa en Caja:** Registrar una venta en un minimarket requiere impactar
4. cuatro tablas (`venta`, `detalle_venta`, `stock` y `pago`). El procedimiento `sp_RegistrarVentaCompleta` unifica estos pasos evitando que un error humano deje ventas
5. sin detalle o sin descuento de inventario.
6. **Seguridad y Mantenimiento:** Los cajeros no necesitan permisos directos de `INSERT` o `UPDATE` sobre las tablas críticas;
7. solo requieren permiso de ejecución (`EXECUTE`) sobre el procedimiento.

## Caso Concreto Aplicado al Sistema (`minimarket_24`)
* **`dbo.fn_StockDisponible(@id_producto)`:** Consulta la tabla `stock` y retorna las unidades disponibles de un artículo específico.
* **`dbo.fn_CalcularDescuentoCliente(@id_cliente)`:** Analiza el historial de compras con estado `'completada'` del cliente
* uniéndolas con `detalle_venta`. Otorga un **10%** de descuento si supera los $5.000 acumulados, **5%** si alcanza o supera los $2.000, y **0%** en caso contrario.
* **`dbo.sp_RegistrarVentaCompleta`:** Valida el stock disponible; si es suficiente, genera automáticamente los identificadores
*  correlativos, inserta la cabecera en `venta`, registra el renglón en `detalle_venta` congelando el precio histórico de `producto`, descuenta las unidades
*  en `stock` y asienta el cobro final (con descuento aplicado) en la tabla `pago`.
