# Por qué no hay documentos separados de 1FN y 2FN

## Motivo

Las formas normales son acumulativas: para que una tabla esté en 2FN tiene que cumplir la 1FN, y para estar en 3FN tiene que cumplir la 2FN. Por lo tanto, un modelo que está en 3FN cumple también la 1FN y la 2FN.

Cuando se armó por primera vez el modelo relacional a partir del DER, el resultado ya cumplía la 1FN y la 2FN, y además la 3FN. Como no hubo ningún modelo anterior con problemas que corregir, no se generaron versiones intermedias del modelo, y se documentó directamente el modelo final en `diagrama_relacional_3fn.md`.

## Verificación de la 1FN

Una tabla está en 1FN si todos sus atributos contienen valores atómicos, no hay grupos repetidos y cada tabla tiene una clave primaria.

- Los ingredientes de un producto no se guardan en un único campo, sino en la tabla `producto_ingrediente`, con una fila por cada ingrediente.
- Los productos de una venta no se guardan dentro de `venta`, sino en la tabla `venta_detalle`, con una fila por cada producto.
- Los datos personales (nombre, apellido, DNI, teléfono, email) están en campos separados y cada uno guarda un solo valor.

## Verificación de la 2FN

Una tabla está en 2FN si cumple la 1FN y ningún atributo que no es clave depende de solo una parte de una clave compuesta. Por eso, la 2FN solo puede romperse en tablas con clave compuesta.

En este modelo solo hay dos tablas con clave compuesta:

| Tabla | Clave primaria | ¿Cumple 2FN? | Justificación |
|---|---|---|---|
| `producto_ingrediente` | (`id_producto`, `id_ingrediente`) | Sí | `cantidad_necesaria` depende del par completo: cuánto de ese ingrediente lleva ese producto. |
| `venta_detalle` | (`id_venta`, `id_producto`) | Sí | `cantidad` y `precio_unitario` dependen del par completo: corresponden a ese producto en esa venta. |

El resto de las tablas tienen clave primaria simple, por lo que cumplen la 2FN de forma directa.

## Conclusión

Como el modelo cumplió la 1FN y la 2FN desde el primer diseño, no fue necesario crear documentos separados para esas etapas. Con la 3FN documentada queda cubierta toda la normalización del proyecto.
