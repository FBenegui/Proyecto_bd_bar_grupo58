# Optimización del informe de ventas por categoría

## Índices

Un índice es una estructura auxiliar que mantiene SQL Server ordenada por una o más columnas una referencia a las filas de una tabla. Se parece al índice de un libro: permite localizar filas que cumplen un filtro sin recorrer necesariamente la tabla completa. Un índice no cambia el resultado de la consulta.

**Ventajas:** reduce lecturas y, en consultas selectivas, puede disminuir el tiempo; también puede ayudar a ordenar, agrupar o resolver uniones. Las columnas `INCLUDE` pueden cubrir datos que la consulta necesita sin formar parte del orden de búsqueda.

**Desventajas:** ocupa almacenamiento y requiere mantenimiento; insertar, modificar o borrar filas puede tardar más porque SQL Server también actualiza los índices. Un índice mal elegido o redundante puede no ayudar, y el optimizador puede preferir otro plan según los datos y las estadísticas.

## Consulta evaluada e índice

Se evalúa el informe existente en [`informe_ventas.sql`](../../sql/consultas/informe_ventas.sql), que une `venta`, `venta_detalle`, `producto` y `categoria`, y limita las ventas al estado `PAGADA` y a un intervalo de fechas. La consulta se mantiene igual en las dos mediciones.

El índice propuesto es:

```sql
CREATE NONCLUSTERED INDEX IX_venta_estado_fecha
    ON dbo.venta (estado_venta, fecha_hora);
```

El estado usa una igualdad y la fecha un rango, por eso se ubican en ese orden. `id_venta` es la clave agrupada de la tabla y SQL Server la incorpora como localizador en el índice no agrupado. El script de índice para la base real está separado en [`indice_ventas.sql`](../../sql/tecnico/optimizacion/indice_ventas.sql), para que no se aplique accidentalmente durante las pruebas.

## Prueba reproducible

La guía sugiere un millón de registros. El archivo [`optimizacion_ventas_benchmark.sql`](../../sql/consultas/optimizacion_ventas_benchmark.sql) crea la base independiente `Gestion_Bar_Benchmark`, con un millón de ventas sintéticas y dos millones de renglones de detalle. La consulta conserva los cuatro `JOIN`, agregaciones y filtros del informe original. Las tablas de prueba no pertenecen a `Gestion_Bar` y no contienen datos reales del bar.

Ejecutar en SQL Server Management Studio:

1. Ejecutar la sección A una vez para preparar la base de pruebas.
2. Activar **Incluir plan de ejecución real** (`Ctrl+M`).
3. Ejecutar la sección B, antes de crear el índice. Guardar el resultado, el plan real y los mensajes de `STATISTICS IO` y `STATISTICS TIME`.
4. Ejecutar la sección C para crear el índice y repetir el informe. Guardar las mismas evidencias.
5. Para una comparación más justa, repetir ambas consultas y registrar la segunda ejecución, cuando las páginas suelen estar en caché. Usar el mismo equipo, base, rango, configuración y condiciones.

El script completo contiene A, B y C en ese orden. Si se ejecuta completo, la medición B corresponde a la base sin el índice adicional y C a la base indexada. La preparación recrea las tablas sintéticas, por lo que no debe ejecutarse de nuevo si se quieren conservar las mediciones anteriores.

## Resultados medidos

Prueba ejecutada en SQL Server 2025 Express (17.0 RTM), instancia `.\SQLEXPRESS`, base aislada `Gestion_Bar_Benchmark`, con 1.000.000 de ventas y 2.000.000 de renglones de detalle. Se utilizó el rango 1–7 de junio de 2025 y estado `PAGADA`. Son tiempos de una ejecución por variante; sirven como evidencia de esta máquina, no como una garantía para otros equipos. Las lecturas físicas fueron cero en ambas mediciones.

| Variante | Tiempo transcurrido (ms) | CPU (ms) | Lecturas lógicas `venta` | `venta_detalle` | `producto` | `categoria` | `Worktable` | Total de lecturas reportadas |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Sin índice adicional | 420 | 281 | 3969 | 8696 | 2 | 10 | 27957 | 40634 |
| Con `IX_venta_estado_fecha` | 325 | 266 | 3969 | 8696 | 2 | 10 | 27957 | 40634 |

El tiempo transcurrido medido fue 95 ms menor (22,6 %) en la segunda ejecución; el CPU fue 15 ms menor (5,3 %). Sin embargo, las lecturas lógicas no bajaron: la reducción fue 0 %. Como se midió una ejecución de cada variante y la consulta posterior pudo beneficiarse de caché, no se puede atribuir esa diferencia de tiempo al índice. En esta prueba SQL Server no redujo las páginas leídas de `venta`; el índice compuesto creado no produjo una mejora demostrable en lecturas para este plan y conjunto de datos. La consulta devuelve las mismas cinco categorías y los mismos totales en ambas variantes.

`STATISTICS IO` también reportó dos lecturas del worktable y cero lecturas de workfile. En el plan sin índice, SSMS sugiere el índice compuesto `(estado_venta, fecha_hora)` como índice faltante. En el plan posterior, el optimizador continúa usando `Clustered Index Scan` sobre `venta`, en lugar de buscar por `IX_venta_estado_fecha`; esto explica que las lecturas de `venta` no hayan bajado. Ambos planes muestran agregaciones hash, un `Merge Join` y ordenamiento. Para medir un efecto atribuible al índice con más confianza, volver a ejecutar B y C varias veces en orden alternado y comparar ejecuciones con la misma condición de caché.

## Capturas para la entrega

- [Estadísticas IO/TIME sin índice](capturas/estadisticas_sin_indice.png).
- [Estadísticas IO/TIME con el índice](capturas/estadisticas_con_indice.png).
- [Plan real sin índice](capturas/plan_sin_indice.png).
- [Plan real con el índice](capturas/plan_con_indice.png).

En cada captura conviene dejar visible el nombre de la base `Gestion_Bar_Benchmark`. El plan estimado no reemplaza al real; `Ctrl+M` permite obtener el plan real en SSMS.
