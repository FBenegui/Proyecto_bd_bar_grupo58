GO
USE Gestion_Bar;
GO

CREATE OR ALTER PROCEDURE sp_comprobante_venta  -- hace que no se deban realizar cambios para proximos tickets
    @IdVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación: si la venta no existe, se avisa en vez de devolver vacío
    IF NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = @IdVenta)
    BEGIN
        ;THROW 50001, 'La venta indicada no existe.', 1;
    END;



-- 1. ENCABEZADO

SELECT
    v.id_venta AS nro_comprobante,
    v.fecha_hora,
    v.estado_venta,
    v.modalidad_consumo,
    COALESCE(pc.nombre + ' ' + pc.apellido, 'Consumidor final') AS cliente,
    pc.dni                                             AS dni_cliente,
    COALESCE(u.nombre_ubicacion, 'Sin ubicación')      AS ubicacion,
    mp.nombre_metodo                                   AS metodo_pago,
    pcaj.nombre + ' ' + pcaj.apellido                  AS cajero,
    COALESCE(pm.nombre + ' ' + pm.apellido, 'Sin mozo') AS mesero
FROM venta AS v
INNER JOIN metodo_pago AS mp     ON mp.id_metodo_pago = v.id_metodo_pago
INNER JOIN usuario     AS ucaj   ON ucaj.id_usuario   = v.id_cajero
INNER JOIN persona     AS pcaj   ON pcaj.id_persona   = ucaj.id_usuario
LEFT  JOIN cliente     AS c      ON c.id_cliente      = v.id_cliente
LEFT  JOIN persona     AS pc     ON pc.id_persona     = c.id_cliente
LEFT  JOIN ubicacion   AS u      ON u.id_ubicacion    = v.id_ubicacion
LEFT  JOIN usuario     AS um     ON um.id_usuario     = v.id_mesero
LEFT  JOIN persona     AS pm     ON pm.id_persona     = um.id_usuario
WHERE v.id_venta = @IdVenta;


-- 2. DETALLE + TOTAL (la última fila es el total de la factura)

SELECT
        CASE WHEN GROUPING(p.id_producto) = 1 THEN 'TOTAL' ELSE p.nombre END AS producto,
        vd.cantidad,
        vd.precio_unitario,
        SUM(vd.cantidad * vd.precio_unitario)               AS subtotal
    FROM venta_detalle AS vd
    INNER JOIN producto AS p ON p.id_producto = vd.id_producto
    WHERE vd.id_venta = @IdVenta
    GROUP BY ROLLUP ((p.id_producto, p.nombre, vd.cantidad, vd.precio_unitario))
    ORDER BY GROUPING(p.id_producto), p.nombre;
END;
GO