USE minimarket_24;
GO


-- =========================================================================
-- CREACIÓN DE ROLES DE BASE DE DATOS (RBAC)
-- =========================================================================

CREATE ROLE rol_cajero;
CREATE ROLE rol_repositor;
CREATE ROLE rol_administrador;
GO

-- =========================================================================
--  ASIGNACIÓN DE PERMISOS A CADA ROL (GRANT / DENY)
-- =========================================================================

-- -------------------------------------------------------------------------
--  Permisos para ROL_CAJERO
-- -------------------------------------------------------------------------
-- Puede consultar tablas de referencia y registrar clientes nuevos
GRANT SELECT ON dbo.producto TO rol_cajero;
GRANT SELECT ON dbo.categoria TO rol_cajero;
GRANT SELECT ON dbo.metodo_pago TO rol_cajero;
GRANT SELECT, INSERT ON dbo.cliente TO rol_cajero;

-- Puede usar las funciones y ejecutar el procedimiento de venta (Encapsulamiento)
GRANT EXECUTE ON dbo.fn_StockDisponible TO rol_cajero;
GRANT EXECUTE ON dbo.fn_CalcularDescuentoCliente TO rol_cajero;
GRANT EXECUTE ON dbo.sp_RegistrarVentaCompleta TO rol_cajero;

IF OBJECT_ID('dbo.sp_RegistrarVentaTransaccional', 'P') IS NOT NULL
    GRANT EXECUTE ON dbo.sp_RegistrarVentaTransaccional TO rol_cajero;

-- Prohibición explícita (DENY) de alterar precios, stock o borrar ventas manualmente
DENY INSERT, UPDATE, DELETE ON dbo.producto TO rol_cajero;
DENY INSERT, UPDATE, DELETE ON dbo.stock TO rol_cajero;
DENY UPDATE, DELETE ON dbo.venta TO rol_cajero;
DENY UPDATE, DELETE ON dbo.detalle_venta TO rol_cajero;
DENY UPDATE, DELETE ON dbo.pago TO rol_cajero;
GO

-- -------------------------------------------------------------------------
--  Permisos para ROL_REPOSITOR
-- -------------------------------------------------------------------------
-- Puede ver productos y categorías, y consultar/actualizar el stock
GRANT SELECT ON dbo.producto TO rol_repositor;
GRANT SELECT ON dbo.categoria TO rol_repositor;
GRANT SELECT, UPDATE ON dbo.stock TO rol_repositor;

-- Prohibición explícita de ver o tocar datos de ventas, pagos y clientes
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.venta TO rol_repositor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.detalle_venta TO rol_repositor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.pago TO rol_repositor;
GO

-- -------------------------------------------------------------------------
-- Permisos para ROL_ADMINISTRADOR
-- -------------------------------------------------------------------------
GRANT CONTROL ON SCHEMA::dbo TO rol_administrador;
GO

-- =========================================================================
-- CREACIÓN DE USUARIOS DE PRUEBA Y ASIGNACIÓN A ROLES
-- =========================================================================
-- Usamos WITHOUT LOGIN para poder simular el cambio de usuario con EXECUTE AS
-- sin necesidad de desconectarnos del servidor.

CREATE USER usr_cajero_turno_noche WITHOUT LOGIN;
CREATE USER usr_repositor_deposito WITHOUT LOGIN;
CREATE USER usr_gerente_general WITHOUT LOGIN;
GO

EXEC sp_addrolemember 'rol_cajero', 'usr_cajero_turno_noche';
EXEC sp_addrolemember 'rol_repositor', 'usr_repositor_deposito';
EXEC sp_addrolemember 'rol_administrador', 'usr_gerente_general';
GO

-- Consulta de verificación: Muestra cómo quedaron vinculados los usuarios y sus roles
SELECT 
    r.name AS Rol_Asignado,
    u.name AS Usuario_Base_Datos,
    u.type_desc AS Tipo_Objeto
FROM sys.database_role_members rm
INNER JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
INNER JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
WHERE r.name IN ('rol_cajero', 'rol_repositor', 'rol_administrador');
GO


-- =========================================================================
-- DEMOSTRACIÓN Y EVIDENCIA (CASOS EXITOSOS Y FALLIDOS)
-- =========================================================================

-- -------------------------------------------------------------------------
-- PRUEBAS  Simulación como CAJERO (usr_cajero_turno_noche)
-- -------------------------------------------------------------------------
EXECUTE AS USER = 'usr_cajero_turno_noche';
GO

-- CASO EXITOSO: El cajero consulta el catálogo y registra una venta mediante el SP
-- (Notá que el cajero NO tiene permiso de INSERT en 'venta' ni UPDATE en 'stock',
-- pero SQL Server le permite hacerlo a través del Procedimiento Almacenado).
SELECT USER_NAME() AS Usuario_Actual_En_Sesion;

EXEC dbo.sp_RegistrarVentaCompleta 
    @id_cliente = 2, 
    @id_empleado = 3, 
    @id_producto = 5, -- Alfajor de Chocolate
    @cantidad = 2, 
    @id_metodo_pago = 1;
GO

--  CASO FALLIDO (Acceso Denegado): El cajero intenta rebajar el precio de la Gaseosa a $10
-- Resultado esperado: Error 229 (Se denegó el permiso UPDATE en el objeto 'producto')
UPDATE dbo.producto 
SET precio_actual = 10.00 
WHERE id_producto = 1;
GO

--  CASO FALLIDO (Acceso Denegado): El cajero intenta borrar una venta para quedarse con el efectivo
-- Resultado esperado: Error 229 (Se denegó el permiso DELETE en el objeto 'venta')
DELETE FROM dbo.venta 
WHERE id_venta = 1;
GO

-- Volvemos a nuestra sesión original de Administrador
REVERT;
GO

-- -------------------------------------------------------------------------
--  Simulación como REPOSITOR (usr_repositor_deposito)
-- -------------------------------------------------------------------------
EXECUTE AS USER = 'usr_repositor_deposito';
GO

--  CASO EXITOSO: El repositor repone 10 unidades de Leche Entera (id_producto = 3)
SELECT USER_NAME() AS Usuario_Actual_En_Sesion;

UPDATE dbo.stock 
SET cantidad = cantidad + 10 
WHERE id_producto = 3;

SELECT id_producto, cantidad AS Stock_Actualizado 
FROM dbo.stock 
WHERE id_producto = 3;
GO

--  CASO FALLIDO (Acceso Denegado): El repositor intenta espiar la recaudación en la tabla 'pago'
-- Resultado esperado: Error 229 (Se denegó el permiso SELECT en el objeto 'pago')
SELECT * FROM dbo.pago;
GO

-- Volvemos siempre a nuestra cuenta principal al terminar la prueba
REVERT;
GO