/* ============================================================
   ETAPA V - TEMA 4: SEGURIDAD (usuarios, roles y permisos)
   Base de datos: Gestion_Bar  |  Motor: SQL Server Express
   Requisito: tener cargados crear_bd.sql y datos_prueba.sql
   IMPORTANTE: los roles de SEGURIDAD de SQL Server (rol_consulta_productos)
   NO son la tabla "rol" del bar (Cajero, Mozo, etc.). Son cosas distintas.
   ============================================================ */

USE Gestion_Bar;
GO

/* ------------------------------------------------------------
   1. LOGINS (nivel servidor) - credenciales de prueba
   ------------------------------------------------------------ */
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_admin')
    CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_lector')
    CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_con_rol')
    CREATE LOGIN usuario_con_rol WITH PASSWORD = 'Rol123*';
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_sin_rol')
    CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'Rol456*';
GO

/* ------------------------------------------------------------
   2. USUARIOS (nivel base de datos), uno por login
   ------------------------------------------------------------ */
IF DATABASE_PRINCIPAL_ID('usuario_admin') IS NULL
    CREATE USER usuario_admin FOR LOGIN usuario_admin;
IF DATABASE_PRINCIPAL_ID('usuario_lector') IS NULL
    CREATE USER usuario_lector FOR LOGIN usuario_lector;
IF DATABASE_PRINCIPAL_ID('usuario_con_rol') IS NULL
    CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
IF DATABASE_PRINCIPAL_ID('usuario_sin_rol') IS NULL
    CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

/* ------------------------------------------------------------
   3. PROCEDIMIENTO ALMACENADO AUTORIZADO
   Registra una venta simple. Los campos con default (fecha_hora,
   estado_venta) los completa la propia tabla venta.
   ------------------------------------------------------------ */
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaSimple
    @modalidad_consumo VARCHAR(20),   -- EN_LOCAL / PARA_LLEVAR / DELIVERY
    @id_metodo_pago    INT,
    @id_cajero         INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.venta (modalidad_consumo, id_metodo_pago, id_cajero)
    VALUES (@modalidad_consumo, @id_metodo_pago, @id_cajero);

    SELECT SCOPE_IDENTITY() AS id_venta_generada;
END;
GO

/* ------------------------------------------------------------
   4. PERMISOS
   ------------------------------------------------------------ */
-- 4.1 Administrador: rol fijo de la base
ALTER ROLE db_owner ADD MEMBER usuario_admin;

-- 4.2 Lector: solo lectura sobre venta + ejecutar el procedimiento autorizado
GRANT SELECT  ON dbo.venta TO usuario_lector;
GRANT EXECUTE ON dbo.sp_RegistrarVentaSimple TO usuario_lector;

-- 4.3 Rol personalizado para consultar productos
IF DATABASE_PRINCIPAL_ID('rol_consulta_productos') IS NULL
    CREATE ROLE rol_consulta_productos;

GRANT SELECT ON dbo.producto TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
-- usuario_sin_rol NO se agrega a ningun rol (no tiene permisos)
GO

/* ------------------------------------------------------------
   5. VERIFICACION: permisos efectivos registrados en la base
   ------------------------------------------------------------ */
SELECT  pr.name              AS principal,
        pr.type_desc         AS tipo,
        pe.permission_name   AS permiso,
        pe.state_desc        AS estado,
        OBJECT_NAME(pe.major_id) AS objeto
FROM    sys.database_permissions pe
JOIN    sys.database_principals  pr ON pr.principal_id = pe.grantee_principal_id
WHERE   pr.name IN ('usuario_lector','rol_consulta_productos')
ORDER BY pr.name;

SELECT  r.name AS rol, m.name AS miembro
FROM    sys.database_role_members rm
JOIN    sys.database_principals r ON r.principal_id = rm.role_principal_id
JOIN    sys.database_principals m ON m.principal_id = rm.member_principal_id
WHERE   m.name LIKE 'usuario_%';
GO

