USE Gestion_Bar;
GO

/* PRUEBAS */

-- 5.1 Datos reales: todos los clientes con gasto (todas las ventas vs solo pagadas) y descuento
SELECT c.id_cliente,
       p.nombre + ' ' + p.apellido AS cliente,
       (SELECT ISNULL(SUM(vd.cantidad * vd.precio_unitario), 0)
          FROM venta v
          JOIN venta_detalle vd ON vd.id_venta = v.id_venta
         WHERE v.id_cliente = c.id_cliente)            AS gasto_todas_las_ventas,
       dbo.fn_GastoAcumuladoCliente(c.id_cliente)      AS gasto_solo_pagadas,
       dbo.fn_CalcularDescuentoCliente(c.id_cliente)   AS descuento_pct
FROM cliente c
INNER JOIN persona p ON p.id_persona = c.id_cliente
ORDER BY gasto_solo_pagadas DESC;
GO

-- 5.2 Casos borde: cliente inexistente y consumidor final (NULL) -> 0
SELECT dbo.fn_CalcularDescuentoCliente(-1)   AS descuento_inexistente,
       dbo.fn_CalcularDescuentoCliente(NULL) AS descuento_consumidor_final;
GO


/* 
       Se carga la carta completa del bar (categoria 'DEMO Bebidas') y cada
       ticket tipico es: 1 chopp Heineken + 1 fernet + 1 negroni +
       1 aperol spritz = 10.000 + 9.000 + 8.000 + 8.000 = $35.000

       cliente  tickets                         gasto pagado   esperado
          1     11 pagados                         385.000        10 %
          2     10 pagados (justo en el limite)    350.000         5 %
          3      5 pagados                         175.000         5 %
          4      4 pagados (justo en el limite)    140.000         0 %
          5      4 pagados + 3 pendientes          140.000         0 %  (ignora no pagadas)
          6      sin ventas                              0         0 %
*/
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @cajero INT = (SELECT TOP 1 id_usuario     FROM usuario     ORDER BY id_usuario);
DECLARE @mp     INT = (SELECT TOP 1 id_metodo_pago FROM metodo_pago ORDER BY id_metodo_pago);

-- Carta del bar
INSERT INTO categoria (nombre_categoria) VALUES ('DEMO Bebidas');
DECLARE @cat INT = SCOPE_IDENTITY();

INSERT INTO producto (nombre, precio, id_categoria) VALUES
    ('DEMO Agua',                  5000, @cat),
    ('DEMO Gaseosa',               5000, @cat),
    ('DEMO Chopp Heineken',       10000, @cat),
    ('DEMO Heineken lata',         7000, @cat),
    ('DEMO Red Bull',              6000, @cat),
    ('DEMO Trago sin alcohol',     7000, @cat),
    ('DEMO Gin Tonic',             9000, @cat),
    ('DEMO Aperol Spritz',         8000, @cat),
    ('DEMO Fernet',                9000, @cat),
    ('DEMO Negroni',               8000, @cat),
    ('DEMO Campari',               8000, @cat),
    ('DEMO Caipi frutos rojos',    8000, @cat),
    ('DEMO Cuba Libre',            8000, @cat);

DECLARE @p_chopp   INT = (SELECT id_producto FROM producto WHERE nombre = 'DEMO Chopp Heineken');
DECLARE @p_fernet  INT = (SELECT id_producto FROM producto WHERE nombre = 'DEMO Fernet');
DECLARE @p_negroni INT = (SELECT id_producto FROM producto WHERE nombre = 'DEMO Negroni');
DECLARE @p_aperol  INT = (SELECT id_producto FROM producto WHERE nombre = 'DEMO Aperol Spritz');

-- Plan de la demostracion
DECLARE @plan TABLE (n INT, pagadas INT, pendientes INT, esperado DECIMAL(5,2));
INSERT INTO @plan (n, pagadas, pendientes, esperado) VALUES
    (1, 11, 0, 10),
    (2, 10, 0,  5),
    (3,  5, 0,  5),
    (4,  4, 0,  0),
    (5,  4, 3,  0),
    (6,  0, 0,  0);

-- Clientes demo
DECLARE @cli TABLE (n INT, id_cliente INT);
DECLARE @k INT = 1, @id INT;
WHILE @k <= 6
BEGIN
    INSERT INTO persona (dni, nombre, apellido)
    VALUES ('DEMO-' + CAST(@k AS VARCHAR(5)), 'Demo', 'Cliente ' + CAST(@k AS VARCHAR(5)));
    SET @id = SCOPE_IDENTITY();
    INSERT INTO cliente (id_cliente) VALUES (@id);
    INSERT INTO @cli (n, id_cliente) VALUES (@k, @id);
    SET @k += 1;
END;

-- Tickets (cada uno: chopp + fernet + negroni + aperol spritz = 35.000)
DECLARE @cid INT, @pag INT, @pen INT, @t INT, @venta INT, @estado VARCHAR(20);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT cl.id_cliente, p.pagadas, p.pendientes
    FROM @plan AS p
    INNER JOIN @cli AS cl ON cl.n = p.n;

OPEN cur;
FETCH NEXT FROM cur INTO @cid, @pag, @pen;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @t = 0;
    WHILE @t < @pag + @pen
    BEGIN
        SET @estado = CASE WHEN @t < @pag THEN 'PAGADA' ELSE 'PENDIENTE' END;

        INSERT INTO venta (estado_venta, modalidad_consumo, id_cliente, id_metodo_pago, id_cajero)
        VALUES (@estado, 'EN_LOCAL', @cid, @mp, @cajero);
        SET @venta = SCOPE_IDENTITY();

        -- precio_unitario tomado del precio de la carta
        INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario)
        SELECT @venta, id_producto, 1, precio
        FROM producto
        WHERE id_producto IN (@p_chopp, @p_fernet, @p_negroni, @p_aperol);

        SET @t += 1;
    END;
    FETCH NEXT FROM cur INTO @cid, @pag, @pen;
END;
CLOSE cur;
DEALLOCATE cur;

-- Resultado de la demostracion
SELECT c.n                                           AS caso,
       p.nombre + ' ' + p.apellido                   AS cliente,
       pl.pagadas                                    AS tickets_pagados,
       pl.pendientes                                 AS tickets_pendientes,
       dbo.fn_GastoAcumuladoCliente(c.id_cliente)    AS gasto_pagado,
       pl.esperado                                   AS descuento_esperado,
       dbo.fn_CalcularDescuentoCliente(c.id_cliente) AS descuento_obtenido,
       CASE WHEN pl.esperado = dbo.fn_CalcularDescuentoCliente(c.id_cliente)
            THEN 'OK' ELSE 'ERROR' END               AS resultado
FROM @cli AS c
INNER JOIN @plan   AS pl ON pl.n = c.n
INNER JOIN persona AS p  ON p.id_persona = c.id_cliente
ORDER BY c.n;

-- Comprobante de una venta del cliente 1
-- Esperado: subtotal 35.000 | descuento 10 % = 3.500 | total a pagar 31.500
DECLARE @vcomp INT = (SELECT TOP 1 v.id_venta
                      FROM venta AS v
                      INNER JOIN @cli AS c ON c.id_cliente = v.id_cliente
                      WHERE c.n = 1
                      ORDER BY v.id_venta);
EXEC sp_comprobante_venta @IdVenta = @vcomp;

ROLLBACK TRANSACTION;   -- se descartan categoria, productos, clientes y ventas de prueba
GO