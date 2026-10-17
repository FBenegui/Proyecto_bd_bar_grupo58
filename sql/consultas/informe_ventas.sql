/*
    Reporte agregado de ventas por categoría.
    Rango de ejemplo: 24/09/2026 a 30/09/2026, inclusive.
    Se consideran únicamente ventas PAGADAS.
*/
USE Gestion_Bar;
GO

DECLARE @FechaDesde DATE = '2026-09-24';
DECLARE @FechaHasta DATE = '2026-09-30';

SELECT
    c.id_categoria,
    c.nombre_categoria,
    COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
    COUNT(*) AS cantidad_renglones,
    SUM(vd.cantidad) AS unidades_vendidas,
    SUM(vd.cantidad * vd.precio_unitario) AS total_vendido
FROM venta AS v
INNER JOIN venta_detalle AS vd
    ON vd.id_venta = v.id_venta
INNER JOIN producto AS p
    ON p.id_producto = vd.id_producto
INNER JOIN categoria AS c
    ON c.id_categoria = p.id_categoria
WHERE v.fecha_hora >= @FechaDesde
  AND v.fecha_hora < DATEADD(DAY, 1, @FechaHasta)
  AND v.estado_venta = 'PAGADA'
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY total_vendido DESC, c.nombre_categoria;
