# Triggers y Auditoría

## 1. Uso del Trigger en nuestro sistema
En el proyecto del bar, utilizamos un Trigger (`trg_auditoria_precio`) para controlar y auditar la tabla `producto`. Su propósito es mantener un registro histórico y automático de cualquier cambio que se le haga a los precios de la carta.

El trigger está configurado para dispararse únicamente después de que se ejecuta un `UPDATE` en los productos. Cuando esto ocurre, el trigger evalúa si el campo `precio` fue modificado. Si el precio cambió, captura el precio viejo (desde la tabla virtual `deleted`) y el precio nuevo (desde la tabla virtual `inserted`), y los guarda junto con el nombre del usuario de la sesión y la fecha exacta en la tabla `auditoria_producto`. 

## 2. Implementación: Tabla de auditoría y Trigger

```sql
-- Creación de la tabla que guardará el historial
CREATE TABLE auditoria_producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha_modificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Trigger automatizado
CREATE TRIGGER trg_auditoria_precio
ON producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
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
        WHERE i.precio <> d.precio; 
    END
END;
GO
```

## 3. Pruebas de ejecución

**Modificación de un producto:**
Cambiamos el precio del Gin Tonic (Producto 5) de forma manual. Esto dispara nuestro trigger en segundo plano.
```sql
UPDATE producto
SET precio = 5800.00
WHERE id_producto = 5;
```

**Comprobación de la auditoría:**
Verificamos que el sistema haya guardado el registro del cambio.
```sql
SELECT * FROM auditoria_producto;
```