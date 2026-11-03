-- Procedimiento almacenado para registrar venta con control de transacciones
CREATE PROCEDURE sp_registrar_venta
    @id_cliente INT,
    @id_ubicacion INT,
    @id_metodo_pago INT,
    @id_cajero INT,
    @id_mesero INT,
    @modalidad_consumo VARCHAR(20),
    @id_producto INT,
    @cantidad DECIMAL(10,2),
    @precio_unitario DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificación de stock disponible
        DECLARE @stock_actual INT;
        SELECT @stock_actual = stock FROM producto WHERE id_producto = @id_producto;

        IF @stock_actual < @cantidad
        BEGIN
            THROW 50001, 'Stock insuficiente para realizar la venta.', 1;
        END

        -- Inserción del encabezado
        DECLARE @id_nueva_venta INT;
        INSERT INTO venta (modalidad_consumo, id_cliente, id_ubicacion, id_metodo_pago, id_cajero, id_mesero)
        VALUES (@modalidad_consumo, @id_cliente, @id_ubicacion, @id_metodo_pago, @id_cajero, @id_mesero);
        
        -- Obtiene el ID generado automáticamente
        SET @id_nueva_venta = SCOPE_IDENTITY();

        -- Inserción del detalle de venta
        INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario)
        VALUES (@id_nueva_venta, @id_producto, @cantidad, @precio_unitario);

        -- Actualización del inventario
        UPDATE producto
        SET stock = stock - @cantidad
        WHERE id_producto = @id_producto;

        -- Confirmación de la transacción
        COMMIT TRANSACTION;
        PRINT 'Venta registrada y stock actualizado con éxito.';
    END TRY
    BEGIN CATCH
        -- Si hay un error y la transacción está abierta, se deshace todo
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        PRINT 'Operación cancelada. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Pruebas de transacciones

-- Prueba 1: Venta correcta
-- Producto 4 (Fernet con Coca) tiene stock suficiente
EXEC sp_registrar_venta 
    @id_cliente = 11, 
    @id_ubicacion = 1, 
    @id_metodo_pago = 1, 
    @id_cajero = 3, 
    @id_mesero = 4, 
    @modalidad_consumo = 'EN_LOCAL', 
    @id_producto = 4, 
    @cantidad = 2, 
    @precio_unitario = 4500.00;
GO

-- Prueba 2: Venta con stock insuficiente
-- Producto 10 (Pinta IPA) no tiene 1000 unidades, debe hacer ROLLBACK
EXEC sp_registrar_venta 
    @id_cliente = 12, 
    @id_ubicacion = 2, 
    @id_metodo_pago = 2, 
    @id_cajero = 10, 
    @id_mesero = 9, 
    @modalidad_consumo = 'EN_LOCAL', 
    @id_producto = 10, 
    @cantidad = 1000, 
    @precio_unitario = 3500.00;
GO