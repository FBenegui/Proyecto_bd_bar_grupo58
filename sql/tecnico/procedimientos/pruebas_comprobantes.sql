USE Gestion_Bar;
GO

/* Pruebas del comprobante de venta */

-- Comprobante de la venta mas reciente (datos reales)
DECLARE @v INT = (SELECT TOP 1 id_venta FROM venta ORDER BY fecha_hora DESC, id_venta DESC);
EXEC sp_comprobante_venta @IdVenta = @v;
GO

-- Venta inexistente (debe lanzar el error 50001)
EXEC sp_comprobante_venta @IdVenta = -1;
GO
