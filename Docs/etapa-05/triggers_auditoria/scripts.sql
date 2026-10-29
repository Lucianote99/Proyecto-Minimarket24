-- =====================================================================
-- ETAPA V: Triggers y Auditoría - Minimarket-24 (Arquitectura Desacoplada)
-- Archivo: scripts.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- AUDITORÍA DE PRODUCTO (Cambios de Precio)
-- ---------------------------------------------------------------------

-- A. Tabla de auditoría para producto
IF OBJECT_ID('dbo.auditoria_producto', 'U') IS NOT NULL DROP TABLE dbo.auditoria_producto;
GO

CREATE TABLE dbo.auditoria_producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_modificacion DATETIME2 DEFAULT SYSDATETIME(),
    usuario_responsable SYSNAME DEFAULT SUSER_SNAME()
);
GO

-- B. Trigger AFTER UPDATE sobre la tabla producto
CREATE OR ALTER TRIGGER dbo.trg_producto_auditoria
ON dbo.producto
AFTER UPDATE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;

    INSERT INTO dbo.auditoria_producto (
        id_producto, 
        precio_anterior, 
        precio_nuevo, 
        fecha_modificacion, 
        usuario_responsable
    )
    SELECT 
        i.id_producto, 
        d.precio_actual,  -- Precio anterior (tabla deleted)
        i.precio_actual,  -- Precio nuevo (tabla inserted)
        SYSDATETIME(),    -- Fecha y hora exacta
        SUSER_SNAME()     -- Login del usuario conectado
    FROM inserted i
    INNER JOIN deleted d ON i.id_producto = d.id_producto;
END;
GO

-- ---------------------------------------------------------------------
-- AUDITORÍA DE STOCK (Movimientos de Cantidad)
-- ---------------------------------------------------------------------

-- A. Tabla de auditoría para stock
IF OBJECT_ID('dbo.auditoria_stock', 'U') IS NOT NULL DROP TABLE dbo.auditoria_stock;
GO

CREATE TABLE dbo.auditoria_stock (
    id_auditoria_stock INT IDENTITY(1,1) PRIMARY KEY,
    id_stock INT NOT NULL,
    id_producto INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    fecha_modificacion DATETIME2 DEFAULT SYSDATETIME(),
    usuario_responsable SYSNAME DEFAULT SUSER_SNAME()
);
GO

-- B. Trigger AFTER UPDATE sobre la tabla stock
CREATE OR ALTER TRIGGER dbo.trg_stock_auditoria
ON dbo.stock
AFTER UPDATE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;

    INSERT INTO dbo.auditoria_stock (
        id_stock,
        id_producto, 
        stock_anterior, 
        stock_nuevo, 
        fecha_modificacion, 
        usuario_responsable
    )
    SELECT 
        i.id_stock,
        i.id_producto, 
        d.cantidad,       -- Stock anterior (tabla deleted)
        i.cantidad,       -- Stock nuevo (tabla inserted)
        SYSDATETIME(),    -- Fecha y hora exacta
        SUSER_SNAME()     -- Login del usuario conectado
    FROM inserted i
    INNER JOIN deleted d ON i.id_stock = d.id_stock;
END;
GO

-- =====================================================================
-- SCRIPT DE DEMOSTRACIÓN Y VERIFICACIÓN
-- =====================================================================

-- PASO 1: Ver estado inicial del producto 1 y su stock
SELECT p.id_producto, p.nombre, p.precio_actual, s.id_stock, s.cantidad AS stock_actual
FROM dbo.producto p
INNER JOIN dbo.stock s ON s.id_producto = p.id_producto
WHERE p.id_producto = 1;

-- PASO 2: Prueba A - Modificación del Precio de Lista
UPDATE dbo.producto
SET precio_actual = 18000.00
WHERE id_producto = 1;

-- PASO 3: Prueba B - Modificación de Stock por Reabastecimiento
UPDATE dbo.stock
SET cantidad = 30
WHERE id_producto = 1;

-- PASO 4: Verificación de Tablas de Auditoría
SELECT * FROM dbo.auditoria_producto;
SELECT * FROM dbo.auditoria_stock;

-- PASO 5: Ver el estado final de las tablas operativas
SELECT p.id_producto, p.nombre, p.precio_actual, s.cantidad AS stock_actual
FROM dbo.producto p
INNER JOIN dbo.stock s ON s.id_producto = p.id_producto
WHERE p.id_producto = 1;
