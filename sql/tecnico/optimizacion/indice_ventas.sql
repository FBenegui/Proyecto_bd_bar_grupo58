/* Índice recomendado para el filtro por estado y rango de fecha del informe.
   Revisar el impacto en escrituras/almacenamiento antes de desplegarlo en
   una base operativa. No se crea automáticamente en la base real. */
USE Gestion_Bar;
GO

CREATE NONCLUSTERED INDEX IX_venta_estado_fecha
    ON dbo.venta (estado_venta, fecha_hora);
GO

/* Para revertir explícitamente el índice de la base operativa:
DROP INDEX IX_venta_estado_fecha ON dbo.venta;
*/
