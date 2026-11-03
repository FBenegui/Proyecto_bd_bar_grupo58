-- Creación de la tabla de auditoría
CREATE TABLE auditoria_producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha_modificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Creación del trigger
CREATE TRIGGER trg_auditoria_precio
ON producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verifica si se intentó actualizar la columna precio
    IF UPDATE(precio)
    BEGIN
        INSERT INTO auditoria_producto (id_producto, precio_anterior, precio_nuevo, usuario)
        SELECT 
            i.id_producto,
            d.precio,
            i.precio,
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.id_producto = d.id_producto
        WHERE i.precio <> d.precio; -- Filtra para que solo audite si el valor realmente cambió
    END
END;
GO

-- Pruebas de triggers

-- Actualización de prueba en el precio del Gin Tonic (Producto 5)
UPDATE producto
SET precio = 5800.00
WHERE id_producto = 5;
GO

-- Verificación de la tabla de auditoría para comprobar que el trigger funcionó
SELECT * FROM auditoria_producto;
GO