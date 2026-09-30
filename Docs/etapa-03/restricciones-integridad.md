Para garantizar la integridad de los datos y cumplir con las reglas de negocio del minimercado, se implementaron explícitamente restricciones de tipo `CONSTRAINT` dentro de los scripts DDL:

### Claves Primarias (PRIMARY KEY)
Se estableció una clave primaria única para cada tabla con el fin de asegurar la unicidad e identificación unívoca de los registros.
* **Ejemplos:** `CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)`, `CONSTRAINT pk_venta PRIMARY KEY (id_venta)`.

### Claves Foráneas e Integridad Referencial (FOREIGN KEY)
Se vincularon lógicamente las tablas dependientes utilizando nombres explícitos en las restricciones para asegurar las relaciones del negocio.
* **Ejemplos:** `CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)`, `CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)`.

### Restricciones de Unicidad y Validación (UNIQUE y CHECK)
* **Unicidad (UNIQUE):** Aplicada en campos que no pueden repetirse entre registros, tales como el DNI (`uk_cliente_dni`), el correo electrónico (`uk_cliente_email`) o el código de barras del producto (`uk_producto_codigo_barra`).
* **Validación de rangos (CHECK):** Utilizadas para restringir valores lógicos, por ejemplo, asegurando que los precios y montos sean mayores a cero (`chk_producto_precio`, `chk_pago_importe`), que los stocks no sean negativos (`chk_stock_cantidad`), o limitando los estados válidos de una venta (`chk_venta_estado`).
