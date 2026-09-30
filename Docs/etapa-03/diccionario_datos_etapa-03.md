# Diccionario de Datos - Etapa III

## 1. Tabla: cliente
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_cliente | INT | NOT NULL | PK | Identificador único y numérico asignado a cada cliente. |
| nombre | VARCHAR(50) | NOT NULL | - | Nombre de pila registrado del cliente. |
| apellido | VARCHAR(50) | NOT NULL | - | Apellido registrado del cliente. |
| dni | INT | NOT NULL | UNIQUE | Documento Nacional de Identidad; no puede repetirse. |
| telefono | VARCHAR(20) | NOT NULL | - | Número telefónico de contacto del cliente. |
| email | VARCHAR(100) | NULL | UNIQUE | Correo electrónico de contacto; opcional pero único. |

## 2. Tabla: empleado
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_empleado | INT | NOT NULL | PK | Identificador único del trabajador o empleado. |
| nombre | VARCHAR(50) | NOT NULL | - | Nombre de pila del empleado. |
| apellido | VARCHAR(50) | NOT NULL | - | Apellido del empleado. |
| dni | INT | NOT NULL | UNIQUE | Documento Nacional de Identidad del empleado. |

## 3. Tabla: venta
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_venta | INT | NOT NULL | PK | Identificador único de la transacción de venta. |
| fecha_hora | DATETIME | NOT NULL | - | Fecha y marca temporal exacta en que se efectuó la venta. |
| estado | VARCHAR(20) | NOT NULL | CHECK | Estado actual de la operación (completada, pendiente, cancelada). |
| id_cliente | INT | NOT NULL | FK | Referencia al identificador del cliente comprador. |
| id_empleado | INT | NOT NULL | FK | Referencia al identificador del empleado que atendió. |

## 4. Tabla: categoria
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_categoria | INT | NOT NULL | PK | Identificador único para la categoría de productos. |
| nombre | VARCHAR(50) | NOT NULL | UNIQUE | Nombre característico de la categoría. |
| descripcion | VARCHAR(150) | NULL | - | Breve detalle explicativo de los productos que agrupa. |

## 5. Tabla: producto
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_producto | INT | NOT NULL | PK | Identificador único del artículo comercializado. |
| codigo_barra | VARCHAR(50) | NOT NULL | UNIQUE | Código de barras numérico/alfanumérico único del producto. |
| nombre | VARCHAR(100) | NOT NULL | - | Nombre comercial del producto. |
| descripcion | VARCHAR(200) | NULL | - | Detalles técnicos o características del producto. |
| precio_actual | DECIMAL(10,2) | NOT NULL | CHECK | Precio vigente y actualizado del producto (mayor a cero). |
| id_categoria | INT | NOT NULL | FK | Referencia a la categoría a la cual pertenece el producto. |

## 6. Tabla: stock
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_stock | INT | NOT NULL | PK | Identificador único del registro de inventario. |
| cantidad | INT | NOT NULL | CHECK | Cantidad física disponible en depósito (mayor o igual a 0). |
| stock_minimo | INT | NOT NULL | CHECK | Límite mínimo de seguridad antes de realizar una reposición. |
| id_producto | INT | NOT NULL | FK | Referencia al producto al que le pertenece este stock. |

## 7. Tabla: detalle_venta
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| cantidad | INT | NOT NULL | CHECK | Cantidad de unidades de un producto específico vendidas. |
| precio_unitario | DECIMAL(10,2) | NOT NULL | CHECK | Precio histórico aplicado al producto al momento exacto de la venta. |
| id_venta | INT | NOT NULL | PK/FK | Referencia a la venta cabecera asociada. |
| id_producto | INT | NOT NULL | PK/FK | Referencia al producto incluido en el detalle. |

## 8. Tabla: metodo_pago
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_metodo_pago | INT | NOT NULL | PK | Identificador único del medio o método de pago. |
| nombre | VARCHAR(50) | NOT NULL | UNIQUE | Nombre descriptivo del medio de pago (efectivo, tarjeta, etc.). |

## 9. Tabla: pago
| Columna | Tipo de Dato | Nulabilidad | Restricción | Descripción detallada |
| :--- | :--- | :--- | :--- | :--- |
| id_pago | INT | NOT NULL | PK | Identificador único del comprobante o registro de pago. |
| importe | DECIMAL(10,2) | NOT NULL | CHECK | Monto total abonado en la transacción de pago. |
| fecha_hora | DATETIME | NOT NULL | - | Marca temporal exacta de cuándo se efectuó el pago. |
| id_venta | INT | NOT NULL | FK | Referencia a la venta que se está cancelando o abonando. |
| id_metodo_pago | INT | NOT NULL | FK | Referencia al método de pago utilizado. |
