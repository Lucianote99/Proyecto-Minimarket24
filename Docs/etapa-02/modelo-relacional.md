# Modelo Relacional - Sistema Minimarket 24hs

A partir del Diagrama Entidad-Relación (DER), se derivó el esquema lógico relacional. Las Claves Primarias (PK) identifican de forma unívoca cada registro, y las Claves Foráneas (FK) establecen las relaciones garantizando la integridad referencial.

## Tablas del Sistema

- **CLIENTE** (`id_cliente` [PK], nombre, apellido, dni, telefono, email)
- **EMPLEADO** (`id_empleado` [PK], nombre, apellido, dni)
- **METODO_PAGO** (`id_metodo_pago` [PK], nombre)
- **CATEGORIA** (`id_categoria` [PK], nombre, descripcion)
- **VENTA** (`id_venta` [PK], fecha_hora, estado, `id_cliente` [FK, opcional], `id_empleado` [FK])
- **PAGO** (`id_pago` [PK], importe, fecha_hora, `id_venta` [FK], `id_metodo_pago` [FK])
- **PRODUCTO** (`id_producto` [PK], codigo_barra, descripcion, nombre, precio_actual, `id_categoria` [FK])
- **STOCK** (`id_stock` [PK], stock_minimo, cantidad, `id_producto` [FK])
- **DETALLE_VENTA** (`id_venta` [PK/FK], `id_producto` [PK/FK], cantidad, precio_unitario)
  *Nota: La clave primaria de esta tabla es compuesta, formada por las claves foráneas provenientes de Venta y Producto.*
