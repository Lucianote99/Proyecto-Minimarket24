# 🛒 Sistema de Gestión Minimarket-24

## 📌 1. Descripción del Proyecto
El proyecto **Minimarket-24** abarca el diseño, modelado relacional, implementación física y desarrollo de consultas analíticas para un sistema de gestión comercial en un entorno que opera las 24 horas, los 7 días de la semana. 

En la dinámica real de un local ininterrumpido, las ventas en caja y la reposición de mercadería ocurren en simultáneo. Esto exige una base de datos robusta capaz de procesar transacciones de alta frecuencia garantizando la integridad de los datos, la inmutabilidad de los precios históricos y la prevención de quiebres de stock.

---

## 🛠️ 2. Resumen de Etapas del Proyecto

El desarrollo del proyecto se estructuró de manera evolutiva en **5 etapas** (se encuentran completadas e integradas las Etapas I a IV):

| Etapa | Pregunta que responde | Producto / Entregable | Estado | Documentación |
| :--- | :--- | :--- | :---: | :---: |
| **I. Requerimientos** | ¿Qué necesita el negocio? | Alcance, Reglas de Negocio y Decisiones | 🟢 Completado | [Ver Documentacion etapa 1](docs/etapa-01/descripcion-caso.md)|
| **II. Modelado** | ¿Cómo representamos la información? | DER + Modelo Relacional + Normalización (3FN) | 🟢 Completado | [Ver Documentación de Etapa II](docs/etapa-2)|
| **III. Implementación** | ¿Cómo construimos la BD? | Scripts DDL (SQL Server) + DML (Datos de prueba) | 🟢 Completado | [Ver Documentación de Etapa III](docs/etapa-3) |
| **IV. Consultas** | ¿Cómo obtenemos información? | Casos de uso + Consultas SQL de negocio | 🟢 Completado | [Ver Documentación de Etapa IV](docs/etapa-4) |
| **V. Temas Técnicos** | ¿Cómo hacemos la solución más robusta? | Procedimientos, Funciones, Triggers y Transacciones | ⏳ *En desarrollo* | *Próximamente* |

---

## 📋 3. Reglas de Negocio (RN)
* **Rn-1 (Inmutabilidad del precio histórico):** El sistema registra el precio unitario del producto al momento exacto de la venta (`DETALLE_VENTA.precio_unitario`). Esto evita que los cambios futuros de precios en el catálogo alteren la facturación pasada.
* **Rn-2 (Gestión estricta de stock):** Cada artículo vendido descuenta el stock en tiempo real. Se bloquea cualquier venta que supere las existencias físicas disponibles.
* **Rn-3 (Registro de clientes):** La asociación de un cliente (DNI y contacto) en la cabecera de la venta es opcional (permitiendo ventas rápidas a clientes anónimos o facturación nominada).
* **Rn-4 (Métodos de pago):** Toda venta finalizada debe asociarse obligatoriamente a un método de pago oficial catalogado.
* **Rn-5 (Trazabilidad operativa):** Se registra obligatoriamente el ID del empleado cajero en cada venta para auditar cajas durante los cambios de turno rotativos.
* **Rn-6 (Restricción de anulación):** Las ventas no se eliminan físicamente de la base de datos; se utiliza un estado lógico (ej. `'Anulada'`) para preservar la integridad contable.

---

## 📐 4. Modelo Relacional Normalizado (3FN)
El esquema lógico fue normalizado hasta la **Tercera Forma Normal (3FN)** para evitar anomalías de redundancia y actualización:

* **`CLIENTE`** (`id_cliente` [PK], nombre, apellido, dni, telefono, email)
* **`EMPLEADO`** (`id_empleado` [PK], nombre, apellido, dni)
* **`METODO_PAGO`** (`id_metodo_pago` [PK], nombre)
* **`CATEGORIA`** (`id_categoria` [PK], nombre, descripcion)
* **`VENTA`** (`id_venta` [PK], fecha_hora, estado, `id_cliente` [FK opcional], `id_empleado` [FK])
* **`PAGO`** (`id_pago` [PK], importe, fecha_hora, `id_venta` [FK], `id_metodo_pago` [FK])
* **`PRODUCTO`** (`id_producto` [PK], codigo_barra, descripcion, nombre, precio_actual, `id_categoria` [FK])
* **`STOCK`** (`id_stock` [PK], stock_minimo, cantidad, `id_producto` [FK])
* **`DETALLE_VENTA`** (`id_venta` [PK/FK], `id_producto` [PK/FK], cantidad, precio_unitario)

---

## ⚙️ 5. Implementación Física y Restricciones (SGBD)
La base de datos se implementó en **SQL Server** utilizando sentencias DDL estrictas con las siguientes restricciones:
* **Integridad Referencial:** Claves primarias (`PK`) y claves foráneas (`FK`) nominadas explícitamente (ej. `fk_venta_cliente`, `fk_producto_categoria`).
* **Unicidad (`UNIQUE`):** Garantizada en campos clave como DNI y email de clientes, e identificadores de código de barras (`uk_cliente_dni`, `uk_producto_codigo_barra`).
* **Validación de Dominios (`CHECK`):** Control de precios y montos mayores a cero (`chk_producto_precio`), stock no negativo (`chk_stock_cantidad`) y restricción de estados válidos en ventas (`chk_venta_estado`).

---

## 📂 6. Estructura del Repositorio

A continuación se detalla la organización de los archivos del proyecto en GitHub:

```text
.
├── docs/
│   ├── etapa-01/
│   │   ├── descripcion-caso.md
│   │   ├── alcance.md
│   │   ├── reglas-negocio.md
│   │   └── decisiones-diseno.md
│   ├── etapa-02/
│   │   ├── der/
│   │   │   └── der.png
│   │   ├── modelo-relacional.md
│   │   ├── normalizacion.md
│   │   └── decisiones-diseno.md
│   ├── etapa-03/
│   │   ├── implementacion.md
│   │   ├── restricciones-integridad.md
│   │   └── pruebas-validacion.md
│   └── etapa-04/
│       ├── casos-uso.md
│       ├── comprobante-venta.md
│       ├── informe-ventas.md
│       └── consulta-avanzada.md
├── sql/
│   ├── ddl/
│   │   └── crear_bd.sql
│   ├── dml/
│   │   └── datos_prueba.sql
│   └── consultas/
│       ├── comprobante_venta.sql
│       ├── informe_ventas.sql
│       └── consulta_avanzada.sql
└── README.md
