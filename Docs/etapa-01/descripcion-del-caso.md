# Etapa I: Requerimientos - Minimarket-24

## 1. Introducción y Contexto del Negocio
El proyecto **Minimarket-24** abarca el ciclo completo de operaciones comerciales de venta y control de inventario en un entorno ininterrumpido (funcionamiento continuo 24/7). 

En la dinámica real de un local que nunca cierra, el cobro en caja a los clientes y la reposición de mercadería por parte del personal ocurren en simultáneo y a alta frecuencia. Esta realidad operativa exige un sistema informático robusto, capaz de procesar transacciones concurrentes garantizando la consistencia de los datos, evitando redundancias y previniendo pérdidas económicas o quiebres imprevistos de stock.

---

## 2. ¿Qué necesita el negocio? (Requerimientos Funcionales y Operativos)
Para satisfacer la operatividad del minimercado, el sistema debe dar solución a los siguientes requerimientos clave:
* **Procesamiento de Ventas de Alta Frecuencia:** Registro rápido de comprobantes (tickets de venta) que incluyan tanto los datos de cabecera como el detalle exhaustivo de los productos adquiridos.
* **Control Simultáneo de Inventario:** Descuento automático de stock en tiempo real por cada artículo vendido y visualización de niveles críticos para la reposición.
* **Trazabilidad de Turnos y Personal:** Registro obligatorio del empleado que efectúa cada cobro para permitir auditorías de caja ante cambios de turno rotativos.
* **Fidelización y Facturación a Clientes:** Opción de asociar la venta a un cliente registrado mediante su DNI y datos de contacto, o permitir ventas rápidas sin cliente asignado.
* **Gestión de Medios de Pago:** Vinculación estricta de cada transacción con un método de pago oficial (Efectivo, Tarjeta, Billetera Virtual).

---

## 3. Reglas de Negocio (RN)

Para asegurar la integridad contable y operativa, el sistema implementa de forma obligatoria las siguientes reglas de negocio:

* **Rn-1 (Inmutabilidad del precio histórico):** El sistema debe registrar y congelar el precio unitario del producto al momento exacto de la venta como un campo estático en el ticket. Esto evita que los cambios de precios futuros en el catálogo alteren retroactively la facturación pasada.
* **Rn-2 (Gestión estricta de stock):** Cada artículo vendido en caja descuenta automáticamente el stock en tiempo real. El sistema bloquea y rechaza cualquier intento de venta que intente facturar más unidades de las que existen físicamente en inventario (indicando falta de stock).
* **Rn-3 (Registro de clientes - Opcional):** Los clientes que soliciten factura a su nombre o participen de programas de fidelización se registran mediante su DNI y datos de contacto, asociando este perfil a la cabecera de la venta.
* **Rn-4 (Métodos de pago - Obligatoria):** Toda venta finalizada debe estar vinculada de manera obligatoria a un método de pago oficial del sistema.
* **Rn-5 (Trazabilidad operativa):** No existen ventas "anónimas" en cuanto al personal responsable. Toda transacción registra obligatoriamente el identificador del empleado que la cobró, permitiendo auditar las cajas durante los cambios de turno rotativos.
* **Rn-6 (Restricción de anulación):** Una vez cerrado y emitido el comprobante, este no se elimina físicamente de la base de datos para preservar la contabilidad histórica. Se utiliza un estado lógico (como `"Anulada"`) para mantener la consistencia contable.
