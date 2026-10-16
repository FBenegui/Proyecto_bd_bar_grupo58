# Reporte de Clientes Frecuentes

## Necesidad de información
El bar requiere identificar a sus clientes más valiosos combinando dos métricas clave de comportamiento: **frecuencia de consumo** y **volumen de gasto acumulado**. La consulta busca detectar a aquellos clientes registrados que posean 3 o más compras con estado `PAGADA` y cuyo gasto total supere un umbral mínimo (por ejemplo, $40.000). Este listado permite segmentar a la clientela habitual para otorgarle promociones exclusivas, beneficios de fidelización o descuentos especiales.

## Estrategia SQL
La consulta se encuentra alojada en [`sql/consultas/clientes_vip.sql`](../../sql/consultas/clientes_vip.sql) y combina las tablas `cliente`, `venta` y `venta_detalle` aplicando una subconsulta y una condición avanzada:

- **Subconsulta (`venta_totales`)**: Agrupa los registros de `venta_detalle` por cada `id_venta` e `id_cliente` filtrando únicamente las ventas con estado `'PAGADA'`, calculando así el monto total de cada ticket de compra individual.
- **Join Principal (`INNER JOIN`)**: Conecta la subconsulta con la tabla principal `cliente` para extraer los datos personales de la persona (ID, Nombre y Apellido).
- **Agrupamiento y Filtros (`GROUP BY` y `HAVING`)**: 
  - `GROUP BY`: Agrupa los datos por los campos identificatorios del cliente.
  - `HAVING COUNT(venta_totales.id_venta) >= 2`: Exige que el cliente tenga un mínimo de 2 compras o visitas distintas registradas.
  - `HAVING SUM(venta_totales.monto_venta) > 40000`: Exige que el dinero acumulado en esas compras supere los $40.000.
- **Ordenamiento (`ORDER BY`)**: Presenta el listado ordenado de mayor a menor según el gasto total acumulado, desempatando por la cantidad de compras realizadas.

## Resultado esperado
Con los datos de prueba cargados en `sql/dml/datos_prueba.sql`, el reporte devuelve una tabla consolidada con los clientes frecuentes de alto ticket, mostrando su identificación, nombre, apellido, cantidad de compras efectuadas y el gasto total invertido en el local.