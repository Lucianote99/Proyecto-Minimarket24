# Proceso de Normalización y Evolución del Modelo

A continuación se detalla la documentación paso a paso de la evolución del modelo relacional, aplicando las reglas de normalización sobre el diseño propuesto:

**1FN: Eliminación de grupos repetitivos y garantía de atomicidad.**
Analizando el diseño inicial, se verificó que los atributos planteados ya cumplen con la atomicidad (no hay campos multivaluados). 
Para asegurar la eliminación de grupos repetitivos de forma estructural, se determinó que la tabla débil `DETALLE_VENTA` debe tener una clave primaria compuesta por `(id_venta, id_producto)`. 
Esto garantiza que no se repitan los mismos productos en un mismo ticket.

**2FN: Eliminación de dependencias funcionales parciales en claves compuestas.**
El análisis se centró en `DETALLE_VENTA`, por ser la única tabla del modelo con clave primaria compuesta. 
Se verificó que los atributos no clave (`cantidad` y `precio_unitario`) dependen funcionalmente de la totalidad de la clave.
Ninguno de estos atributos depende de forma parcial (solo de la venta o solo del producto), asegurando el cumplimiento de la 2FN.

**3FN: Eliminación de dependencias transitivas en atributos no clave.**
Se evaluó que los atributos no clave dependan directamente de sus respectivas claves primarias. 
Durante este paso, detectamos un caso particular en la tabla `STOCK`: los atributos `cantidad` y `stock_minimo` dependen funcionalmente del `id_producto` (clave foránea) y no de su propia clave principal `id_stock`.
Esto representa una dependencia transitiva que documentamos en esta evolución. 
Por otro lado, validamos que el `precio_unitario` en el detalle no es una dependencia transitiva del catálogo de productos, sino una dependencia directa de la transacción para mantener el historial.
