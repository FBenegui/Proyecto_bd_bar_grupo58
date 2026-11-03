# Transacciones y Propiedades ACID

## 1. Uso de Transacciones en nuestro proyecto
En nuestro sistema de gestión del bar, las transacciones se aplican de forma directa en el proceso de registrar una nueva venta. Utilizamos un bloque `BEGIN TRANSACTION` dentro de un procedimiento almacenado (`sp_registrar_venta`) para englobar tres acciones: registrar el encabezado de la venta, registrar el detalle y descontar el stock de los productos. 

Esto garantiza que estas acciones funcionen como una sola operación inseparable. Si el cliente pide una cantidad de producto que supera el stock disponible, el sistema captura el error y ejecuta un `ROLLBACK`, cancelando todo. Si hay stock suficiente y todo sale bien, se ejecuta un `COMMIT` para guardar definitivamente la venta.

## 2. Cumplimiento de las Propiedades ACID en la Venta
Nuestro procedimiento de ventas garantiza estas propiedades:
*   **Atomicidad:** Es "todo o nada". Nunca va a quedar registrada una venta a medias sin sus detalles, ni se va a descontar stock si el encabezado falló.
*   **Consistencia:** Respetamos las reglas de negocio en todo momento. La transacción no permite que el cálculo de stock arroje un número negativo.
*   **Aislamiento:** Si el mozo Martín y la moza Camila intentan registrar ventas al mismo tiempo sobre el mismo producto, el motor de SQL Server aísla las transacciones para descontar el stock de forma segura sin pisar los datos del otro.
*   **Durabilidad:** Una vez que se ejecuta el `COMMIT` final de la venta, los datos quedan persistidos y no se pierden aunque se corte la energía del servidor.

## 3. Implementación: Procedimiento para registrar ventas
```sql
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
        
        SET @id_nueva_venta = SCOPE_IDENTITY();

        -- Inserción del detalle
        INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario)
        VALUES (@id_nueva_venta, @id_producto, @cantidad, @precio_unitario);

        -- Descuento del stock
        UPDATE producto
        SET stock = stock - @cantidad
        WHERE id_producto = @id_producto;

        COMMIT TRANSACTION;
        PRINT 'Venta registrada y stock actualizado con éxito.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        PRINT 'Operación cancelada. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
```

## 4. Pruebas de ejecución

**Prueba de venta correcta (Ejecuta el COMMIT):**
```sql
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
```

**Prueba de fallo por stock (Ejecuta el ROLLBACK):**
```sql
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
```