# Reporte agregado de ventas por categoría

## Necesidad de información

Conocer cuánto dinero se vendió por cada categoría de producto durante un período, junto con la cantidad de ventas, renglones y unidades involucradas. El reporte permite comparar el aporte de categorías como Botellas, Cócteles o Cervezas Tiradas.

## Estrategia SQL

La consulta está en [`sql/consultas/informe_ventas.sql`](../../sql/consultas/informe_ventas.sql) y relaciona cuatro tablas mediante `JOIN`: `venta`, `venta_detalle`, `producto` y `categoria`. Agrupa los renglones por categoría y calcula:

- `COUNT(DISTINCT id_venta)`: cantidad de ventas diferentes que incluyeron productos de esa categoría.
- `COUNT(*)`: cantidad de renglones de detalle de esa categoría.
- `SUM(cantidad)`: unidades vendidas.
- `SUM(cantidad * precio_unitario)`: importe total vendido, usando el precio registrado en cada detalle.

El rango de ejemplo comprende desde el 24/09/2026 hasta el 30/09/2026 inclusive. Para incluir el día final completo aun cuando `fecha_hora` tenga hora, se filtra desde la fecha inicial y antes del día siguiente a la fecha final. Se cuentan únicamente ventas con estado `PAGADA`; quedan fuera las canceladas y pendientes. Para consultar otro período se modifican `@FechaDesde` y `@FechaHasta` en el script.

## Resultado esperado

Con los datos de prueba incluidos en `sql/dml/datos_prueba.sql`, el resultado esperado, ordenado por total vendido de mayor a menor, es:

| Categoría | Ventas | Renglones | Unidades | Total vendido |
|---|---:|---:|---:|---:|
| Botellas | 2 | 3 | 3 | $34.500,00 |
| Bebidas sin alcohol | 5 | 6 | 17 | $32.500,00 |
| Tragos Directos | 3 | 3 | 7 | $31.500,00 |
| Cervezas Tiradas | 2 | 2 | 5 | $17.500,00 |
| Cócteles | 2 | 2 | 3 | $16.200,00 |

Las categorías sin ventas pagadas en el período no aparecen porque la consulta parte de las ventas y utiliza `INNER JOIN`.

Los importes se calculan con el precio unitario histórico guardado en `venta_detalle`, no con el precio actual de `producto`.
