/*
  Consulta: Identificación de Clientes Frecuentes.
  Necesidad de negocio:
  Identificar clientes recurrentes que hayan realizado 2 o más compras pagadas
  y cuyo gasto total acumulado supere los $40.000, con el fin de otorgarles
  beneficios de fidelización o descuentos especiales.
*/

SELECT 
        cliente.id_cliente,
        cliente.nombre,
        cliente.apellido,
        COUNT(venta_totales.id_venta) AS cantidad_compras,
        SUM(venta_totales.monto_venta) AS gasto_total_acumulado
    FROM cliente cliente
    INNER JOIN (
        -- Subconsulta: consolida el total vendido en cada venta individual pagada
        SELECT 
            venta.id_venta,
            venta.id_cliente,
            SUM(ventadetalle.cantidad * ventadetalle.precio_unitario) AS monto_venta
        FROM venta venta
        INNER JOIN venta_detalle ventadetalle ON venta.id_venta = ventadetalle.id_venta
        WHERE venta.estado_venta = 'PAGADA'
        GROUP BY venta.id_venta, venta.id_cliente
    ) AS venta_totales ON cliente.id_cliente = venta_totales.id_cliente
    GROUP BY cliente.id_cliente, cliente.nombre, cliente.apellido
    HAVING COUNT(venta_totales.id_venta) >= 3 
    AND SUM(venta_totales.monto_venta) > 40000
    ORDER BY gasto_total_acumulado DESC, cantidad_compras DESC;