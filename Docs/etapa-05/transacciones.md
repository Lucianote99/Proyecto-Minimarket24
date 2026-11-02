# Tema: Manejo de Transacciones

### 1. Definición y objetivo
Una **transacción** es un grupo de operaciones de base de datos (como `INSERT`, `UPDATE` o `DELETE`) que se ejecutan juntas como si fueran una sola instrucción. 

El objetivo principal es aplicar la regla de **"todo o nada"** (Atomicidad). Esto significa que si una sola de las operaciones falla o no cumple una regla, todas las operaciones anteriores se deshacen automáticamente. Así garantizamos que la base de datos nunca quede con información a medias o corrupta.

### 2. Ventajas y aplicaciones
La mayor ventaja es proteger la integridad de los datos cuando un proceso afecta a múltiples tablas al mismo tiempo. 

En un sistema de ventas real, cobrar un carrito de compras implica insertar la venta, registrar los detalles y restar productos del inventario. Si no usáramos transacciones y el sistema fallara a la mitad, podríamos registrar un ingreso de dinero por un producto que nunca se restó del stock físico. Las transacciones evitan por completo estos errores.

### 3. Implementación en SQL Server Express
En SQL Server, las transacciones se manejan de forma manual utilizando tres comandos principales combinados con condicionales lógicos (`IF / ELSE`):

*   **`BEGIN TRANSACTION`**: Le avisa al motor que inicie un bloque de operaciones temporal (como un borrador).
*   **`COMMIT TRANSACTION`**: Si todo salió perfecto, este comando confirma la operación y guarda los datos de forma permanente en el disco duro.
*   **`ROLLBACK TRANSACTION`**: Si algo falla o no se cumple una validación, este comando funciona como un botón de pánico: cancela el borrador y deja las tablas exactamente como estaban antes de empezar.

### 4. Caso concreto aplicado a Minimarket 24
Aplicamos el manejo de transacciones a la operación de **Venta con control de stock**. 

Cuando un cajero intenta registrar una venta, la base de datos verifica primero si hay unidades suficientes en la tabla `stock`. 
*   **Si hay stock**: El sistema inserta la cabecera en la tabla `venta`, registra el ítem en `detalle_venta`, descuenta la cantidad en `stock` y finalmente ejecuta un `COMMIT` para guardar todo.
*   **Si no hay stock**: Se ejecuta un `ROLLBACK`. La venta se cancela, no se inserta ningún detalle y el stock queda intacto, demostrando la propiedad de atomicidad.
