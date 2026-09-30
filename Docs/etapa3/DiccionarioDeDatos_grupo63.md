# Diccionario de Datos — Minimarket-24 (Etapa III)

---

## 1. Tabla: `CLIENTE`
**Descripción:** Almacena los datos personales de los clientes registrados para fidelización o facturación nominal.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_cliente` | `INT` | `PK` | No | Identificador único del cliente. |
| `nombre` | `VARCHAR(50)` | - | No | Nombre del cliente. |
| `apellido` | `VARCHAR(50)` | - | No | Apellido del cliente. |
| `dni` | `VARCHAR(15)` | - | No | Documento de identidad (Único). |
| `telefono` | `VARCHAR(20)` | - | Sí | Número de contacto. |
| `email` | `VARCHAR(100)` | - | Sí | Correo electrónico. |

---

## 2. Tabla: `EMPLEADO`
**Descripción:** Registro del personal autorizado para operar la caja y realizar cobros.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_empleado` | `INT` | `PK` | No | Identificador único del empleado. |
| `nombre` | `VARCHAR(50)` | - | No | Nombre del empleado. |
| `apellido` | `VARCHAR(50)` | - | No | Apellido del empleado. |
| `dni` | `VARCHAR(15)` | - | No | Documento de identidad. |

---

## 3. Tabla: `CATEGORIA`
**Descripción:** Clasificación general de los productos en el catálogo.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_categoria` | `INT` | `PK` | No | Identificador único de la categoría. |
| `nombre` | `VARCHAR(50)` | - | No | Nombre de la categoría (ej. Bebidas, Almacén). |
| `descripcion` | `VARCHAR(255)` | - | Sí | Detalle sobre los artículos comprendidos. |

---

## 4. Tabla: `PRODUCTO`
**Descripción:** Catálogo maestro de artículos disponibles para la venta.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_producto` | `INT` | `PK` | No | Identificador único del producto. |
| `codigo_barra` | `VARCHAR(50)` | - | No | Código EAN/UPC escaneable. |
| `nombre` | `VARCHAR(100)` | - | No | Nombre comercial del artículo. |
| `descripcion` | `VARCHAR(255)` | - | Sí | Descripción detallada del artículo. |
| `precio_actual` | `DECIMAL(10,2)` | - | No | Precio de lista vigente en catálogo. |
| `id_categoria` | `INT` | `FK` | No | Referencia a `CATEGORIA.id_categoria`. |

---

## 5. Tabla: `STOCK`
**Descripción:** Control de existencias físicas en tiempo real para cada producto.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_stock` | `INT` | `PK` | No | Identificador del registro de stock. |
| `cantidad` | `INT` | - | No | Existencias disponibles. **RN-2** |
| `stock_minimo` | `INT` | - | No | Umbral mínimo para reorden de mercadería. |
| `id_producto` | `INT` | `FK` | No | Referencia a `PRODUCTO.id_producto` (Relación 1:1). |

---

## 6. Tabla: `VENTA`
**Descripción:** Registro de cabecera de las transacciones comerciales realizadas.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_venta` | `INT` | `PK` | No | Identificador único autoincremental. |
| `fecha_hora` | `DATETIME` | - | No | Momento exacto del cobro. |
| `estado` | `VARCHAR(20)` | - | No | Estado del comprobante ('Emitida', 'Anulada'). **RN-6** |
| `id_cliente` | `INT` | `FK` | Sí | Referencia a `CLIENTE.id_cliente` (`NULL` si no pide factura). **RN-3** |
| `id_empleado` | `INT` | `FK` | No | Referencia a `EMPLEADO.id_empleado`. **RN-5** |

---

## 7. Tabla: `DETALLE_VENTA`
**Descripción:** Desglose de ítems comprados en cada ticket (entidad intermedia N:M).

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_venta` | `INT` | `PK` / `FK` | No | Referencia a `VENTA.id_venta`. |
| `id_producto` | `INT` | `PK` / `FK` | No | Referencia a `PRODUCTO.id_producto`. |
| `cantidad` | `INT` | - | No | Unidades vendidas ($>0$). |
| `precio_unitario` | `DECIMAL(10,2)` | - | No | Precio histórico congelado al momento del cobro. **RN-1** |

---

## 8. Tabla: `METODO_PAGO`
**Descripción:** Catálogo con las formas oficiales de cobro aceptadas por el local.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_metodo_pago` | `INT` | `PK` | No | Identificador único del método de pago. |
| `nombre` | `VARCHAR(50)` | - | No | Nombre del medio (Efectivo, Tarjeta, Billetera Virtual). **RN-4** |

---

## 9. Tabla: `PAGO`
**Descripción:** Almacena las transacciones monetarias asociadas a cada venta.

| Campo | Tipo de Dato | Clave | Nulo | Descripción / Regla de Negocio |
| :--- | :--- | :---: | :---: | :--- |
| `id_pago` | `INT` | `PK` | No | Identificador único del pago. |
| `importe` | `DECIMAL(10,2)` | - | No | Monto abonado. |
| `fecha_hora` | `DATETIME` | - | No | Momento en que se registró el pago. |
| `id_venta` | `INT` | `FK` | No | Referencia a `VENTA.id_venta`. |
| `id_metodo_pago` | `INT` | `FK` | No | Referencia a `METODO_PAGO.id_metodo_pago`. |
