USE Gestion_Bar;
GO

/* FUNCION  DE GASTOS ACUMULADOS PARA CLIENTES DEL BAR EN PORCENTAJES */
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@id_cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @umbral_5  DECIMAL(18,2) = 140000;
    DECLARE @umbral_10 DECIMAL(18,2) = 350000;

    DECLARE @gasto DECIMAL(18,2) = dbo.fn_GastoAcumuladoCliente(@id_cliente);

    RETURN CASE
               WHEN @gasto > @umbral_10 THEN 10.00
               WHEN @gasto > @umbral_5  THEN  5.00
               ELSE 0.00
           END;
END;