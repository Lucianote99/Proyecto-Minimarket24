# Etapa IV: Casos de Uso y Consultas SQL - Minimarket-24

Este documento recopila la definición formal y el análisis técnico de los casos de uso correspondientes al sistema **Minimarket-24**, detallando el objetivo de negocio, las reglas de negocio asociadas, las tablas involucradas y el fundamento técnico de las consultas SQL implementadas para cada requerimiento.

---

## Estructura de la Etapa y Alcance Analítico

### 1. Comprobante de Venta (`comprobante-venta.md`)
* **Descripción ampliada:** Este caso de uso resuelve la emisión y consolidación del ticket o factura comercial para una transacción específica realizada en el minimercado. Su objetivo principal es unificar el encabezado general de la venta (datos del cliente, empleado cajero, fecha, hora y estado) con el detalle analítico de cada artículo adquirido. 
* **Aspectos técnicos y de negocio:** 
  - Cumple estrictamente con la regla de negocio **Rn-1 (Inmutabilidad del precio histórico)** al capturar el `precio_unitario` estático del momento de la compra en el detalle, evitando alteraciones por futuros cambios en el catálogo.
  - Implementa funciones de ventana avanzadas de SQL (`OVER(PARTITION BY v.id_venta)`) para calcular de manera eficiente el subtotal por renglón y el total acumulado general de la factura sin necesidad de agrupar toda la consulta principal.
* **Tablas involucradas:** `venta`, `cliente`, `empleado`, `detalle_venta`, `producto`.

---

### 2. Informe de Ventas (`informe-ventas.md`)
* **Descripción ampliada:** Diseñado para la gerencia y supervisores de turno, este caso de uso genera un reporte agregado que evalúa el rendimiento comercial y la productividad del personal de caja. Calcula de forma precisa la cantidad total de transacciones concretadas y el monto monetario recaudado por cada empleado durante un rango de fechas específico.
* **Aspectos técnicos y de negocio:**
  - Da soporte operativo directo a la regla **Rn-5 (Trazabilidad operativa)**, permitiendo auditar las cajas y el desempeño individual durante los cambios de turnos rotativos del minimercado 24/7.
  - Hace uso intensivo de funciones de agregación estándar (`COUNT()`, `SUM()`) combinadas con agrupamientos explícitos (`GROUP BY`) y filtrado estricto por rangos temporales y estados válidos de comprobante (`WHERE v.estado = 'completada'`).
* **Tablas involucradas:** `empleado`, `venta`, `detalle_venta`.

---

### 3. Consulta Avanzada (`consulta-avanzada.md`)
* **Descripción ampliada:** Corresponde a un análisis complejo de negocio y rendimiento de inventario que cruza múltiples tablas para identificar aquellos productos de alta rotación cuya demanda comercial (unidades totales vendidas) supera el rendimiento promedio general de todo el catálogo del minimercado.
* **Aspectos técnicos y de negocio:**
  - Implementa una arquitectura SQL avanzada combinando múltiples uniones (`INNER JOIN`) entre el catálogo de productos, las líneas de detalle y las cabeceras de ventas.
  - Utiliza subconsultas escalares anidadas y tablas derivadas combinadas con la cláusula condicional `HAVING` y funciones estadísticas como `AVG()`. Esto permite evaluar de forma dinámica umbrales complejos de negocio para anticipar necesidades de reabastecimiento y evitar quiebres de stock en tiempo real (**Rn-2**).
* **Tablas involucradas:** `producto`, `detalle_venta`, `venta`.

---

## Resumen Técnico de Operadores SQL Utilizados en la Etapa

| Caso de Uso | Operadores / Cláusulas Principales | Propósito en el SGBD |
| :--- | :--- | :--- |
| **1. Comprobante de Venta** | `JOIN`, `OVER (PARTITION BY)` | Relacionar entidades maestras y calcular totales acumulados en línea. |
| **2. Informe de Ventas** | `GROUP BY`, `COUNT()`, `SUM()` | Agrupar métricas de rendimiento por empleado y calcular totales monetarios. |
| **3. Consulta Avanzada** | `INNER JOIN`, Subconsultas, `HAVING`, `AVG()` | Filtrar conjuntos agrupados mediante umbrales estadísticos dinámicos. |
