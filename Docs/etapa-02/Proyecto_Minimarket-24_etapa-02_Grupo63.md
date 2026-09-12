Proyecto "Sistema_Venta_MiniMarket_24hs"Universidad Nacional del Nordeste | Facultad de Ciencias Exactas y Naturales y Agrimensura  
Cátedra: BASE DE DATOS I
GRUPO 63 
| Año: 2026  IntegrantesJose Ramon Antonio Almiron | DNI. N°: 46.602.154  
Bernardy Santiago Ezequiel | DNI. N°: 43.534.343  
Luciano Andrés Erck | DNI. N° 45.791.360  
Tomas Augusto Esquivel | DNI. N°: 46.842.306  
Adolfo Joaquin Jesus Rodriguez | DNI. N°: 46.516.290  
Proyecto: Minimarket-24 - Etapa I: Requerimientos
Introducción
El proyecto abarca el ciclo completo de ventas y control de inventario en un entorno comercial ininterrumpido (todo el tiempo funcionando). 
En la dinámica real de un local que nunca cierra, el cobro en caja y la reposición de mercadería ocurren en simultáneo.
Esto exige un sistema robusto, capaz de procesar transacciones de alta frecuencia garantizando la integridad de los datos y evitando redundancias.  
Reglas de Negocio 
Rn-1 
Inmutabilidad del precio histórico (Obligatoria): El sistema debe registrar el precio unitario del producto al momento exacto de la venta como un campo estático en el ticket. 
Esto evita que los cambios de precio futuros en el catálogo alteren retroactivamente la facturación pasada. 
Rn-2 
Gestión estricta de stock (Obligatoria): Cada artículo vendido en caja, se descuenta automáticamente el stock en tiempo real. 
El sistema bloquea cualquier venta que intenta facturar más unidades de las que existen físicamente (indicando falta de stock). 
Rn-3
Registro de clientes (Opcional): Los clientes que pidan factura a su nombre o participen en la fidelización se registran con su DNI y datos de contacto, asociando este perfil a la cabecera de la venta. 
Rn-4
Métodos de pago (Obligatoria): Toda venta finalizada debe estar vinculada a un método de pago oficial del sistema (ej. Efectivo, Tarjeta, Billetera Virtual).  
Rn-5 
Trazabilidad operativa: No existen ventas "anónimas". Toda transacción registra el ID del empleado que la cobró, lo que permite auditar las cajas durante los cambios de turno rotativos.  
Rn-6 
Restricción de anulación: Una vez cerrado el comprobante, no se elimina físicamente de la base de datos. 
Se utiliza un estado lógico (como "Anulada") para no romper la consistencia contable. 

Etapa II: Modelado Conceptual y Lógico  Diagrama Entidad-Relación (DER)  

El diseño conceptual (desarrollado en ERDPlus) 

refleja cómo interactúan las entidades del minimarket:  Ventas y Trazabilidad: Una Venta se asocia opcionalmente a un Cliente (0..1), pero es procesada obligatoriamente por un Empleado (1..1) para mantener
el control de los turnos. 
Detalle y Precios: La relación M:N entre Venta y Producto se resuelve con la entidad débil Detalle_Venta, que captura el precio_unitario para congelarlo en el tiempo.  
Inventario: Cada Producto pertenece a una Categoría (1:N) y tiene una relación estricta (1:1) con la entidad Stock, automatizando el descuento de mercadería.  
Pagos: Una Venta puede dividirse en varios registros de Pago (1:N), y cada pago utiliza obligatoriamente un Método_Pago catalogado. 

Transformación al Modelo Relacional 

A partir del diagrama, derivamos el siguiente esquema lógico con sus respectivas Claves Primarias (PK) y Foráneas (FK): 
CLIENTE (id_cliente [PK], nombre, apellido, dni, telefono, email)  
EMPLEADO (id_empleado [PK], nombre, apellido, dni) 
METODO_PAGO (id_metodo_pago [PK], nombre)  
CATEGORIA (id_categoria [PK], nombre, descripcion)  
VENTA (id_venta [PK], fecha_hora, estado, id_cliente [FK opcional], id_empleado [FK])  
PAGO (id_pago [PK], importe, fecha_hora, id_venta [FK], id_metodo_pago [FK])  
PRODUCTO (id_producto [PK], codigo_barra, descripcion, nombre, precio_actual, id_categoria [FK])  
STOCK (id_stock [PK], stock_minimo, cantidad, id_producto [FK])  
DETALLE_VENTA (id_venta [PK/FK], id_producto [PK/FK], cantidad, precio_unitario) 

Proceso de Normalización  
Para asegurar una base de datos ágil y libre de anomalías, normalizamos el esquema partiendo de un "Documento Universal" (UNF)
-imaginando una factura plana con todos los datos mezclados- hasta llegar a la Tercera Forma Normal (3FN). 
Forma No Normalizada (UNF): Un solo reporte gigante con la venta, el empleado, el cliente y un grupo repetitivo con todos los productos comprados y sus detalles de stock. 
Primera Forma Normal (1FN) - Eliminando grupos repetitivos: Separamos los productos comprados a una tabla nueva (DETALLE_1FN), vinculándolos con el ID de la venta. 
Ahora tenemos atributos atómicos y una clave primaria compuesta para el detalle (id_venta + id_producto).  
Segunda Forma Normal (2FN) - Eliminando dependencias parciales: En nuestro detalle, datos como el nombre del producto o su categoría dependen solo del id_producto, no de la venta. 
Extraemos esto a una tabla PRODUCTO_2FN, dejando en el detalle únicamente lo que depende de la transacción completa (cantidad y precio cobrado).  
Tercera Forma Normal (3FN) - Eliminando dependencias transitivas: Limpiamos las dependencias indirectas.
En la tabla de ventas, los datos personales del cliente y del empleado se separan en sus propias entidades maestras.
En los productos, la categoría y el stock físico se aíslan para gestionarse independientemente del catálogo. 
