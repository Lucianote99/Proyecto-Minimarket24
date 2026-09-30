## 1. Introducción y Selección del SGBD

En esta tercera etapa, el modelo lógico relacional obtenido en la etapa previa fue trasladado al entorno físico utilizando un SGBD (Sistema de Gestión de Bases de Datos) relacional. Se seleccionó **SQL Server** como motor de base de datos debido a su robustez, soporte corporativo para restricciones de integridad y compatibilidad con transacciones ACID.

## 2. Correspondencia del Modelo Lógico al SGBD

Cada entidad del modelo relacional se transformó en una tabla física aplicando el lenguaje DDL (Data Definition Language) mediante el script `minimarket24_bd.sql`. 

Las tablas principales creadas son: `cliente`, `empleado`, `venta`, `categoria`, `producto`, `stock`, `detalle_venta`, `metodo_pago` y `pago`.

Se respetaron los tipos de datos estrictos acordados para optimizar el almacenamiento y asegurar la consistencia (ej. `INT` para identificadores, `VARCHAR` para cadenas de texto, `DECIMAL(10,2)` para importes monetarios y precios, y `DATETIME` para fechas y horas).
