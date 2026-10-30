
# 4. Seguridad y Control de Acceso

## Definición y Objetivo
La **seguridad en bases de datos** comprende el conjunto de mecanismos de autenticación, autorización y control de acceso que protegen la confidencialidad, integridad y disponibilidad de la información frente a accesos no autorizados o manipulaciones indebidas.

**Objetivo:** Implementar en `minimarket_24` un esquema de **Control de Acceso Basado en Roles (RBAC)** bajo el **Principio de Menor Privilegio**, garantizando que cada perfil operativo del negocio acceda exclusivamente a los objetos (tablas, vistas, procedimientos y funciones) estrictamente necesarios para cumplir su tarea.

## Ventajas y Aplicaciones en el Minimarket 24hs
En un comercio abierto las 24 horas con rotación constante de turnos, resulta crítico evitar que todos los empleados operen con una cuenta de administrador:
1. **Prevención de Fraude y Errores:** Un cajero no debe tener permisos para modificar manualmente el precio de un artículo en `producto`, alterar existencias en `stock` ni eliminar registros en `venta` o `pago`.
2. **Seguridad por Encapsulamiento (Procedimientos Almacenados):** Al otorgar al cajero permiso de ejecución (`GRANT EXECUTE`) sobre el procedimiento `sp_RegistrarVentaCompleta` sin darle permisos directos de escritura (`INSERT`/`UPDATE`/`DELETE`) sobre las tablas subyacentes, se fuerza a que toda operación de caja respete las validaciones del negocio.
3. **Administración Escalable mediante Roles:** Si ingresa un nuevo cajero al minimarket, basta con agregar su usuario al rol `rol_cajero` para que herede automáticamente todos sus permisos y restricciones.

## Caso Concreto Aplicado al Sistema (`minimarket_24`)
Se diseñan tres roles operativos adaptados a la estructura del minimarket:
* **`rol_cajero` (Atención en Caja):**
  * **Permitido (`GRANT`):** Consultar catálogo y clientes (`SELECT` en `producto`, `categoria`, `metodo_pago`, `cliente`), dar de alta nuevos clientes (`INSERT` en `cliente`), y registrar ventas completas mediante la ejecución de `sp_RegistrarVentaCompleta`, `sp_RegistrarVentaTransaccional` y funciones de consulta (`fn_StockDisponible`, `fn_CalcularDescuentoCliente`).
  * **Denegado (`DENY`):** Modificar o eliminar precios, stock o ventas (`UPDATE`, `DELETE` sobre `producto`, `stock`, `venta`, `detalle_venta` y `pago`).
* **`rol_repositor` (Control de Depósito y Góndola):**
  * **Permitido (`GRANT`):** Consultar artículos y existencias (`SELECT` en `producto`, `categoria`, `stock`) y actualizar cantidades de inventario (`UPDATE` en `stock`).
  * **Denegado (`DENY`):** Acceso a información financiera y de facturación (`venta`, `detalle_venta`, `pago`).
* **`rol_administrador` (Gerencia):**
  * **Permitido (`GRANT`):** Control total (`CONTROL`) sobre el esquema `dbo`, incluyendo acceso a tablas de auditoría, gestión de empleados y ajuste de precios.
