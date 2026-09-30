## 1. Poblado Inicial de Datos (Script DML)

Para verificar el correcto funcionamiento de la estructura física y las relaciones creadas, se ejecutó un script de manipulación de datos (`datos_prueba.sql`) encargado de insertar registros coherentes y representativos (con un rango de 8 a 10 registros por tabla).

## 2. Validación de Restricciones en el SGBD

Durante las pruebas de inserción en el SGBD, se comprobaron con éxito los siguientes mecanismos de control:

1. **Rechazo de duplicados:** Intentar registrar un cliente con un DNI o email ya existente provocó el bloqueo automático por parte de las restricciones `UNIQUE`.
2. **Integridad referencial:** Se verificó que el sistema impide registrar una venta o un detalle asociado a un `id_cliente` o `id_producto` inexistente gracias a las reglas de `FOREIGN KEY`.
3. **Control de dominios:** Las pruebas con valores negativos en precios o cantidades fueron rechazadas de manera inmediata por las restricciones `CHECK`, garantizando que la base de datos mantenga registros limpios y listos para las consultas de las siguientes etapas.
