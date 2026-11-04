USE Gestion_Bar;
GO

/* FUNCION DE GASTOS ACUMULADOS DE CLIENTES */
CREATE OR ALTER FUNCTION dbo.fn_GastoAcumuladoCliente (@id_cliente INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @gasto DECIMAL(18,2);

    SELECT @gasto = ISNULL(SUM(vd.cantidad * vd.precio_unitario), 0)
    FROM venta AS v
    INNER JOIN venta_detalle AS vd ON vd.id_venta = v.id_venta
    WHERE v.id_cliente   = @id_cliente
      AND v.estado_venta = 'PAGADA';

    RETURN @gasto;
END;
GO