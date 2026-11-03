/*
    Benchmark aislado para Tema 5: informe de ventas por categoría.
    Ejecutar en SQL Server Management Studio (SSMS) con permisos para crear BD.
    Usa una base y tablas propias; no modifica Gestion_Bar ni sus ventas reales.

    Pasos: ejecutar primero la sección A (preparación, una vez); luego B (sin
    índice) y C (con índice), guardando STATISTICS IO/TIME y el plan real.
    Activar en SSMS: Consulta > Incluir plan de ejecución real (Ctrl+M).
*/

/* A. Preparación: base independiente y 1.000.000 ventas sintéticas. */
IF DB_ID(N'Gestion_Bar_Benchmark') IS NULL
    EXEC(N'CREATE DATABASE Gestion_Bar_Benchmark');
GO
USE Gestion_Bar_Benchmark;
GO

DROP TABLE IF EXISTS dbo.venta_detalle;
DROP TABLE IF EXISTS dbo.venta;
DROP TABLE IF EXISTS dbo.producto;
DROP TABLE IF EXISTS dbo.categoria;
GO

CREATE TABLE dbo.categoria (
    id_categoria INT NOT NULL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);
CREATE TABLE dbo.producto (
    id_producto INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL
);
CREATE TABLE dbo.venta (
    id_venta INT NOT NULL PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL,
    estado_venta VARCHAR(20) NOT NULL
);
CREATE TABLE dbo.venta_detalle (
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_bench_venta_detalle PRIMARY KEY CLUSTERED (id_venta, id_producto)
);
GO

INSERT dbo.categoria (id_categoria, nombre_categoria)
VALUES (1,'Cervezas'), (2,'Cócteles'), (3,'Botellas'), (4,'Tragos Directos'), (5,'Sin alcohol');

;WITH n AS (
    SELECT TOP (100) CONVERT(INT, ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT dbo.producto (id_producto, nombre, id_categoria)
SELECT n, CONCAT('Producto ', n), ((n - 1) % 5) + 1 FROM n;
GO

/* Generador de 1.000.000 enteros, sin depender de tablas del negocio. */
;WITH digitos AS (
    SELECT n FROM (VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) d(n)
), numeros AS (
    SELECT TOP (1000000)
        CONVERT(INT, ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS n
    FROM digitos a CROSS JOIN digitos b CROSS JOIN digitos c
    CROSS JOIN digitos d CROSS JOIN digitos e CROSS JOIN digitos f
)
INSERT dbo.venta (id_venta, fecha_hora, estado_venta)
SELECT n,
       DATEADD(SECOND, CONVERT(INT, (CONVERT(BIGINT, n) * 7919) % 86400),
           DATEADD(DAY, (n - 1) % 730, CONVERT(DATETIME2,'2025-01-01'))),
       CASE WHEN n % 10 < 7 THEN 'PAGADA'
            WHEN n % 10 < 9 THEN 'PENDIENTE' ELSE 'CANCELADA' END
FROM numeros;
GO

/* Dos renglones por venta: dos millones de detalles. */
INSERT dbo.venta_detalle (id_venta, id_producto, cantidad, precio_unitario)
SELECT v.id_venta, p.id_producto,
       CONVERT(DECIMAL(10,2), 1 + (v.id_venta % 4)),
       CONVERT(DECIMAL(10,2), 1500 + (p.id_producto * 125))
FROM dbo.venta v
CROSS APPLY (VALUES (((v.id_venta - 1) % 100) + 1), ((v.id_venta % 100) + 1)) x(id_producto)
JOIN dbo.producto p ON p.id_producto = x.id_producto;
GO

/* B. Medición sin índice adicional: mismo informe, sobre datos sintéticos. */
DECLARE @FechaDesde DATE = '2025-06-01';
DECLARE @FechaHasta DATE = '2025-06-07';
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT c.id_categoria, c.nombre_categoria,
       COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
       COUNT(*) AS cantidad_renglones,
       SUM(vd.cantidad) AS unidades_vendidas,
       SUM(vd.cantidad * vd.precio_unitario) AS total_vendido
FROM dbo.venta AS v
INNER JOIN dbo.venta_detalle AS vd ON vd.id_venta = v.id_venta
INNER JOIN dbo.producto AS p ON p.id_producto = vd.id_producto
INNER JOIN dbo.categoria AS c ON c.id_categoria = p.id_categoria
WHERE v.fecha_hora >= @FechaDesde
  AND v.fecha_hora < DATEADD(DAY, 1, @FechaHasta)
  AND v.estado_venta = 'PAGADA'
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY total_vendido DESC, c.nombre_categoria;
GO

/* C. Índice compuesto por los predicados de estado y fecha. */
CREATE NONCLUSTERED INDEX IX_venta_estado_fecha
    ON dbo.venta (estado_venta, fecha_hora);
GO

/* Actualizar estadísticas y repetir exactamente la consulta. */
UPDATE STATISTICS dbo.venta IX_venta_estado_fecha WITH FULLSCAN;
GO
DECLARE @FechaDesde2 DATE = '2025-06-01';
DECLARE @FechaHasta2 DATE = '2025-06-07';

SELECT c.id_categoria, c.nombre_categoria,
       COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
       COUNT(*) AS cantidad_renglones,
       SUM(vd.cantidad) AS unidades_vendidas,
       SUM(vd.cantidad * vd.precio_unitario) AS total_vendido
FROM dbo.venta AS v
INNER JOIN dbo.venta_detalle AS vd ON vd.id_venta = v.id_venta
INNER JOIN dbo.producto AS p ON p.id_producto = vd.id_producto
INNER JOIN dbo.categoria AS c ON c.id_categoria = p.id_categoria
WHERE v.fecha_hora >= @FechaDesde2
  AND v.fecha_hora < DATEADD(DAY, 1, @FechaHasta2)
  AND v.estado_venta = 'PAGADA'
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY total_vendido DESC, c.nombre_categoria;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* Repetir B y C y comparar la segunda ejecución para reducir el efecto de caché.
   No activar OPTION (RECOMPILE) solo en una de las variantes. */