/* ------------------------------------------------------------
   6. PRUEBAS DE ACCESO
   Se simula cada usuario con EXECUTE AS y se vuelve con REVERT.
   Todo corre dentro de una transaccion que se deshace al final,
   asi no quedan ventas de prueba en la base.
   (Ejecutar con tu usuario administrador / sa en SSMS.)
   ------------------------------------------------------------ */
BEGIN TRANSACTION;

PRINT '--- Prueba 1: INSERT directo sobre venta con usuario_admin (esperado: CORRECTO)';
EXECUTE AS USER = 'usuario_admin';
BEGIN TRY
    INSERT INTO dbo.venta (modalidad_consumo, id_metodo_pago, id_cajero)
    VALUES ('PARA_LLEVAR', 1, 3);
    PRINT 'RESULTADO: OK - venta insertada';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 2: INSERT directo sobre venta con usuario_lector (esperado: DENEGADO)';
EXECUTE AS USER = 'usuario_lector';
BEGIN TRY
    INSERT INTO dbo.venta (modalidad_consumo, id_metodo_pago, id_cajero)
    VALUES ('PARA_LLEVAR', 1, 3);
    PRINT 'RESULTADO: OK - venta insertada';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 3: EXEC sp_RegistrarVentaSimple con usuario_lector (esperado: CORRECTO)';
EXECUTE AS USER = 'usuario_lector';
BEGIN TRY
    EXEC dbo.sp_RegistrarVentaSimple @modalidad_consumo = 'PARA_LLEVAR', @id_metodo_pago = 1, @id_cajero = 3;
    PRINT 'RESULTADO: OK - venta registrada mediante el procedimiento';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 4: SELECT sobre venta con usuario_lector (esperado: CORRECTO)';
EXECUTE AS USER = 'usuario_lector';
BEGIN TRY
    SELECT COUNT(*) AS cantidad_ventas FROM dbo.venta;
    PRINT 'RESULTADO: OK - consulta permitida';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 5: SELECT sobre producto con usuario_con_rol (esperado: CORRECTO)';
EXECUTE AS USER = 'usuario_con_rol';
BEGIN TRY
    SELECT TOP 3 id_producto, nombre, precio FROM dbo.producto;
    PRINT 'RESULTADO: OK - consulta permitida por el rol';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 6: SELECT sobre producto con usuario_sin_rol (esperado: DENEGADO)';
EXECUTE AS USER = 'usuario_sin_rol';
BEGIN TRY
    SELECT TOP 3 id_producto, nombre, precio FROM dbo.producto;
    PRINT 'RESULTADO: OK - consulta permitida';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

PRINT '--- Prueba 7: SELECT sobre venta con usuario_con_rol (esperado: DENEGADO, el rol solo cubre producto)';
EXECUTE AS USER = 'usuario_con_rol';
BEGIN TRY
    SELECT COUNT(*) AS cantidad_ventas FROM dbo.venta;
    PRINT 'RESULTADO: OK - consulta permitida';
END TRY
BEGIN CATCH
    PRINT 'RESULTADO: DENEGADO - ' + ERROR_MESSAGE();
END CATCH;
REVERT;

ROLLBACK TRANSACTION;   -- deshace las ventas de prueba
GO

/* ------------------------------------------------------------
   7. (OPCIONAL) LIMPIEZA - dejar comentado salvo que se quiera borrar todo
   ------------------------------------------------------------
-- REVOKE EXECUTE ON dbo.sp_RegistrarVentaSimple FROM usuario_lector;
-- ALTER ROLE rol_consulta_productos DROP MEMBER usuario_con_rol;
-- DROP ROLE rol_consulta_productos;
-- DROP USER usuario_admin; DROP USER usuario_lector;
-- DROP USER usuario_con_rol; DROP USER usuario_sin_rol;
-- DROP PROCEDURE dbo.sp_RegistrarVentaSimple;
-- USE master; DROP LOGIN usuario_admin; DROP LOGIN usuario_lector;
-- DROP LOGIN usuario_con_rol; DROP LOGIN usuario_sin_rol;
*/
